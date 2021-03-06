function itemFactory(id)
    --[[
        Melee:  (id, name, description, minDmg, maxDmg, critMultiplier, cooldown, range)
        Ranged: (id, name, description, minDmg, maxDmg, critMultiplier, cooldown, bulletNum, spread)
    ]]--
    if id == "luger" then
        local item = Ranged()
        item:load("luger", "Luger", "A WW2 German pistol.", 60, 120, 1.1, 0.2, 1, 0)
        return item
    elseif id == "pocketShotgun" then
        local item = Ranged()
        item:load("pocketShotgun", "Pocket Shotgun", "A shotgun. That fits in your pocket.", 60, 120, 1.3, 1, 5, 15)
        return item
    elseif id == "sword" then
        local item = Melee()
        item:load("sword", "Sword", "It's a sword, it doesn't do magic tricks.", 3, 5, 1.5, 0.07, 1.3)
        return item
	elseif id == "flamethrower" then
		local item = Ranged()
        item:load("flamethrower", "Flamethrower", "A shotgun. That fits in your pocket.", 60, 120, 1.3, 0.1, 5, 15, "flame", "auto", nim.newParticle({1, 1, 1}, {1, 0.5, 0}, {1, 0.6, 0.3}, 8, 8, 10, "circle", 0.1, 0.1, 0, 0, 0, 0, 0.95, false, "fill", 0, 0, 0))
        return item
    else
        return nil
    end
end

function droppedItemFactory(id)
	local item = DroppedItem()
	item.id = id
	return item
end

function entityFactory(id)
    if id == "rose" then
        local entity = Entity()
        entity.animFrames = 4
        entity.id = "rose"
        entity.hostile = true
        return entity
    elseif id == "zombie" then
        local entity = Entity()
        entity.animFrames = 4
        entity.id = "zombie"
        entity.hostile = true
        return entity
    elseif id == "skelebomber" then
        local entity = Entity()
        entity.animFrames = 4
        entity.id = "skelebomber"
        entity.hostile = true
        return entity
    elseif id == "crate" then
        local entity = Prop()
        entity.animFrames = 1
        entity.id = "crate"
        return entity
    else
        return nil
    end
end
