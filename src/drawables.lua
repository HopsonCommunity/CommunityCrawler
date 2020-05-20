function drawDebug()

    love.graphics.translate(-player.x * 32 + (love.graphics.getWidth() / 2), -player.y * 32 + (love.graphics.getHeight() / 2))

    love.graphics.print(player.xVelocity .. " " .. player.yVelocity, player.x * 32, player.y * 32 - 64)
    love.graphics.print(player.x .. " " .. player.y, player.x * 32, player.y * 32 - 32)
    love.graphics.print(floors[player.floor].leftX .. " " .. floors[player.floor].topY, floors[player.floor].leftX * 32, floors[player.floor].topY * 32)
    love.graphics.print(floors[player.floor].rightX .. " " .. floors[player.floor].bottomY, floors[player.floor].rightX * 32, floors[player.floor].bottomY * 32)

    local pushValue = 0.1
    love.graphics.reset()

    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
    love.graphics.print("Map Size:   X: " .. math.abs(floors[player.floor].leftX) + math.abs(floors[player.floor].rightX) .. "   Y:" .. math.abs(floors[player.floor].topY) + math.abs(floors[player.floor].bottomY), 0, 16)
    i = 16
    for k, v in pairs(entities) do
        love.graphics.print("Entity #" .. k .. "'s HP: '" .. v.health, 0, i + i*k)
    end
end

function drawChat()
    local font = love.graphics.newFont(16)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.rectangle("fill", 16, love.graphics.getHeight() - 32, 320, 20)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(player.chatWrite, 16, love.graphics.getHeight() - 32, 320, "left")

    local font = love.graphics.newFont(14)
    love.graphics.setFont(font)
end

function drawWholeChat()
    local font = love.graphics.newFont(16)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1, 0.05)
    love.graphics.rectangle("fill", 16, love.graphics.getHeight() - 432, 320, 400)

    love.graphics.setColor(1, 1, 1)
    local len = len(chatTexts)
    for text = 1, len do
        love.graphics.printf(chatTexts[len - text + 1], 16, love.graphics.getHeight() - (text) * 18 - 32, 320, "left")
    end

    local font = love.graphics.newFont(14)
    love.graphics.setFont(font)
end
