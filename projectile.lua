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
	self.x = self.x + (math.sin(self.angle) * self.speed)*dt*60
	self.y = self.y + (-math.cos(self.angle) * self.speed)*dt*60
end