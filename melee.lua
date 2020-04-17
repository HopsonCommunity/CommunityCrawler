require "full"
Melee = class:new()
Melee:addparent(Weapon)

Melee.type = "melee"
Melee.cooldownTimer = 0

function Melee:load(id, name, description, minDmg, maxDmg, critMultiplier, cooldown, range)
    self.id = id
    self.name = name
    self.description = description
    self.minDmg = minDmg
    self.maxDmg = maxDmg
    self.critMultiplier = critMultiplier
    self.cooldown = cooldown
    self.texture = loadImage("items", self.id)
    self.range = range
end

function Melee:leftClick(x, y)
end

function Melee:rightClick(x, y)
end

function Melee:middleClick(x, y)
end
