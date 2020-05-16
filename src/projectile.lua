require "libs.SECL.full"
Projectile = class:new()

local projTypes = {
	testBullet = {
		speed = 8,
		minDmg = 1.5,
		maxDmg = 1.5
	},
	flame = {
		speed = 8,
		name = "Flame",
		desc = "Condensed fire",
		minDmg = 0.05,
		maxDmg = 0.1,
		trail = nim.newParticle({1, 0.8, 0.1}, {1, 0.5, 0.1}, {1, 0.8, 0.1}, 4, 4, 8, "square", 0.2, 0.3, -0.2, 0.2, -2, -1, nil, nil, "fill", 0, 0, 180)
	},
}

function Projectile:load(id)
	local p = projTypes[id]
    self.x = 0
    self.y = 0
    self.angle = 0
    self.facing = "right"
    self.lifespan = 120
    self.speed = p.speed

    self.id = id
    self.name = p.name or "test bullet"
    self.description = p.desc or "test bullet"
    self.minDmg = p.minDmg
    self.maxDmg = p.maxDmg
    self.critMultiplier = p.critMult or 1.1
    self.critChance = p.critChance or 1
    self.texture = loadImage("projectiles", self.id)
	self.trail = p.trail or nim.newParticle({0.5, 0.5, 0.5}, {0.5, 0.5, 0.5}, {0.7, 0.7, 0.7}, 4, 4, 8, "square", 0.9, 0.9, -0.2, 0.2, -2, -1, nil, nil, "fill", 0, 0, 180)
	self.trailWait = p.trailWait or 0.05
	self.trailTimer = p.trailTimer or 0
end

function Projectile:update(dt)
	for i = 1, 4 do
		self.mv = {}
        self.mv.x = self.x + ((math.sin(self.angle) * self.speed) * dt * 60) / 4
		self.mv.y = self.y + ((-math.cos(self.angle) * self.speed) * dt * 60) / 4
		if tileMap[math.floor((self.mv.x - 0.5)/32) .. " " .. math.floor((self.mv.y - 0.5)/32)] ~= nil and not tileMap[math.floor((self.mv.x - 0.5)/32) .. " " .. math.floor((self.mv.y - 0.5)/32)].solid then
			self.x = self.mv.x
			self.y = self.mv.y
		else
			self.lifespan = 0
		end
	end
end
