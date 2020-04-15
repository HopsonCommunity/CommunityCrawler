require 'globals'
require "utils"
require "tiles"
require "player"
require "mapGenerator"
require "drawables"

lightworld:SetColor(0, 0, 0)

function love.load()
    player = Player()
    player:load()

    --math.randomseed(os.clock())
    math.randomseed(1337)
    --generateMap()
    randWalkMap(1000)
    fillHolesAndSetWalls()
    --exampleMap()
end

function love.update(dt)
    player:update(dt)
	lightworld:Update()
	lightworld:SetPosition(player.x * 32 + (-love.graphics.getWidth() / 2), player.y * 32 + (-love.graphics.getHeight() / 2), 1)
	playerLight:SetPosition((player.x * 32), (player.y * 32))
end

function love.mousepressed(button, x, y)

end

function love.draw()
    love.graphics.reset()
    love.graphics.push()


    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.translate(-player.x * 32 + (love.graphics.getWidth() / 2), -player.y * 32 + (love.graphics.getHeight() / 2))

    for k, v in pairs(tileMap) do
        local coords = split(k, " ")
        love.graphics.draw(v.texture, coords[1] * 32, coords[2] * 32)
    end

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


    if player.debugMode then
        drawDebug()
    end

    love.graphics.pop()
end
