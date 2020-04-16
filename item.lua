require "full"
Item = class:new()

function Item:load(id, name, description, type, minDmg, maxDmg, critMultiplier)
    self.id = id
    self.name = name
    self.description = description
    self.type = type
    self.dmg = math.random(minDmg, maxDmg)
    self.critMultiplier = critMultiplier
    self.texture = loadImage("items", self.id)
end

function itemFactory(id)
    local item = Item()
    if id == "luger" then
        item:load("luger", "Luger", "A WW2 German pistol.", "gun", 3, 5, 1.1)
    end
    return item
end
