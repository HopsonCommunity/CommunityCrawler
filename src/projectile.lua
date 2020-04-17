require "libs.SECL.full"
Projectile = class:new()

function Projectile:load()
    self.x = 0
    self.y = 0
    self.angle = 0
    self.facing = "right"
    self.lifespan = 120
    self.speed = 8

    self.id = "testBullet"
    self.name = "test bullet"
    self.description = "test bullet"
    self.minDmg = 1.5
    self.maxDmg = 1.5
    self.critMultiplier = 1.1
    self.critChance = 1
    self.texture = loadImage("projectiles", self.id)
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
