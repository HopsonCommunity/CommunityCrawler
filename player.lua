require "full"
Player = class:new()

function Player:load()
    self.x = 1
    self.y = 1
    self.name = "Player1"
    self.entitySpeed = 16
    self.entityAcceleration = 2
    self.xVelocity = 0
    self.yVelocity = 0
    self.friction = 0.97
    self.texture = loadImage("", "player")
    self.health = 100
    self.maxHealth = 100
    self.controls = {}
    self.controls["left"] = "a"
    self.controls["right"] = "d"
    self.controls["up"] = "w"
    self.controls["down"] = "s"
end

function Player:hurt(dmg)
    self.health = self.health - dmg
end
function Player:heal(hp)
    if self.health + hp > self.maxHealth then self.health = self.maxHealth else self.health = self.health + hp end
end

function Player:playerInput(dt)
    if love.keyboard.isDown(self.controls["right"]) then self.xVelocity = math.min(self.xVelocity + self.entityAcceleration,  self.entitySpeed) end
    if love.keyboard.isDown(self.controls["left"])  then self.xVelocity = math.max(self.xVelocity - self.entityAcceleration, -self.entitySpeed) end
    if love.keyboard.isDown(self.controls["up"])    then self.yVelocity = math.min(self.yVelocity - self.entityAcceleration,  self.entitySpeed) end
    if love.keyboard.isDown(self.controls["down"])  then self.yVelocity = math.max(self.yVelocity + self.entityAcceleration, -self.entitySpeed) end
end

function Player:moveEntity(dt)

    self.xVelocity = self.xVelocity * self.friction
    self.yVelocity = self.yVelocity * self.friction
    local shrinkValue = 0.01
    local tmpX = self.x + self.xVelocity * dt/2
    local tmpY = self.y + self.yVelocity * dt/2
    --TODO--[[Fix Invisible Walls]]
    --TODO--[[Fix Vertical Movement being faster than horizontal]]
    --LEFT--
    local topNode = tileMap[math.floor((tmpX + shrinkValue)) .. " " .. math.floor((self.y + shrinkValue))]
    local botNode = tileMap[math.floor((tmpX + shrinkValue)) .. " " .. math.ceil((self.y - shrinkValue))]
    if tmpX > self.x then
        --RIGHT--
        topNode = tileMap[math.ceil((tmpX - shrinkValue)) .. " " .. math.floor((self.y + shrinkValue))]
        botNode = tileMap[math.ceil((tmpX - shrinkValue)) .. " " .. math.ceil((self.y - shrinkValue))]
    end
    if (topNode ~= nil and not topNode.solid) and (botNode ~= nil and not botNode.solid) then
        self.x = tmpX
    end

    --UP--
    local leftNode = tileMap[math.floor((self.x + shrinkValue)) .. " " .. math.floor((tmpY + shrinkValue))]
    local rightNode = tileMap[math.ceil((self.x - shrinkValue)) .. " " .. math.floor((tmpY + shrinkValue))]
    if tmpY > self.y then
        --DOWN--
        leftNode = tileMap[math.floor((self.x + shrinkValue)) .. " " .. math.ceil((tmpY - shrinkValue))]
        rightNode = tileMap[math.ceil((self.x - shrinkValue)) .. " " .. math.ceil((tmpY - shrinkValue))]
    end

    if (leftNode ~= nil and not leftNode.solid) and (rightNode ~= nil and not rightNode.solid) then
        self.y = tmpY
    end

end

function Player:update(dt)
    self:playerInput(dt)
    self:moveEntity(dt)
end
