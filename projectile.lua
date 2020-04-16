require "full"
Projectile = class:new()

function Projectile:load()
    self.texture = loadImage("projectiles", "testBullet")
    self.x = 0
    self.y = 0
    self.lifespan = 120
    self.angle = 0
    self.facing = "right"
	self.speed = 8
end

function Projectile:update(dt)
    self.mv = {}
	self.mv.x = self.x + (math.sin(self.angle) * self.speed) * dt * 60
	self.mv.y = self.y + (-math.cos(self.angle) * self.speed) * dt * 60
    if tileMap[math.floor((self.mv.x - 0.5)/32) .. " " .. math.floor((self.mv.y - 0.5)/32)] ~= nil and not tileMap[math.floor((self.mv.x - 0.5)/32) .. " " .. math.floor((self.mv.y - 0.5)/32)].solid then
        self.x = self.mv.x
        self.y = self.mv.y
    else
        self.lifespan = 0
    end
end
