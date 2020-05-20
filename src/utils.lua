function loadImage(dir, type)
    local loadedImage
    if dir == nil then dir = "" end
    if love.filesystem.getInfo("rsc/" .. dir .. "/" .. type .. ".png") then
        return love.graphics.newImage("rsc/" .. dir .. "/" .. type .. ".png")
    else
        return love.graphics.newImage("rsc/missingTexture.png")
    end
end

function loadImagedata(dir, type)
    local loadedImage
    if dir == nil then dir = "" end
    if love.filesystem.getInfo("rsc/" .. dir .. "/" .. type .. ".png") then
        return love.image.newImageData("rsc/" .. dir .. "/" .. type .. ".png")
    else
        return love.image.newImageData("rsc/missingTexture.png")
    end
end

function round(n)
    if n % 1 >= 0.5 then
        if math.ceil(n) == 0 then return 0
        else return math.ceil(n) end
    else return math.floor(n) end
end

function len(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function at(T, ind)
    for k, v in pairs(T) do
        if k.x == ind.x and k.y == ind.y then return v end
    end
    return nil
end

function split(inpstr, sep)
    if sep == nil then sep = "%s" end
    local t={}
    for str in string.gmatch(inpstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function inList(list, element)
    for _, value in pairs(list) do
        if value == element then
            return true
        end
    end
    return false
end

function inTileMap(x, y, floor)
    return floor.tileMap[x .. " " .. y] ~= nil
end

function ceiling(val)
    if math.ceil(val) == 0 then return 0 else return math.ceil(val) end
end

function generateMapLighting(floor)
	for k, v in pairs(floor.tileMap) do
        local coords = split(k, " ")
		if v.solid then
			local top = floor.tileMap[coords[1] .. " " .. coords[2] - 1]
			local bottom = floor.tileMap[coords[1] .. " " .. coords[2] + 1]
			local left = floor.tileMap[coords[1] - 1 .. " " .. coords[2]]
			local right = floor.tileMap[coords[1] + 1 .. " " .. coords[2]]
			if top and bottom and left and right then
				if not (top.solid and bottom.solid and left.solid and right.solid) or (top.lightHitbox or bottom.lightHitbox or left.lightHitbox or right.lightHitbox) then
					if floor.tileMap[coords[1] .. " " .. coords[2]].lightHitbox then
						local vertices = {}
						for i, v in ipairs(floor.tileMap[coords[1] .. " " .. coords[2]].lightHitbox) do
							table.insert(vertices, coords[1]*32 + v.x)
							table.insert(vertices, coords[2]*32 + v.y)
						end
						table.insert(worldShadows, PolygonShadow:new(shadowshapes, unpack(vertices)))
					else
						table.insert(worldShadows, PolygonShadow:new(shadowshapes, (coords[1] * 32)+0, (coords[2] * 32), (coords[1] * 32)+32, (coords[2] * 32), (coords[1] * 32)+32, (coords[2] * 32)+32, (coords[1] * 32), (coords[2] * 32)+32))
					end
				end
			else
				if floor.tileMap[coords[1] .. " " .. coords[2]].lightHitbox then
					local vertices = {}
					for i, v in ipairs(floor.tileMap[coords[1] .. " " .. coords[2]].lightHitbox) do
						table.insert(vertices, coords[1]*32 + v.x)
						table.insert(vertices, coords[2]*32 + v.y)
					end
					table.insert(worldShadows, PolygonShadow:new(shadowshapes, unpack(vertices)))
				else
					table.insert(worldShadows, PolygonShadow:new(shadowshapes, (coords[1] * 32)+0, (coords[2] * 32), (coords[1] * 32)+32, (coords[2] * 32), (coords[1] * 32)+32, (coords[2] * 32)+32, (coords[1] * 32), (coords[2] * 32)+32))
				end
			end
		elseif v.emit then
			table.insert(worldLights, Light:new(lightworld, v.emitStrength or 32))
			worldLights[#worldLights]:SetPosition(coords[1] * 32 + 16, coords[2] * 32 + 16)
			if v.emitColor == nil then
				worldLights[#worldLights]:SetColor(255, 255, 255)
			else
				worldLights[#worldLights]:SetColor(v.emitColor.r or 0, v.emitColor.g or 0, v.emitColor.b or 0)
			end
		end
    end
end

function findSpawn(floor)
	local f
	for y = topY + 5, bottomY do
		for x = leftX + 1, rightX do
			if floor.tileMap[x .. " " .. y] ~= nil and not floor.tileMap[x .. " " .. y].solid then
				player.x = x
				player.y = y
				f = true
				break
			end
		end
		if f then break end
	end
end

function randWalkSpawn(entity, move, floor)
    local pos = {x = 0, y = 0}
    local moved = 0
    while true do
        if floor.tileMap[pos.x .. " " .. pos.y] ~= nil and not floor.tileMap[pos.x .. " " .. pos.y].solid and moved > move then
            entity.x = pos.x
            entity.y = pos.y
            break
        end
        moved = moved + 1
        while true do
            local dir = math.random(1, 4)
            if dir == 1 then
                if floor.tileMap[pos.x + 1 .. " " .. pos.y] ~= nil then
                    pos = {x = pos.x + 1, y = pos.y}
                    break
                end
            elseif dir == 2 then
                if floor.tileMap[pos.x - 1 .. " " .. pos.y] ~= nil then
                    pos = {x = pos.x - 1, y = pos.y}
                    break
                end
            elseif dir == 3 then
                if floor.tileMap[pos.x .. " " .. pos.y + 1] ~= nil then
                    pos = {x = pos.x, y = pos.y + 1}
                    break
                end
            elseif dir == 4 then
                if floor.tileMap[pos.x .. " " .. pos.y - 1] ~= nil then
                    pos = {x = pos.x, y = pos.y - 1}
                    break
                end
            end
        end
    end
end

function startGame(n)
	if n == 1 then
		closeMenu()
	end
end

function initMenu()
	sliders[#sliders] = newSlider(100, 100, 100, 0, 0, 1)
end

function updateSliders()

end

function randomFloat(min, max)
	return (math.random()*(max-min)+min)
end

function updateProjectiles()
	local dt = love.timer.getDelta()
	for k, v in pairs(projectiles) do
        if v.floor == player.floor then
    		v:update(dt)
    		v.lifespan = v.lifespan - dt * 60
    		if v.lifespan <= 0 then
    			if v.light then
    				v.light:Remove()
    			end
    			v = nil
    			projectiles[k] = nil
    		else
    			if v.light then
    				v.light:SetPosition(v.x, v.y)
    			end
    			local val = 1
    			if v.facing == "left" then val = -1 end
    			love.graphics.draw(v.texture, v.x, v.y, v.angle, val)
    			if v.trail then
    				v.trailTimer = v.trailTimer + dt
    				if v.trailTimer > v.trailWait then
    					nim.addParticle(v.trail, v.x, v.y)
    					v.trailTimer = v.trailTimer % v.trailWait
    				end
    			end
    		end
        end
    end
end

function tileRaycast(x, y, tx, ty)

end
