require "libs.SECL.full"
Ranged = class:new()
Ranged:addparent(Weapon)

Ranged.type = "ranged"
Ranged.cooldownTimer = 0

function Ranged:load(id, name, description, minDmg, maxDmg, critMultiplier, cooldown, bulletNum, spread, bulletType, fireType, muzzleFlash)
    self.id = id
    self.name = name
    self.description = description
    self.minDmg = minDmg
    self.maxDmg = maxDmg
    self.critMultiplier = critMultiplier
    self.cooldown = cooldown or 0.2
	self.bulletNum = bulletNum or 1 -- how many bullets will come out of the gun per click
    self.spread = spread
    self.critChance = 5
    self.texture = loadImage("items", self.id)
	self.bulletType = bulletType or "testBullet"
	self.fireType = fireType or "semi"
	self.muzzleFlash = muzzleFlash or nim.newParticle({1, 1, 1}, {1, 0.8, 0.2}, {1, 0.9, 0.5}, 16, 16, 18, "circle", 0.05, 0.05, 0, 0, 0, 0, 0.95, false, "fill", 0, 0, 0)
end

function Ranged:leftClick(x, y)
    for i = 1, self.bulletNum do
        local newProjectile = Projectile()
        newProjectile:load(self.bulletType)
        newProjectile.minDmg = newProjectile.minDmg * self.minDmg
        newProjectile.maxDmg = newProjectile.maxDmg * self.maxDmg
        newProjectile.critMultiplier = newProjectile.critMultiplier * self.critMultiplier
        newProjectile.critChance = newProjectile.critChance * self.critChance
        newProjectile.y = player.y * 32
		newProjectile.x = player.x * 32
        local my = y - love.graphics.getHeight()/2 - player.y
        local mx = x - love.graphics.getWidth()/2 - player.x
        local ang = -1*math.atan2(-my, mx)-math.rad(20)
        if player.facing == "left" then
			ang = ang + math.rad(180)
			newProjectile.x = newProjectile.x + (math.cos(ang)*16 + 16)*-1
            newProjectile.y = newProjectile.y + (math.sin(ang)*16 + 16)*-1
			ang = ang - math.rad(70)
        else
            newProjectile.x = newProjectile.x + math.cos(ang)*16 + 48
            newProjectile.y = newProjectile.y + math.sin(ang)*16 + 16
			ang = ang + math.rad(115)
        end
        if self.spread then ang = ang + math.rad(math.random(self.spread * 2) - self.spread) end
        newProjectile.angle = ang
		nim.addParticle(self.muzzleFlash, newProjectile.x, newProjectile.y)
        table.insert(projectiles, newProjectile)
    end
    self.cooldownTimer = self.cooldown
end

function Ranged:rightClick(x, y)
end

function Ranged:middleClick(x, y)
end
