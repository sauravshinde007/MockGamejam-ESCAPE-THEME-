local Player={}
Player.image=love.graphics.newImage("Sprites/player_img.png")
Player.width=30
Player.height=30
Player.y=WINDOW_HEIGHT-Player.height
Player.x=WINDOW_WIDTH/2-Player.width/2
Player.speed=200
Player.angle=0
Player.roationspeed=10
Player.health=100

return Player
