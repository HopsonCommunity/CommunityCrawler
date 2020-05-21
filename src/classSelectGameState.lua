require "libs.SECL.full"
ClassSelectGameState = class:new()
ClassSelectGameState:addparent(GameState)

function ClassSelectGameState:update(dt)
end

function ClassSelectGameState:draw()
end

function ClassSelectGameState:textinput(t)
end

function ClassSelectGameState:keypressed(key, scancode, isrepeat)
    if key == "j" then
        setupWorlds()
        player.gameState = IngameState()
    end
end

function ClassSelectGameState:mousepressed(x, y, button, isTouch)
end

function ClassSelectGameState:wheelmoved(x, y)
end
