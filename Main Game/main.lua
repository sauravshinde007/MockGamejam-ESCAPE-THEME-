WINDOW_HEIGHT=750
WINDOW_WIDTH=1300

Player={}
Player.width=50
Player.height=50
Player.y=WINDOW_HEIGHT/2-Player.height/2
Player.x=WINDOW_WIDTH-Player.width
Player.speed=75


function love.load()
    love.window.setMode(WINDOW_WIDTH,WINDOW_HEIGHT)
    
end

function love.update(dt)

    --player movement
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
    
end

function love.draw()

    --player
    -- love.graphics.rectangle(mode,x,y,width,height)
    love.graphics.rectangle("fill",Player.x,Player.y,Player.width,Player.height)
    
end