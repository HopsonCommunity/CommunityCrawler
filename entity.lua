require "full"
Entity = class:new()

Entity.x = 1
Entity.y = 1
Entity.health = 100
Entity.maxHealth = 100
Entity.xVelocity = 0
Entity.yVelocity = 0
Entity.entitySpeed = 64
Entity.entityAcceleration = 4
Entity.friction = 0.8
Entity.texture = loadImage("entities", "player_modelDefault")
Entity.animations = {
    idle = nim.newAnim(Entity.texture, 32, 64, 1, 1),
    running = nim.newAnim(Entity.texture, 32, 64, 1, 2)
}
Entity.currentAnimation = Entity.animations.idle
function Entity:load()
end

function Entity:hurt(dmg)
    self.health = self.health - dmg
end
function Entity:heal(hp)
    if self.health + hp > self.maxHealth then self.health = self.maxHealth else self.health = self.health + hp end
end

function Entity:move(dt)
    self.xVelocity = self.xVelocity * self.friction
    self.yVelocity = self.yVelocity * self.friction

    if math.abs(self.xVelocity) < 0.001 then self.xVelocity = 0 end
    if math.abs(self.yVelocity) < 0.001 then self.yVelocity = 0 end

    local pushValue = 1/32
    local mv = {}

    mv.x = self.x + self.xVelocity * dt/2
    mv.y = self.y + self.yVelocity * dt/2

    mv.XtopLeft = tileMap[math.floor(mv.x + pushValue) .. " " .. math.floor(self.y + pushValue + 0.5)]
    mv.XbotLeft = tileMap[math.floor(mv.x + pushValue) .. " " .. ceiling (self.y - pushValue)]
    mv.XtopRight = tileMap[ceiling(mv.x - pushValue) .. " " .. math.floor(self.y + pushValue + 0.5)]
    mv.XbotRight = tileMap[ceiling(mv.x - pushValue) .. " " .. ceiling (self.y - pushValue)]

    if (self.x > mv.x) and (mv.XtopLeft ~= nil and not mv.XtopLeft.solid) and (mv.XbotLeft ~= nil and not mv.XbotLeft.solid) or --mv Left
       (self.x < mv.x) and (mv.XtopRight ~= nil and not mv.XtopRight.solid) and (mv.XbotRight ~= nil and not mv.XbotRight.solid) then --mv Right
           self.x = mv.x
    end

    mv.YtopLeft = tileMap[math.floor(self.x + pushValue) .. " " .. math.floor(mv.y + pushValue + 0.5)]
    mv.YtopRight = tileMap[ceiling(self.x - pushValue) .. " " .. math.floor(mv.y + pushValue + 0.5)]
    mv.YbotLeft = tileMap[math.floor(self.x + pushValue) .. " " .. ceiling (mv.y - pushValue)]
    mv.YbotRight = tileMap[ceiling(self.x - pushValue) .. " " .. ceiling (mv.y - pushValue)]

    if (self.y < mv.y) and (mv.YbotLeft ~= nil and not mv.YbotLeft.solid) and (mv.YbotRight ~= nil and not mv.YbotRight.solid) or --mv Down
       (self.y > mv.y) and (mv.YtopLeft ~= nil and not mv.YtopLeft.solid) and (mv.YtopRight ~= nil and not mv.YtopRight.solid) then --mv Up
           self.y = mv.y
    end

end

function Entity:update(dt)
    self:move(dt)
	--self.animation:update(dt)
end
