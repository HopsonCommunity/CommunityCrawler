inventory = {
    hotbar = {},
    inv = {},
    selected = 1,
    size = 4,
    invIsOpen = false
}
inventory.hotbarIcon = loadImage("GUI", "hotbarIcon")
inventory.hotbarIconSelected = loadImage("GUI", "hotbarSelected")

inventory.hotbar[1] = itemFactory("luger")
inventory.hotbar[2] = itemFactory("pocketShotgun")
inventory.hotbar[3] = itemFactory("sword")
inventory.hotbar[4] = itemFactory("flamethrower")

for i = 1, inventory.size do
    inventory.inv[i] = {}
    for j = 1, inventory.size do
        inventory.inv[i][j] = nil
    end
end

inventory.inv[1][1] = itemFactory("luger")

function inventory.drawInventory()
    for i = -inventory.size/2 + 1, inventory.size/2 do
        for j = -inventory.size/2 + 1, inventory.size/2 do
            love.graphics.draw(inventory.hotbarIcon, love.graphics.getWidth() - 32 + 48*(j - inventory.size + 1), love.graphics.getHeight() - 32 + 48*(i - inventory.size + 1))
            if inventory.inv[i + inventory.size/2][j + inventory.size/2] ~= nil and inventory.inv[i + inventory.size/2][j + inventory.size/2] ~= nil then
                love.graphics.draw(inventory.inv[i + inventory.size/2][j + inventory.size/2].texture, love.graphics.getWidth() - 32 + 48*(j - inventory.size + 1) + 8, love.graphics.getHeight() - 32 + 48*(i - inventory.size + 1) + 8)
            end
        end
    end
end

function inventory.drawHotbar()
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
    inventory.drawHotbarItems()
end

function inventory.drawHotbarItems()
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
