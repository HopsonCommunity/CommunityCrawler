require "globals"
require "utils"
require "tiles"
require "player"
require "mapGenerator"
require "drawables"
require "commands"

lightworld:SetColor(127, 127, 127)

function love.load()
    chatTexts = {}
    player = Player()
    player:load()

    --math.randomseed(os.clock())
    math.randomseed(1337)
    --generateMap()
    randWalkMap(1337)
    fillHolesAndSetWalls()
	generateMapLighting()
    --exampleMap()
	atlasBatch = love.graphics.newSpriteBatch(loadImage("tiles", "atlas"), 2000)
	fillSpriteBatch(atlasBatch, tileMap)
	findSpawn()
	randWalkSpawn()
	initMenu()
end

function love.update(dt)
    player:update(dt)
	lightworld:SetPosition((player.x + 0.5) * 32 + (-love.graphics.getWidth() / 2), player.y * 32 + (-love.graphics.getHeight() / 2), 1)
	playerLight:SetPosition((player.x * 32) + 16, (player.y * 32) + 24)
	lightworld:Update()
	updateSliders()
end

function love.mousepressed(button, x, y)

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
    if key == "/" and player.chatOpen == false then
        player.chatOpen = true
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

    local flip = player.facing == "left"
    nim.drawAnim(player.animation, player.x * 32, (player.y - 1) * 32, 90, flip)

    local luger = loadImage("items", "luger")
    local opp = love.mouse.getY() - love.graphics.getHeight()/2 - player.y
    local adj = love.mouse.getX() - love.graphics.getWidth()/2 - player.x
    local hyp = math.sqrt(opp * opp + adj * adj)
    local f = 1
    if flip then f = -1 end
    local gunPos = 24
    if f == -1 then gunPos = 8 end
    love.graphics.draw(luger, player.x * 32 + gunPos, player.y * 32, f*math.asin(opp / hyp), f, 1)

    love.graphics.reset()
	lightworld:Draw()
	love.graphics.draw(player.healthBar, love.graphics.getWidth()/2 - 48, love.graphics.getHeight() - 96 - 30)
    local HPPerc = (1 - (player.health / player.maxHealth)) * 96
    local HPQuad = love.graphics.newQuad(0, HPPerc, 96, 96, player.healthImage:getDimensions())
    love.graphics.draw(player.healthImage, HPQuad, love.graphics.getWidth()/2 - 48, love.graphics.getHeight() - 96 - 30 + HPPerc)

    drawWholeChat()
    if player.chatOpen == true then drawChat() end
    if player.debugMode then drawDebug() end

    love.graphics.pop()
end
