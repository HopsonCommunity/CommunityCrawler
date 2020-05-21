require "globals"
require "utils"
require "tiles"
require "item"
require "weapon"
require "ranged"
require "melee"
require "factories"
require "inventory"
require "entity"
require "prop"
require "player"
require "mapGenerator"
require "drawables"
require "commands"
require "projectile"
require "floor"
require "pubsub"
require "gameState"
require "classSelectGameState"
require "ingameState"

function love.load()
    drawWorld = "brickDungeon"
    player = Player()
    player:load()
    player.gameState = ClassSelectGameState()
end

function setupWorlds()
    player.floor = drawWorld
    floors["brickDungeon"] = Floor()
    floors["brickDungeon"]:load("brickDungeon")
    floors["caveDungeon"] = Floor()
    floors["caveDungeon"]:load("caveDungeon", {floor = "caveFloor", wall = "caveWall", prop = "crate"})

    --math.randomseed(os.clock())
    math.randomseed(1337)
    --exampleMap()
    atlasBatch = love.graphics.newSpriteBatch(generateAtlas(), 2000)
    fillSpriteBatch(atlasBatch, floors[drawWorld].tileMap)
    randWalkSpawn(player, 20, floors[drawWorld])
    for entity = 0, 10 do
        local zombie = entityFactory("zombie")
        local skelebomber = entityFactory("skelebomber")
        zombie:load(drawWorld)
        skelebomber:load(drawWorld)
        randWalkSpawn(zombie, 20, floors[drawWorld])
        randWalkSpawn(skelebomber, 20, floors[drawWorld])
        table.insert(entities, zombie)
        table.insert(entities, skelebomber)
    end
    initMenu()
    for k, v in pairs(entities) do
        if v.shadowIndex then
            v:unloadShadow()
        end
    end
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

function love.update(dt)
    player.gameState:update(dt)
end

function love.textinput(t)
    player.gameState:textinput(t)
end

function love.keypressed(key, scancode, isrepeat)
    player.gameState:keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, isTouch)
    player.gameState:mousepressed(x, y, button, isTouch)
end

function love.wheelmoved(x, y)
    player.gameState:wheelmoved(x, y)
end

function love.draw()
    player.gameState:draw()
end
