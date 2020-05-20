tiles = {}

tiles["brickFloor"] = {
    id = "brickFloor",
    solid = false,
    texture = "brickFloor"
}
tiles["brickWall"] = {
    id = "brickWall",
    solid = true,
    texture = "brickWall"
}
tiles["caveFloor"] = {
    id = "caveFloor",
    solid = false,
    texture = "caveFloor"
}
tiles["caveWall"] = {
    id = "caveWall",
    solid = true,
    texture = "caveWall"
}
tiles["halfWall"] = {
    id = "halfWall",
    solid = true,
	lightHitbox = {
		{x = 0, y = 0},
		{x = 32, y = 0},
		{x = 32, y = 16},
		{x = 0, y = 16}
	}
}
--[[
tiles["crate"] = {
    id = "crate",
    solid = true,
    texture = "crate",
	layer = "brickFloor",
	lightHitbox = {
		{x = 4, y = 0},
		{x = 26, y = 0},
		{x = 26, y = 32},
		{x = 4, y = 32}
	}
}
]]

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

function generateAtlas()
	local img = love.image.newImageData(3200, 32)
	for i, v in ipairs(love.filesystem.getDirectoryItems("rsc/tiles")) do
		local tadd = loadImagedata("tiles", v:sub(1,-5))
		for x = 0, 31 do
			for y = 0, 31 do
				img:setPixel(x+((i-1)*32), y, tadd:getPixel(x, y))
			end
		end
		atlasOffsets[v:sub(1,-5)] = i - 1
	end
	return love.graphics.newImage(img)
end

function fillSpriteBatch(sb, tileMap)
    for k, v in pairs(tileMap) do
        local coords = split(k, " ")
		if v.layer then
			local col = atlasOffsets[tiles[v.layer].texture]
			local quad = love.graphics.newQuad(col * 32, 0, 32, 32, 3200, 32)
			sb:add(quad, coords[1] * 32, coords[2] * 32)
		end
		local col = atlasOffsets[v.texture]
		local quad = love.graphics.newQuad(col * 32, 0, 32, 32, 3200, 32)
		sb:add(quad, coords[1] * 32, coords[2] * 32)
    end
end
