local Portal = {}

Portal.width = 50
Portal.height = 50
Portal.x = WINDOW_WIDTH/2-Portal.width/2
Portal.y = 10
Portal.image = love.graphics.newImage("Sprites/portal.png")
Portal.show = false
Portal.pos_set = false

return Portal
