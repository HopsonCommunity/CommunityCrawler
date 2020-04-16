require "full"
Projectile = class:new()

function Projectile:load()
    self.texture = loadImage("projectiles", "testBullet")
    self.x = 0
    self.y = 0
    self.lifespan = 120
    self.angle = 0
    self.facing = "right"
end
