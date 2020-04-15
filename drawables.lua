function drawDebug()

    love.graphics.translate(-player.x * 32 + (love.graphics.getWidth() / 2), -player.y * 32 + (love.graphics.getHeight() / 2))

    love.graphics.print(player.x .. " " .. player.y, player.x * 32, player.y * 32 - 32)
    love.graphics.print(leftX .. " " .. topY, leftX * 32, topY * 32)
    love.graphics.print(rightX .. " " .. bottomY, rightX * 32, bottomY * 32)

    local pushValue = 0.1
    love.graphics.reset()

    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
    love.graphics.print("Map Size:   X: " .. math.abs(leftX) + math.abs(rightX) .. "   Y:" .. math.abs(topY) + math.abs(bottomY), 0, 16)

end
