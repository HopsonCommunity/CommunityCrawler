require "libs.SECL.full"
IngameState = class:new()
IngameState:addparent(GameState)

function IngameState:update(dt)
    player:update(dt)
    if drawWorld ~= player.floor then
        for k, v in pairs(entities) do
            if v.shadowIndex then
                v:unloadShadow()
            end
        end
        drawWorld = player.floor
        randWalkSpawn(player, 20, floors[drawWorld])
        atlasBatch = love.graphics.newSpriteBatch(generateAtlas(), 2000)
        fillSpriteBatch(atlasBatch, floors[drawWorld].tileMap)
        lightworld = LightWorld:new()
        lightworld:SetColor(127, 127, 127)
        shadowshapes = Body:new(lightworld)
        playerLight = Light:new(lightworld, 512)
        generateMapLighting(floors[drawWorld])
        for k, v in pairs(entities) do
            if (not v.shadowIndex) and (v.floor == drawWorld) then
                v:loadShadow()
            end
        end
    end
    for k, v in pairs(entities) do
        if v.floor == player.floor then
            v:update(dt)
			if v.type ~= "items" then
				for k2, proj in pairs(projectiles) do
					if v:checkHit(proj) then
						local dmg = 0
						if math.random(proj.critChance) == 1 then
							dmg = (randomFloat(proj.minDmg, proj.maxDmg) * proj.critMultiplier)
						else
							dmg = (randomFloat(proj.minDmg, proj.maxDmg))
						end
						v:hurt(dmg)
						if proj.light then
							proj.light:Remove()
						end
						proj = nil
						projectiles[k2] = nil
					end
				end
			end
            if v.health <= 0 then
                entities[k]:unloadShadow()
                entities[k] = nil
            end
        end
    end
    lightworld:SetPosition(math.floor((player.x + 0.5) * 32 + (-love.graphics.getWidth() / 2)), math.floor(player.y * 32 + (-love.graphics.getHeight() / 2)), 1)
    playerLight:SetPosition((player.x * 32) + 16, (player.y * 32) + 24)
    lightworld:Update()
    updateSliders()
    if player.inventory.hotbar[player.inventory.selected] ~= "none" then
        player.inventory.hotbar[player.inventory.selected].cooldownTimer = math.max(player.inventory.hotbar[player.inventory.selected].cooldownTimer - dt, 0)
    end
    if player.rolling then
        player.rollTime = player.rollTime + dt
        player:updateRoll()
        if player.rollTime > player.rollLength then
            player.rolling = false
        end
    else
        player.rollCooldown = math.max(player.rollCooldown - dt, 0)
    end
    if love.mouse.isDown(1) and player.inventory.hotbar[player.inventory.selected].cooldownTimer == 0 and not player.rolling then
        if (player.inventory.hotbar[player.inventory.selected].type == "ranged") and (player.inventory.hotbar[player.inventory.selected].fireType == "auto") then
            player.inventory.hotbar[player.inventory.selected]:leftClick(love.mouse.getX(), love.mouse.getY(), player.floor)
        end
    end
    nim.updateParticles(dt)
end

function IngameState:draw()
    love.graphics.reset()
    love.graphics.push()


    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.translate(math.floor(-(player.x + 0.5) * 32 + (love.graphics.getWidth() / 2)), math.floor(-player.y * 32 + (love.graphics.getHeight() / 2)))

    --[[
    for k, v in pairs(tileMap) do
        local coords = split(k, " ")
        love.graphics.draw(v.texture, coords[1] * 32, coords[2] * 32)
    end
    --]]
    love.graphics.draw(atlasBatch)
    nim.drawParticles()
    for k, v in pairs(entities) do
        if v.floor == player.floor then
            nim.drawAnim(v.currentAnimation, v.x * 32, v.y * 32)
        end
    end

    updateProjectiles()

    love.graphics.reset()
    lightworld:Draw()

    love.graphics.translate(math.floor(-(player.x + 0.5) * 32 + (love.graphics.getWidth() / 2)), math.floor(-player.y * 32 + (love.graphics.getHeight() / 2)))
    local flip = player.facing == "left"
    nim.drawAnim(player.currentAnimation, player.x * 32, player.y * 32, 90, flip)
    if player.inventory.hotbar[player.inventory.selected].id ~= nil then
        local my = love.mouse.getY() - love.graphics.getHeight()/2 - player.y
        local mx = love.mouse.getX() - love.graphics.getWidth()/2 - player.x
        local gunPos = 48
        local f = 1
        local h = 0
        if flip then
            f = -1
            gunPos = -8
            h = math.rad(180)
        end
        love.graphics.draw(player.inventory.hotbar[player.inventory.selected].texture, player.x * 32 + gunPos, player.y * 32 + 16, -1*math.atan2(-my, mx)+h, f, 1, 16, 16)
    end
    love.graphics.reset()

    love.graphics.draw(player.healthBar, love.graphics.getWidth()/2 - 48, love.graphics.getHeight() - 96 - 32)
    local HPPerc = (1 - (player.health / player.maxHealth)) * 96
    local HPQuad = love.graphics.newQuad(0, HPPerc, 96, 96, player.healthImage:getDimensions())
    love.graphics.draw(player.healthImage, HPQuad, love.graphics.getWidth()/2 - 48, love.graphics.getHeight() - 96 - 32 + HPPerc)
    player.inventory.drawHotbar()
    if player.inventory.invIsOpen then
        player.inventory.drawInventory()
    end

    drawWholeChat()
    if player.chatOpen == true then drawChat() end
    if player.debugMode then drawDebug() end

    love.graphics.pop()
end

function IngameState:textinput(t)
    if player.chatOpen then
        local tmp = love.graphics.newText(love.graphics.newFont(16), player.chatWrite .. t)
        if tmp:getWidth() < 320 then
            player.chatWrite = player.chatWrite .. t
        end
    end
end

function IngameState:keypressed(key, scancode, isrepeat)
    if player.chatOpen == true then
        if key == "return" or key == "kpenter" then
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
        if love.keyboard.isDown("lctrl") and key == "v" and tmp:getWidth() < 320 then
            player.chatWrite = player.chatWrite .. love.system.getClipboardText()
        elseif key == "backspace" then player.chatWrite = string.sub(player.chatWrite, 1, string.len(player.chatWrite)-1) end
    elseif key == player.controls["debug"] then
        player.debugMode = not player.debugMode
    elseif key == "j" then
        if player.floor == "caveDungeon" then player.floor = "brickDungeon"
        elseif player.floor == "brickDungeon" then player.floor = "caveDungeon" end
    elseif key == "e" then
        player.inventory.invIsOpen = not player.inventory.invIsOpen
    end
    if (key == "return" or key == "kpenter") and player.chatOpen == false then
        player.chatOpen = true
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

function IngameState:mousepressed(x, y, button, isTouch)
    if (button == 1) and player.inventory.hotbar[player.inventory.selected].cooldownTimer == 0 and not player.rolling then
        if (player.inventory.hotbar[player.inventory.selected].type == "ranged") and (player.inventory.hotbar[player.inventory.selected].fireType == "semi") then
            player.inventory.hotbar[player.inventory.selected]:leftClick(x, y, player.floor)
        end
    end
end

function IngameState:wheelmoved(x, y)
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
