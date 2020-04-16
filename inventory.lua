inventory = {hotbar = {}, selected = 1}

inventory.hotbar[1] = "luger"
inventory.hotbar[2] = "none"
inventory.hotbar[3] = "none"
inventory.hotbar[4] = "none"
inventory.hotbarIcon = loadImage("GUI", "hotbarIcon")
inventory.hotbarIconSelected = loadImage("GUI", "hotbarSelected")

function inventory.draw()
    if inventory.selected == 1 then
        love.graphics.draw(inventory.hotbarIconSelected, love.graphics.getWidth()/2 - 48 - 48 - 48 - 5 - 5, love.graphics.getHeight() - 48 - 32 - 24)
    else
        love.graphics.draw(inventory.hotbarIcon, love.graphics.getWidth()/2 - 48 - 48 - 48 - 5 - 5, love.graphics.getHeight() - 48 - 32 - 24)
    end

    if inventory.selected == 2 then
        love.graphics.draw(inventory.hotbarIconSelected, love.graphics.getWidth()/2 - 48 - 48 - 5, love.graphics.getHeight() - 48 - 32 - 24)
    else
        love.graphics.draw(inventory.hotbarIcon, love.graphics.getWidth()/2 - 48 - 48 - 5, love.graphics.getHeight() - 48 - 32 - 24)
    end

    if inventory.selected == 3 then
        love.graphics.draw(inventory.hotbarIconSelected, love.graphics.getWidth()/2 + 48 + 5, love.graphics.getHeight() - 48 - 32 - 24)
    else
        love.graphics.draw(inventory.hotbarIcon, love.graphics.getWidth()/2 + 48 + 5, love.graphics.getHeight() - 48 - 32 - 24)
    end

    if inventory.selected == 4 then
        love.graphics.draw(inventory.hotbarIconSelected, love.graphics.getWidth()/2 + 48 + 48 + 5 + 5, love.graphics.getHeight() - 48 - 32 - 24)
    else
        love.graphics.draw(inventory.hotbarIcon, love.graphics.getWidth()/2 + 48 + 48 + 5 + 5, love.graphics.getHeight() - 48 - 32 - 24)
    end
    inventory.drawItems()
end

function inventory.drawItems()
    if inventory.hotbar[1] ~= "none" then
        love.graphics.draw(luger, love.graphics.getWidth()/2 - 48 - 48 - 48 - 5, love.graphics.getHeight() - 48 - 32 - 24 + 5)
    end

    if inventory.hotbar[2] ~= "none" then
        love.graphics.draw(luger, love.graphics.getWidth()/2 - 48 - 48 - 5, love.graphics.getHeight() - 48 - 32 - 24)
    end

    if inventory.hotbar[3] ~= "none" then
        love.graphics.draw(luger, love.graphics.getWidth()/2 + 48 + 5, love.graphics.getHeight() - 48 - 32 - 24)
    end

    if inventory.hotbar[4] ~= "none" then
        love.graphics.draw(luger, love.graphics.getWidth()/2 + 48 + 48 + 5 + 5, love.graphics.getHeight() - 48 - 32 - 24)
    end
end
