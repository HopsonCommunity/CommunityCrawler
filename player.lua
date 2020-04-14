require "full"
Player = class:new()

function Player:load()
    self.x = 128
    self.y = 128
    self.name = "Player1"
    self.entitySpeed = 1000
    self.entityAcceleration = 10
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
    if love.keyboard.isDown(self.controls["right"]) then self.xVelocity = math.min(self.xVelocity + self.entityAcceleration, self.entitySpeed) end
    if love.keyboard.isDown(self.controls["left"]) then self.xVelocity = math.max(self.xVelocity - self.entityAcceleration, -self.entitySpeed) end
    if love.keyboard.isDown(self.controls["up"]) then self.yVelocity = math.min(self.yVelocity - self.entityAcceleration, self.entitySpeed) end
    if love.keyboard.isDown(self.controls["down"]) then self.yVelocity = math.max(self.yVelocity + self.entityAcceleration, -self.entitySpeed) end
end

function Player:moveEntity(dt)

    self.xVelocity = self.xVelocity * self.friction
    self.yVelocity = self.yVelocity * self.friction

    local shrinkValue = 0.5
    local tmpX = self.x + self.xVelocity * dt
    local tmpY = self.y + self.yVelocity * dt
    --LEFT--
    local valT = tileMap[math.floor((tmpX + shrinkValue)/32)*32 .. " " .. math.floor((self.y + shrinkValue)/32)*32]
    local valB = tileMap[math.floor((tmpX + shrinkValue)/32)*32 .. " " .. math.ceil((self.y - shrinkValue)/32)*32]
    if tmpX > self.x then
        --RIGHT--
        valT = tileMap[math.ceil((tmpX - shrinkValue)/32)*32 .. " " .. math.floor((self.y + shrinkValue)/32)*32]
        valB = tileMap[math.ceil((tmpX - shrinkValue)/32)*32 .. " " .. math.ceil((self.y - shrinkValue)/32)*32]
    end
    if (valT ~= nil and not valT.solid) and (valB ~= nil and not valB.solid) then
        self.x = tmpX
    end

    --UP--
    local valL = tileMap[math.floor((self.x + shrinkValue)/32)*32 .. " " .. math.floor((tmpY + shrinkValue)/32)*32]
    local valR = tileMap[math.ceil((self.x - shrinkValue)/32)*32 .. " " .. math.floor((tmpY + shrinkValue)/32)*32]
    if tmpY > self.y then
        --DOWN--
        valL = tileMap[math.floor((self.x + shrinkValue)/32)*32 .. " " .. math.ceil((tmpY - shrinkValue)/32)*32]
        valR = tileMap[math.ceil((self.x - shrinkValue)/32)*32 .. " " .. math.ceil((tmpY - shrinkValue)/32)*32]
    end

    if (valL ~= nil and not valL.solid) and (valR ~= nil and not valR.solid) then
        self.y = tmpY
    end

end

function Player:update(dt)
    self:playerInput(dt)
    self:moveEntity(dt)
end
