-- Escape THeme Game (Mock Game Jam)

-- Top Down Game

-- 1.Player can move in all directions
-- 2.Player can shoot with directions given by the mouse
-- 3.Enemies will be spawned randomly anywhere and will follow you and decrease your health
-- 4.You can either kill enmies for high score but ultimately "ESCAPE" the world/room.

--------------------------Start-------------------------------------------------

WINDOW_HEIGHT=750
WINDOW_WIDTH=750

math.randomseed(os.time())-- will generate a random number depending on time

--------------------------Bullets---------------------------------------------

all_bullets={}
all_enemies={}

--spawning enmies
function spawnEnemy()
    enemy={}
    enemy.x=math.random(0,love.graphics.getWidth())
    enemy.y=math.random(0,love.graphics.getHeight())
    enemy.width=32
    enemy.height=32
    enemy.speed=100
    enemy.health_width=enemy.width
    enemy.health_height=5

    return enemy
end

---enemy to follow player
function updateEnemyAI(enemy,dt)
    local dx = Player.x - enemy.x
    local dy = Player.y - enemy.y
    local angle = math.atan2(dy, dx)

    enemy.x = enemy.x + math.cos(angle) * enemy.speed * dt
    enemy.y = enemy.y + math.sin(angle) * enemy.speed * dt
    
end


--------------------------Collision functionality-------------------------------------------
function Collision(v,k)
    return v.x<k.x+k.width and
           v.x+v.width>k.x and
           v.y<k.y+k.height and
           v.y+v.height>k.y
  end

--will contain last location of the mouse
 lastMouseX, lastMouseY = love.mouse.getPosition()


------------------------------Love Load----------------------------------------------------------

function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    timer=0 --for bullets
    timer2=0 --for enemies
    score=0 ---score of the player
    -- Set the mouse cursor visibility to false
    love.mouse.setVisible(false)

    --player 
    Player={}
    Player.image=love.graphics.newImage("survivor-idle_rifle_0.png")
    Player.width=30
    Player.height=30
    Player.y=WINDOW_HEIGHT-Player.height
    Player.x=WINDOW_WIDTH/2-Player.width/2
    Player.speed=200
    Player.health_width=150
    Player.health_height=20
    Player.angle=0
    Player.roationspeed=10
    Player.health=100

    --images for the games
    player_image=love.graphics.newImage("survivor-idle_rifle_0.png")
    crosshair_image = love.graphics.newImage('crosshair.png')
    crosshair_width = crosshair_image:getWidth()
    crosshair_height = crosshair_image:getHeight()

    --sounds for the game
    mainmenu_sfx=love.audio.newSource("MainMenu.mp3","stream")
    maingame_sfx=love.audio.newSource("MainGame.mp3","stream")
    gun_sfx=love.audio.newSource("gunshots.mp3","static")
    damage_sfx=love.audio.newSource("damage.mp3","static")
    gameover_sfx=love.audio.newSource("GameOver.mp3","stream")

    --states in the game:
    -- 1.Main Menu
    -- 2.End
    -- 3.Escape Menu
    -- 4.Level 1
    -- 5.Level 2 and so on
    
    state="Main Menu"
    
    
end


------------------------------------------Love Update-----------------------------------------------------------

