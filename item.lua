require "full"
Item = class:new()

function Item:load(id, name, description, type, minDmg, maxDmg, critMultiplier, cooldown, bulletNum, spread)
    self.id = id
    self.name = name
    self.description = description
    self.type = type
    self.minDmg = minDmg
    self.maxDmg = maxDmg
    self.critMultiplier = critMultiplier
	self.cooldown = cooldown or 0.2
	self.bulletNum = bulletNum or 1
	self.spread = spread
    self.texture = loadImage("items", self.id)
end

function itemFactory(id)
    local item = Item()
    if id == "luger" then
        item:load("luger", "Luger", "A WW2 German pistol.", "gun", 3, 5, 1.1, 0.2)
    elseif id == "pocketShotgun" then
        item:load("pocketShotgun", "Pocket Shotgun", "A shotgun. That fits in your pocket.", "gun", 3, 5, 1.3, 1, 5, 15)
    end
    return item
end
