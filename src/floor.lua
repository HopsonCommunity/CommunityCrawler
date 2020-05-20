require "libs.SECL.full"
Floor = class:new()

function Floor:load(type, mapgen)
    self.x = 0
    self.y = 0
    self.type = type
    self.tileMap = {}
    self.stringTileMap = {}
    self.leftX = 0
    self.rightX = 0
    self.bottomY = 0
    self.topY = 0
	self.mapgen = mapgen or {floor = "brickFloor", wall = "brickWall", prop = "crate"}

    --generateMap()
    randWalkMap(1337, self)
    fillHolesAndSetWalls(self)
    generateStringMap(self)
	if self.mapgen.prop then
		addProps(self)
	end
end