function love.update(dt)
    
    --for bullet
    timer=timer+dt

    --for enemy
    timer2=timer2+dt

    if state=="Main Menu" then

        --plays main menu sound
        mainmenu_sfx:play()

        --to enter play state
        if love.keyboard.isDown("return") then
            state="Level 1"
        end
        
    

    elseif state=="Level 1" then

        --MainGame sound
        maingame_sfx:play()
        mainmenu_sfx:stop()
        gameover_sfx:stop()



            ---------------------------mouse movement for player--------------------------------------------
        --will find out mouse location
        local mouseX, mouseY = love.mouse.getX() , love.mouse.getY()

        -- --will maintain direction of player
        -- if mouseX~=lastMouseX or mouseY ~=lastMouseY then
        --     Player.angle=math.atan2(mouseY - (Player.y + Player.height / 2), mouseX - (Player.x + Player.width / 2)) 
        -- end


        -- Don't need this
        --will maintain direction of player
        --if mouseX~=lastMouseX or mouseY ~=lastMouseY then
            --local angle= math.atan2(mouseY-Player.y,mouseX-Player.x)
            --local delta= angle-Player.angle
            --delta=(delta+math.pi) % (2 * math.pi) - math.pi -- Wrap to [-pi, pi]
            --Player.angle=Player.angle+ delta*Player.roationspeed*dt
            
        --end

        --lastMouseX,lastMouseY=mouseX,mouseY

        -- This is enough to calc rotation
        Player.angle=math.atan2(mouseY - (Player.y + Player.height / 2), mouseX - (Player.x + Player.width / 2))

        --player movement on keyboard
        if love.keyboard.isDown("a") and Player.x>0 then
            Player.x=Player.x-Player.speed*dt
            
        end
        if love.keyboard.isDown("w") and Player.y>0 then
            Player.y=Player.y-Player.speed*dt
            
        end
        if love.keyboard.isDown("s") and Player.y<WINDOW_HEIGHT-Player.height then
            Player.y=Player.y+Player.speed*dt
            
        end
        if love.keyboard.isDown("d") and Player.x<WINDOW_WIDTH-Player.width then
            Player.x=Player.x+Player.speed*dt
            
        end

        -----------------------bullet creation and deletion acc to mouse-----------------------------------------------------
        if love.mouse.isDown(1) then
            if timer>=0.1 then

                gun_sfx:play()
            
                local bulletspeed=750

                local bullet={}
                bullet.width=5
                bullet.height=15
                -- bullet.x=Player.x+Player.width/2-bullet.width/2
                -- bullet.y=Player.y+Player.height/2-bullet.height/2
                bullet.x=Player.x+Player.width/2
                bullet.y=Player.y+Player.height/2
                bullet.dx= bulletspeed*math.cos(Player.angle)
                bullet.dy= bulletspeed*math.sin(Player.angle)

                table.insert(all_bullets,bullet)

                timer=0
            end
            
        end

        --------------------------bullet movement-----------------------------------------------------
        for k, v in pairs(all_bullets) do
            --bullet movement acc to mouse
            v.x=v.x+v.dx*dt
            v.y=v.y+v.dy*dt

            --removing extra bullets of the screen
            if v.x>WINDOW_WIDTH-v.width or v.x<0 or v.y>WINDOW_HEIGHT or v.y<-v.height  then
                table.remove(all_bullets,k)
                
            end
            
        end

        --------------------------Enemies creation and Deletion--------------------------------

         -- ---------- enemy-----------------
         if timer2>=1 then
            table.insert(all_enemies,spawnEnemy())
            timer2=0
        end

        --enemy movement
        for k, v in pairs(all_enemies) do
            updateEnemyAI(v,dt)
            
        end

        -------------Collisions in game------------------------
        --b/w bullet and enemy
        for key, value in pairs(all_enemies) do
            for k, v in pairs(all_bullets) do
                if Collision(value,v) then
                    table.remove(all_bullets,k)
                    
                    value.health_width=value.health_width-value.width/3
                    if value.health_width<=0 then
                        table.remove(all_enemies,key)
                        score=score+1
                        
                    end
                                
                end
                        
            end
                    
        end

        --b/w enemy and player
        for k, v in pairs(all_enemies) do
            if Collision(v,Player) then
                table.remove(all_enemies,k)
                Player.health_width=Player.health_width*0.833
                damage_sfx:play()
                Player.health=Player.health-10
   
            end
            
        end

        --to end the game
        if Player.health==0 then
            state="End"
            
        end

        
    elseif state=="End" then
        maingame_sfx:stop()
        gameover_sfx:play()

        if love.keyboard.isDown("return") then
            state="Level 1"

            --wil make intial situation of the game
            Player.health=100
            score=0
            timer2=0
        end

    end

    

    end


-----------------------------------Love Draw--------------------------------------------------

function love.draw()

    if state=="Main Menu" then
        
    elseif state=="Level 1"  then

            --font for the text
        local font1=love.graphics.newFont("ARIALBD 1.TTF")
        local font2=love.graphics.newFont("Akira Expanded Demo.otf")


        -- love.graphics.rectangle(mode,x,y,width,height)
        -- love.graphics.setColor(1,1,1)
        -- love.graphics.rectangle("fill",Player.x,Player.y,Player.width,Player.height)
        -- love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)
    

        --bullet
        for k, v in pairs(all_bullets) do
            -- love.graphics.circle(mode,x,y,radius)
            love.graphics.setColor(1,1,1)
            love.graphics.circle("fill",v.x,v.y,3)
            
        end

        --player drawing
        love.graphics.setColor(1,1,1)
        centerX = Player.x + Player.width/2
        centerY = Player.y + Player.height/2
        love.graphics.draw(Player.image, centerX, centerY, Player.angle, 0.2, 0.2, centerX * 0.2, centerY * 0.2)

        -- For Debugging
        --love.graphics.circle("fill", centerX, centerY, 5)
        --love.graphics.rectangle("line",Player.x,Player.y,Player.width,Player.height)

        --to make players health
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(font2)
        love.graphics.print("Player's Health",30,30,0,1.1,1.1)
        -- love.graphics.print(text,x,y,r,sx,sy,ox,oy)

        -- --player health bar
        -- love.graphics.setColor(0,1,0)
        -- love.graphics.rectangle("fill",30,50,Player.health_width,Player.health_height)
        -- love.graphics.setColor(0,0,0)
        -- love.graphics.rectangle("line",30,50,150,20)

        --Players Health Points
        love.graphics.setColor(0,1,0)
        love.graphics.setFont(font2)
        love.graphics.print(Player.health,30,50,0,1.1,1.1)


        --enemy health bar
        for k, v in pairs(all_enemies) do
            love.graphics.setColor(1,0,0)
            love.graphics.rectangle("fill",v.x-20,v.y-20,v.health_width,v.health_height)
            
        end

        --display score
        love.graphics.setFont(font2)
        love.graphics.setColor(1,1,1)
        -- love.graphics.print(text,x,y,r,sx,sy,ox,oy)
        love.graphics.print("SCORE",WINDOW_WIDTH-90,30,0,1.1,1.1)
        love.graphics.print(score,WINDOW_WIDTH-50,50,0,1.1,1.1)
       

        --no of bullets generated
        love.graphics.print(#all_bullets,15,15)

    
        -- -- Draw the mouse cursor
        love.graphics.setColor(1, 0, 0)
        love.graphics.draw(crosshair_image, love.mouse.getX(), love.mouse.getY(), 0, 0.1, 0.1, crosshair_width/2, crosshair_height/2)

        --enemies
        for k, v in pairs(all_enemies) do
            
            love.graphics.setColor(0,1,1)
            love.graphics.circle("fill",v.x,v.y,10)
            
        end
 
    elseif state=="End" then


    end



end

   