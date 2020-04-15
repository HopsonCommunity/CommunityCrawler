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
    player.animation.currentTime = player.animation.currentTime + dt
    if player.animation.currentTime >= player.animation.duration then
        player.animation.currentTime = player.animation.currentTime - player.animation.duration
    end
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

    local spriteNum = math.floor(player.animation.currentTime / player.animation.duration * #player.animation.quads) + 1
    love.graphics.draw(player.animation.spriteSheet, player.animation.quads[spriteNum], player.x * 32, player.y*32, 0, 1, 1, 0, 32)
    --love.graphics.draw(player.texture, player.x * 32, player.y * 32)

    love.graphics.reset()
    if player.debugMode then
        drawDebug()
    end

    love.graphics.pop()
end
