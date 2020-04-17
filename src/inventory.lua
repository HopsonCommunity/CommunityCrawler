inventory = {hotbar = {}, selected = 1}
inventory.hotbarIcon = loadImage("GUI", "hotbarIcon")
inventory.hotbarIconSelected = loadImage("GUI", "hotbarSelected")

inventory.hotbar[1] = itemFactory("luger")
inventory.hotbar[2] = itemFactory("pocketShotgun")
inventory.hotbar[3] = itemFactory("sword")
inventory.hotbar[4] = "none"


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
    if inventory.hotbar[1].id ~= nil then
        love.graphics.draw(inventory.hotbar[1].texture, love.graphics.getWidth()/2 - 48 - 48 - 48 - 5 - 5 + 8, love.graphics.getHeight() - 48 - 32 - 24 + 8)
    end

    if inventory.hotbar[2].id ~= nil then
        love.graphics.draw(inventory.hotbar[2].texture, love.graphics.getWidth()/2 - 48 - 48 - 5 + 8, love.graphics.getHeight() - 48 - 32 - 24 + 8)
    end

    if inventory.hotbar[3].id ~= nil then
        love.graphics.draw(inventory.hotbar[3].texture, love.graphics.getWidth()/2 + 48 + 5 + 8, love.graphics.getHeight() - 48 - 32 - 24 + 8)
    end

    if inventory.hotbar[4].id ~= nil then
        love.graphics.draw(inventory.hotbar[4].texture, love.graphics.getWidth()/2 + 48 + 48 + 5 + 5 + 8, love.graphics.getHeight() - 48 - 32 - 24 + 8)
    end
end
