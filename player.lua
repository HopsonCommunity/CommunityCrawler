require "full"
Player = class:new()

function Player:load()
    self.x = 1
    self.y = 1
    self.name = "Player1"
    self.entitySpeed = 64
    self.entityAcceleration = 4
    self.xVelocity = 0
    self.yVelocity = 0
    self.friction = 0.8
    self.texture = loadImage("entities", "player_modelDefault")
    self.health = 100
    self.maxHealth = 100
    self.debugMode = false
    self.controls = {}
    self.controls["left"] = "a"
    self.controls["right"] = "d"
    self.controls["up"] = "w"
    self.controls["down"] = "s"
    self.controls["debug"] = "f3"
    self.facing = "right"
    self.animation = nim.newAnim(self.texture, 32, 64, 1)
    self.healthBar = loadImage("GUI", "healthBar")
    self.healthImage = loadImage("GUI", "health")
    self.chatOpen = false
    self.chatWrite = ""
	self.canMove = true
end

function Player:hurt(dmg)
    self.health = self.health - dmg
end
function Player:heal(hp)
    if self.health + hp > self.maxHealth then self.health = self.maxHealth else self.health = self.health + hp end
end

function Player:input(dt)
    if player.canMove then
        if love.keyboard.isDown(self.controls["right"]) then self.xVelocity = math.min(self.xVelocity + self.entityAcceleration,  self.entitySpeed) end
        if love.keyboard.isDown(self.controls["left"])  then self.xVelocity = math.max(self.xVelocity - self.entityAcceleration, -self.entitySpeed) end
        if love.keyboard.isDown(self.controls["down"])  then self.yVelocity = math.min(self.yVelocity + self.entityAcceleration,  self.entitySpeed) end
        if love.keyboard.isDown(self.controls["up"])    then self.yVelocity = math.max(self.yVelocity - self.entityAcceleration, -self.entitySpeed) end
	  end
end

function Player:move(dt)
    self.xVelocity = self.xVelocity * self.friction
    self.yVelocity = self.yVelocity * self.friction
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

function Player:update(dt)
    if love.mouse.getX() < love.graphics.getWidth()/2 then self.facing = "left" else self.facing = "right" end
    self:input(dt)
    self:move(dt)
	self.animation:update(dt)
end
