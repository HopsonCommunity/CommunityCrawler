require 'globals'
require "utils"
require "tiles"
require "player"
require "mapGenerator"
require "drawables"

lightworld:SetColor(0, 0, 0)

function love.load()
    player = Player()
    player:load()

    --math.randomseed(os.clock())
    math.randomseed(1337)
    --generateMap()
    randWalkMap(1000)
    fillHolesAndSetWalls()
    --exampleMap()
end

function love.update(dt)
    player:update(dt)
	lightworld:Update()
	lightworld:SetPosition(player.x * 32 + (-love.graphics.getWidth() / 2), player.y * 32 + (-love.graphics.getHeight() / 2), 1)
	playerLight:SetPosition((player.x * 32), (player.y * 32))
end

function love.mousepressed(button, x, y)
	
end

function love.draw()
    love.graphics.reset()
    love.graphics.push()
	

    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.translate(-player.x * 32 + (love.graphics.getWidth() / 2), -player.y * 32 + (love.graphics.getHeight() / 2))

    for k, v in pairs(tileMap) do
        local coords = split(k, " ")
        love.graphics.draw(v.texture, coords[1] * 32, coords[2] * 32)
    end

    local flip = player.facing == "left"
    nim.drawAnim(player.animation, player.x * 32, (player.y - 1) * 32, 90, flip)
    --love.graphics.draw(player.texture, player.x * 32, player.y * 32)

    love.graphics.reset()
    if player.debugMode then
        drawDebug()
    end
	lightworld:Draw()

    love.graphics.pop()
end
