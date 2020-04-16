tiles = {}

tiles["brickFloor"] = {
    id = "brickFloor",
    solid = false,
    texture = loadImage("tiles", "brickFloor"),
}
tiles["brickWall"] = {
    id = "brickWall",
    solid = true,
    texture = loadImage("tiles", "brickWall")
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
