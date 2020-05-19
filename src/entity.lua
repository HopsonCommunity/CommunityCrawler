require "libs.SECL.full"
Entity = class:new()

Entity.x = 1
Entity.y = 1
Entity.id = "entity"
Entity.type = "entities"
Entity.health = 100
Entity.maxHealth = 100
Entity.xVelocity = 0
Entity.yVelocity = 0
Entity.entitySpeed = 8
Entity.entityAcceleration = 4
Entity.friction = 0.8
Entity.shadow = {}
Entity.hostile = false
Entity.animFrames = 4

function Entity:load()
    self:loadAnim()
end

function Entity:loadAnim()
    self.texture = loadImage(self.type, self.id)
    if self.type == "entities" then
        self.animations = {
            idle = nim.newAnim(self.texture, self.texture:getWidth()/self.animFrames, self.texture:getHeight()/2, 1, 1, 0-((self.texture:getWidth()/self.animFrames/2)-16), 0-((self.texture:getHeight()/2)-32)),
            running = nim.newAnim(self.texture, self.texture:getWidth()/self.animFrames, self.texture:getHeight()/2, 1, 2, 0-((self.texture:getWidth()/self.animFrames/2)-16), 0-((self.texture:getHeight()/2)-32))
        }
    else
        self.animations = {
            idle = nim.newAnim(self.texture, 32, 32, 1, 1),
        }
    end
    self.currentAnimation = self.animations.idle
end
function Entity:loadShadow()
	if #self.shadow > 0 then
		if self.shadowIndex then
			error("You can't load multiple shadows for one entity.")
		else
			local vertices = {}
			for i, v in ipairs(self.shadow) do
				table.insert(vertices, self.x * 32 + v.x)
				table.insert(vertices, self.y * 32 + v.y)
			end
			table.insert(worldShadows, PolygonShadow:new(shadowshapes, unpack(vertices)))
			self.shadowIndex = #worldShadows
		end
	end
end
function Entity:unloadShadow()
	if self.shadowIndex then
		worldShadows[self.shadowIndex]:Remove()
		self.shadowIndex = nil
	end
end

function Entity:hurt(dmg)
    self.health = self.health - dmg
end
function Entity:heal(hp)
    if self.health + hp > self.maxHealth then self.health = self.maxHealth else self.health = self.health + hp end
end

function Entity:moveDir(dt)
    local mv = {}
    mv.x = player.x - self.x
    mv.y = player.y - self.y
    local distance = math.sqrt(mv.x * mv.x + mv.y * mv.y)
    if math.abs(distance) > 0.5 then
        self.xVelocity = mv.x / distance * self.entitySpeed
        self.yVelocity = mv.y / distance * self.entitySpeed
    end
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

function Entity:checkHit(proj)
    return math.floor(self.x) <= math.floor(proj.x/32) and math.floor(self.y) <= math.floor(proj.y/32) and
            ceiling(self.x + 0.5) >=  ceiling(proj.x/32) and  ceiling(self.y + 0.5) >=  ceiling(proj.y/32)
end

function Entity:update(dt)
    self:moveDir(dt)
    self:move(dt)
	self.currentAnimation:update(dt)
end
