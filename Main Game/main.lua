WINDOW_HEIGHT=750
WINDOW_WIDTH=750

--------------------------Player------------------------------------------
Player={}
Player.width=50
Player.height=50
Player.y=WINDOW_HEIGHT-Player.height
Player.x=WINDOW_WIDTH/2-Player.width/2
Player.speed=75

--------------------------Bullets---------------------------------------------
function createbullets()
    local bullet={}
    bullet.width=5
    bullet.height=15
    bullet.x=Player.x+Player.width/2-bullet.width/2
    bullet.y=Player.y-bullet.height
    bullet.speed=500
    return bullet
    
end

all_bullets={}


function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    timer=0
    
end

function love.update(dt)

    timer=timer+dt

    -----------------------player movement-----------------------------------------------------

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

    -----------------------bullet function and movement-----------------------------------------

    if love.keyboard.isDown("space") then
          if timer>=0.1 then
            table.insert(all_bullets,createbullets())
            timer=0
        end
        
    end

    for k, v in pairs(all_bullets) do
        v.y=v.y-v.speed*dt
    end

    -- to delete extra bullets
    for k, v in pairs(all_bullets) do
        if v.y<-v.height  then
                table.remove(all_bullets,k)  
        end
    end

end

function love.draw()

    --player
    -- love.graphics.rectangle(mode,x,y,width,height)
    love.graphics.rectangle("fill",Player.x,Player.y,Player.width,Player.height)

    --bullet
    for k, v in pairs(all_bullets) do
        love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
        
    end

    love.graphics.print(#all_bullets,25,25)
    
end