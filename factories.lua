function itemFactory(id)
    --[[
        Melee:  (id, name, description, minDmg, maxDmg, critMultiplier, cooldown, range)
        Ranged: (id, name, description, minDmg, maxDmg, critMultiplier, cooldown, bulletNum, spread)
    ]]--
    if id == "luger" then
        local item = Ranged()
        item:load("luger", "Luger", "A WW2 German pistol.", 3, 5, 1.1, 0.2, 1, 0)
        return item
    elseif id == "pocketShotgun" then
        local item = Ranged()
        item:load("pocketShotgun", "Pocket Shotgun", "A shotgun. That fits in your pocket.", 3, 5, 1.3, 1, 5, 15)
        return item
    elseif id == "sword" then
        local item = Melee()
        item:load("sword", "Sword", "It's a sword, it doesn't do magic tricks.", 5, 7, 1.5, 0.07, 1.3)
        return item
    end
end

function entityFactory(id)
    local entity = Entity()
    if id == "rose" then
        entity.animFrames = 4
        entity.id = "rose"
        entity.hostile = true
    elseif id == "zombie" then
        entity.animFrames = 4
        entity.id = "zombie"
        entity.hostile = true
    else return
    end
    return entity
end
