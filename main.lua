require 'globals'
require "utils"
require "tiles"
require "player"
require "mapGenerator"

function love.load()
    player = Player()
    player:load()

    --math.randomseed(os.clock())
    math.randomseed(1337)
    --generateMap()
    tmpMap()
end

function love.update(dt)
    player:update(dt)
end

function love.draw()
    love.graphics.reset()
    love.graphics.push()

    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.translate(-player.x + (love.graphics.getWidth() / 2), -player.y + (love.graphics.getHeight() / 2))

    for k, v in pairs(tileMap) do
        local coords = split(k, " ")
        love.graphics.draw(v.texture, coords[1], coords[2])
    end

    love.graphics.draw(player.texture, player.x, player.y)
    love.graphics.print(leftX .. " " .. topY, leftX, topY)
    love.graphics.print(rightX .. " " .. bottomY, rightX, bottomY)
    love.graphics.reset()
    love.graphics.print(love.timer.getFPS(), 32, 32)
    love.graphics.pop()
end
