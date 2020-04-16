tiles = {}

tiles["brickFloor"] = {
    id = "brickFloor",
    solid = false,
    texture = loadImage("tiles", "brickFloor"),
	offset = 0
}
tiles["brickWall"] = {
    id = "brickWall",
    solid = true,
    texture = loadImage("tiles", "brickWall"),
	offset = 1
}

tiles["lightFloor"] = {
    id = "lightFloor",
        solid = false,
    emit = true,
    emitStrength = 32,
    emitColor = {
        r = 255,
        g = 255,
        b = 255
    }
}

function fillSpriteBatch(sb, tileMap)
    for k, v in pairs(tileMap) do
        local coords = split(k, " ")
		local row, col = math.floor(v.offset / 100), v.offset % 100
		local quad = love.graphics.newQuad(col * 32, row * 32, 32, 32, 3200, 3200)
		sb:add(quad, coords[1] * 32, coords[2] * 32)
    end
end