require "full"
Item = class:new()

function Item:load(id, name, description, type, minDmg, maxDmg, critMultiplier, bulletNum, spread)
    self.id = id
    self.name = name
    self.description = description
    self.type = type
    self.minDmg = minDmg
    self.maxDmg = maxDmg
    self.critMultiplier = critMultiplier
	self.bulletNum = bulletNum or 1
	self.spread = spread
    self.texture = loadImage("items", self.id)
end

function itemFactory(id)
    local item = Item()
    if id == "luger" then
        item:load("luger", "Luger", "A WW2 German pistol.", "gun", 3, 5, 1.1)
    elseif id == "pocketShotgun" then
        item:load("pocketShotgun", "Pocket Shotgun", "A shotgun. That fits in your pocket.", "gun", 3, 5, 1.3, 5, 30)
    end
    return item
end
