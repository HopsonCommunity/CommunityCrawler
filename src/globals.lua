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
playerLight = Light:new(lightworld, 512)

floors = {}

worldShadows = {}
worldLights = {}
sliders = {}
projectiles = {}
entities = {}
chatTexts = {}
atlasOffsets = {}
