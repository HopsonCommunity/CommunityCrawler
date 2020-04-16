function drawDebug()

    love.graphics.translate(-player.x * 32 + (love.graphics.getWidth() / 2), -player.y * 32 + (love.graphics.getHeight() / 2))

    love.graphics.print(player.xVelocity .. " " .. player.yVelocity, player.x * 32, player.y * 32 - 64)
    love.graphics.print(player.x .. " " .. player.y, player.x * 32, player.y * 32 - 32)
    love.graphics.print(leftX .. " " .. topY, leftX * 32, topY * 32)
    love.graphics.print(rightX .. " " .. bottomY, rightX * 32, bottomY * 32)

    local pushValue = 0.1
    love.graphics.reset()

    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
    love.graphics.print("Map Size:   X: " .. math.abs(leftX) + math.abs(rightX) .. "   Y:" .. math.abs(topY) + math.abs(bottomY), 0, 16)
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
