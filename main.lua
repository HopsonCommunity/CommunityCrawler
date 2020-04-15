require 'globals'
require "utils"
require "tiles"
require "player"
require "mapGenerator"
require "drawables"

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

    nim.drawAnim(player.animation, player.x * 32, (player.y - 1) * 32)
    --love.graphics.draw(player.texture, player.x * 32, player.y * 32)

    love.graphics.reset()
    if player.debugMode then
        drawDebug()
    end

    love.graphics.pop()
end
