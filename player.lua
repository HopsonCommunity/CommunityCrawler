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
	self.controls["roll"] = "space"
    self.facing = "right"
    self.healthBar = loadImage("GUI", "healthBar")
    self.healthImage = loadImage("GUI", "health")
    self.chatOpen = false
    self.chatWrite = ""
    self.inventory = inventory
	self.canMove = true
	self.itemCooldown = 0
	self.rolling = false
	self.rollMove = {x = 0, y = 0}
	self.rollCooldown = 0
	self.rollTimer = 0
	self.rollLength = 0.15
	self.rollWait = 1
	self.rollParticle = nim.newParticle({1, 1, 1}, {0.5, 0.5, 0.5}, {0.5, 0.5, 0.5}, 8, 16, "square", 0.2, 0.3, -0.3, 0.3, -0.3, -0.3, 0.95, false, "fill", 0, 0)
end

function Player:input(dt)
    if player.canMove and not player.rolling then
		local moving
        if love.keyboard.isDown(self.controls["right"]) then self.xVelocity = math.min(self.xVelocity + self.entityAcceleration,  self.entitySpeed); moving = true end
        if love.keyboard.isDown(self.controls["left"])  then self.xVelocity = math.max(self.xVelocity - self.entityAcceleration, -self.entitySpeed); moving = true end
        if love.keyboard.isDown(self.controls["down"])  then self.yVelocity = math.min(self.yVelocity + self.entityAcceleration,  self.entitySpeed); moving = true end
        if love.keyboard.isDown(self.controls["up"])    then self.yVelocity = math.max(self.yVelocity - self.entityAcceleration, -self.entitySpeed); moving = true end
		if love.keyboard.isDown(self.controls["roll"])    then
			if (self.rollCooldown == 0) and moving then
				self.rolling = true
				self.rollCooldown = self.rollWait
				self.rollTime = 0
				self.rollMove = {x = 0, y = 0}
				if love.keyboard.isDown(self.controls["right"]) then self.rollMove.x = 3 end
				if love.keyboard.isDown(self.controls["left"])  then self.rollMove.x = -3 end
				if love.keyboard.isDown(self.controls["down"])  then self.rollMove.y = 3 end
				if love.keyboard.isDown(self.controls["up"])    then self.rollMove.y = -3 end
				for i = 1, 5 do nim.addParticle(self.rollParticle, self.x * 32 + 16, self.y * 32 + 32) end
			end
		end
	end
end

function Player:updateRoll()
	if self.rollMove.x < 0 then
		self.xVelocity = math.max(self.xVelocity + self.entityAcceleration * self.rollMove.x, self.entitySpeed * self.rollMove.x)
	else
		self.xVelocity = math.min(self.xVelocity + self.entityAcceleration * self.rollMove.x,  self.entitySpeed * self.rollMove.x)
	end
	if self.rollMove.y < 0 then
		self.yVelocity = math.max(self.yVelocity + self.entityAcceleration * self.rollMove.y, self.entitySpeed * self.rollMove.y)
	else
		self.yVelocity = math.min(self.yVelocity + self.entityAcceleration * self.rollMove.y,  self.entitySpeed * self.rollMove.y)
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
