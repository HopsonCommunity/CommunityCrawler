require "full"
Player = class:new()
Player:addparent(Entity)

Player.id = "player"
Player.type = "entities"
function Player:load()
    self.id = "player"
    self.animFrames = 8
    self:loadAnim()
    self.name = "Player1"
    self.debugMode = false
    self.controls = {}
    self.controls["left"] = "a"
    self.controls["right"] = "d"
    self.controls["up"] = "w"
    self.controls["down"] = "s"
    self.controls["debug"] = "f3"
    self.facing = "right"
    self.healthBar = loadImage("GUI", "healthBar")
    self.healthImage = loadImage("GUI", "health")
    self.chatOpen = false
    self.chatWrite = ""
    self.inventory = inventory
	self.canMove = true
	self.itemCooldown = 0
end

function Player:input(dt)
    if player.canMove then
        if love.keyboard.isDown(self.controls["right"]) then self.xVelocity = math.min(self.xVelocity + self.entityAcceleration,  self.entitySpeed) end
        if love.keyboard.isDown(self.controls["left"])  then self.xVelocity = math.max(self.xVelocity - self.entityAcceleration, -self.entitySpeed) end
        if love.keyboard.isDown(self.controls["down"])  then self.yVelocity = math.min(self.yVelocity + self.entityAcceleration,  self.entitySpeed) end
        if love.keyboard.isDown(self.controls["up"])    then self.yVelocity = math.max(self.yVelocity - self.entityAcceleration, -self.entitySpeed) end
	  end
end

function Player:update(dt)
    if love.mouse.getX() < love.graphics.getWidth()/2 then self.facing = "left" else self.facing = "right" end
    self:input(dt)
    self:move(dt)

    if self.xVelocity ~= 0 or self.yVelocity ~= 0 then
        self.currentAnimation = self.animations.running
    else
        self.currentAnimation = self.animations.idle
    end

    self.currentAnimation:update(dt)
end
