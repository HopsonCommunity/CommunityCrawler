nim = require "libs.nim"
shadows = require "libs.shadows"
LightWorld = require "libs.shadows.LightWorld"
PolygonShadow = require "libs.shadows.ShadowShapes.PolygonShadow"
Light = require "libs.shadows.Light"
Body = require "libs.shadows.Body"
require "libs.simple-slider"
debug1 = {}
debug2 = {}
lightworld = LightWorld:new()
shadowshapes = Body:new(lightworld)
playerLight = nil -- is set to a light in main.lua, not defined here because that is completely useless

floors = {}

worldShadows = {}
worldLights = {}
sliders = {}
projectiles = {}
entities = {}
chatTexts = {}
atlasOffsets = {}
