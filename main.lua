require "globals"
require "utils"
require "tiles"
require "item"
require "inventory"
require "entity"
require "prop"
require "player"
require "mapGenerator"
require "drawables"
require "commands"
require "projectile"

lightworld:SetColor(127, 127, 127)

function love.load()
    player = Player()
    player:load()
    --math.randomseed(os.clock())
    math.randomseed(1337)
    --generateMap()
    randWalkMap(1337)
    fillHolesAndSetWalls()
    addProps()
	generateMapLighting()
    --exampleMap()
	atlasBatch = love.graphics.newSpriteBatch(generateAtlas(), 2000)
	fillSpriteBatch(atlasBatch, tileMap)
	findSpawn()
	randWalkSpawn()
	initMenu()
end

function love.update(dt)
    player:update(dt)
	lightworld:SetPosition(math.floor((player.x + 0.5) * 32 + (-love.graphics.getWidth() / 2)), math.floor(player.y * 32 + (-love.graphics.getHeight() / 2)), 1)
	playerLight:SetPosition((player.x * 32) + 16, (player.y * 32) + 24)
	lightworld:Update()
	updateSliders()
	player.itemCooldown = math.max(player.itemCooldown - dt, 0)
	if player.rolling then
		player.rollTime = player.rollTime + dt
		player:updateRoll()
		if player.rollTime > player.rollLength then
			player.rolling = false
		end
	else
		player.rollCooldown = math.max(player.rollCooldown - dt, 0)
	end
	nim.updateParticles(dt)
end

function love.textinput(t)
    if player.chatOpen then
        local tmp = love.graphics.newText(love.graphics.newFont(16), player.chatWrite .. t)
        if tmp:getWidth() < 500 then
            player.chatWrite = player.chatWrite .. t
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if player.chatOpen == true then
        if key == "return" or key == "kpenter" then
			player.canMove = true
            player.chatOpen = false
            if string.sub(player.chatWrite, 1, 1) == "/" and string.len(player.chatWrite) > 1 then evalCommands(player.chatWrite) end
            if len(chatTexts) >= 22 then
                table.remove(chatTexts, 1)
            end
            table.insert(chatTexts, player.chatWrite)
            player.chatWrite = ""
            return
        end

        tmp = love.graphics.newText(love.graphics.newFont(16), player.chatWrite .. love.system.getClipboardText())
        if love.keyboard.isDown("lctrl") and key == "v" and tmp:getWidth() < 500 then
            player.chatWrite = player.chatWrite .. love.system.getClipboardText()
        elseif key == "backspace" then player.chatWrite = string.sub(player.chatWrite, 1, string.len(player.chatWrite)-1) end
    elseif key == player.controls["debug"] then player.debugMode = not player.debugMode end
    if (key == "return" or key == "kpenter") and player.chatOpen == false then
        player.chatOpen = true
		player.canMove = false
    end
    if inList({ "1", "2", "3", "4", "0" }, key) then
        if key == "0" then key = "4" end
		if tonumber(key) ~= player.inventory.selected then
			if player.inventory.hotbar[player.inventory.selected].id ~= nil then player.itemCooldown = math.max(player.inventory.hotbar[player.inventory.selected].cooldown, 1) end
		end
        player.inventory.selected = tonumber(key)
    end
    if key == "/" and player.chatOpen == false then
        player.chatOpen = true
    end

end

function love.wheelmoved(x, y)
    if y < 0 then
        if player.inventory.selected < #player.inventory.hotbar then
            player.inventory.selected = player.inventory.selected + 1
        else player.inventory.selected = 1
        end
		if player.inventory.hotbar[player.inventory.selected].id ~= nil then player.itemCooldown = math.max(player.inventory.hotbar[player.inventory.selected].cooldown, 1) end
    end
    if y > 0 then
        if player.inventory.selected > 1 then
            player.inventory.selected = player.inventory.selected - 1
        else player.inventory.selected = #player.inventory.hotbar
        end
		if player.inventory.hotbar[player.inventory.selected].id ~= nil then player.itemCooldown = math.max(player.inventory.hotbar[player.inventory.selected].cooldown, 1) end
    end
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 and player.inventory.hotbar[player.inventory.selected].type == "gun" and player.itemCooldown == 0 and not player.rolling then
		for i=1,player.inventory.hotbar[player.inventory.selected].bulletNum do
			local newProjectile = Projectile()
			newProjectile:load()
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
			if player.inventory.hotbar[player.inventory.selected].spread then ang = ang + math.rad(math.random(player.inventory.hotbar[player.inventory.selected].spread * 2) - player.inventory.hotbar[player.inventory.selected].spread) end
			newProjectile.angle = ang
			table.insert(projectiles, newProjectile)
		end
		player.itemCooldown = player.inventory.hotbar[player.inventory.selected].cooldown
    end
end

function love.draw()
    love.graphics.reset()
    love.graphics.push()


    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.translate(-(player.x + 0.5) * 32 + (love.graphics.getWidth() / 2), -player.y * 32 + (love.graphics.getHeight() / 2))

	--[[
    for k, v in pairs(tileMap) do
        local coords = split(k, " ")
        love.graphics.draw(v.texture, coords[1] * 32, coords[2] * 32)
    end
	--]]
	love.graphics.draw(atlasBatch)
	nim.drawParticles()
	for k, v in pairs(entities) do
        nim.drawAnim(v.currentAnimation, v.x * 32, v.y * 32)
    end

	updateProjectiles()

    love.graphics.reset()
	lightworld:Draw()

	love.graphics.translate(math.floor(-(player.x + 0.5) * 32 + (love.graphics.getWidth() / 2)), math.floor(-player.y * 32 + (love.graphics.getHeight() / 2)))
	local flip = player.facing == "left"
    nim.drawAnim(player.currentAnimation, player.x * 32, (player.y - 1) * 32, 90, flip)
	if player.inventory.hotbar[player.inventory.selected].id ~= nil then
        local opp = love.mouse.getY() - love.graphics.getHeight()/2 - player.y
        local adj = love.mouse.getX() - love.graphics.getWidth()/2 - player.x
        local hyp = math.sqrt(opp * opp + adj * adj)
        local f = 1
        if flip then f = -1 end
        local gunPos = 48
        if f == -1 then gunPos = -8 end
        love.graphics.draw(player.inventory.hotbar[player.inventory.selected].texture, player.x * 32 + gunPos, player.y * 32 + 16, f*math.asin(opp / hyp), f, 1, 16, 16)
    end
	love.graphics.reset()

    love.graphics.draw(player.healthBar, love.graphics.getWidth()/2 - 48, love.graphics.getHeight() - 96 - 32)
    local HPPerc = (1 - (player.health / player.maxHealth)) * 96
    local HPQuad = love.graphics.newQuad(0, HPPerc, 96, 96, player.healthImage:getDimensions())
    love.graphics.draw(player.healthImage, HPQuad, love.graphics.getWidth()/2 - 48, love.graphics.getHeight() - 96 - 32 + HPPerc)
    player.inventory.draw()

    drawWholeChat()
    if player.chatOpen == true then drawChat() end
    if player.debugMode then drawDebug() end

    love.graphics.pop()
end
