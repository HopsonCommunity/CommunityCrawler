require "libs.SECL.full"
Ranged = class:new()
Ranged:addparent(Weapon)

Ranged.type = "ranged"
Ranged.cooldownTimer = 0

function Ranged:load(id, name, description, minDmg, maxDmg, critMultiplier, cooldown, bulletNum, spread)
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
end

function Ranged:leftClick(x, y)
    for i = 1, self.bulletNum do
        local newProjectile = Projectile()
        newProjectile:load()
        newProjectile.minDmg = newProjectile.minDmg * self.minDmg
        newProjectile.maxDmg = newProjectile.maxDmg * self.maxDmg
        newProjectile.critMultiplier = newProjectile.critMultiplier * self.critMultiplier
        newProjectile.critChance = newProjectile.critChance * self.critChance
        newProjectile.y = player.y * 32
        local opp = y - love.graphics.getHeight()/2 - player.y
        local adj = x - love.graphics.getWidth()/2 - player.x
        local hyp = math.sqrt(opp * opp + adj * adj)
        local ang = math.asin(opp / hyp)
        if player.facing == "left" then
            newProjectile.x = player.x * 32 - math.cos(ang) * 24 - math.max(math.cos(-ang), 0) * 24
            ang = ang * -1
            ang = ang - math.rad(90)
            newProjectile.y = newProjectile.y + 17
        else
            newProjectile.x = (player.x + 1) * 32 + math.cos(ang) * 24 + math.max(math.cos(ang), 0) * 24
            newProjectile.y = newProjectile.y + 3
            ang = ang + math.rad(90)
        end
        if self.spread then ang = ang + math.rad(math.random(self.spread * 2) - self.spread) end
        newProjectile.angle = ang
        table.insert(projectiles, newProjectile)
    end
    self.cooldownTimer = self.cooldown
end

function Ranged:rightClick(x, y)
end

function Ranged:middleClick(x, y)
end
