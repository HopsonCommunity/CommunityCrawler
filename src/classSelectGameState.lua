require "libs.SECL.full"
ClassSelectGameState = class:new()
ClassSelectGameState:addparent(GameState)

local buttonSelected = {}
buttonSelected[1] = false
buttonSelected[2] = false
buttonSelected[3] = false

function ClassSelectGameState:update(dt)
    buttonSelected[1] = false
    buttonSelected[2] = false
    buttonSelected[3] = false
    local x, y = love.mouse.getPosition()
    for i = -1, 1 do
        if x >= love.graphics.getWidth()/2 - i*(128 + 8) - 64 and x <= love.graphics.getWidth()/2 - i*(128 + 8) - 64 + 128 and
           y >= love.graphics.getHeight()/2 - 64 and y <= love.graphics.getHeight()/2 - 64 + 128
        then
            buttonSelected[i + 2] = true
        end
    end
end

function ClassSelectGameState:draw()
    for i = -1, 1 do
        if buttonSelected[i + 2] then
            love.graphics.draw(SkillClass.classIconSelected, love.graphics.getWidth()/2 - i*(128 + 8) - 64, love.graphics.getHeight()/2 - 64)
        else
            love.graphics.draw(SkillClass.classIcon, love.graphics.getWidth()/2 - i*(128 + 8) - 64, love.graphics.getHeight()/2 - 64)
        end
        if i == 1 then love.graphics.draw(SkillClass.mageIcon, love.graphics.getWidth()/2 - i*(128 + 8) - 64 + 21, love.graphics.getHeight()/2 - 64 + 21)
        elseif i == 0 then love.graphics.draw(SkillClass.rangerIcon, love.graphics.getWidth()/2 - i*(128 + 8) - 64 + 21, love.graphics.getHeight()/2 - 64 + 21)
        elseif i == -1 then love.graphics.draw(SkillClass.warriorIcon, love.graphics.getWidth()/2 - i*(128 + 8) - 64 + 21, love.graphics.getHeight()/2 - 64 + 21) end

    end
end

function ClassSelectGameState:mousereleased(x, y, button, isTouch)
    if button == 1 then
        if buttonSelected[1] then
            player.class = MageClass()
            player.gameState = IngameState()
            setupWorlds()
        elseif buttonSelected[2] then
            player.class = RangerClass()
            player.gameState = IngameState()
            setupWorlds()
        elseif buttonSelected[3] then
            player.class = WarriorClass()
            player.gameState = IngameState()
            setupWorlds()
        end
    end
end
