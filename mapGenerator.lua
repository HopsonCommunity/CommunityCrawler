function scanRoom(xs, ys, maxX, maxY)
    for y = ys, maxY, 32 do
        for x = xs, maxX, 32 do
            if y == ys or y == maxY or x == xs or x == maxX then
                if tileMap[x .. " " .. y] ~= nil then return false end
            else
                if tileMap[x .. " " .. y] ~= nil then return false end
            end
        end
    end
    return true
end

function generateRoom(xs, ys, maxX, maxY)
    for y = ys, maxY, 32 do
        for x = xs, maxX, 32 do
            if y == ys or y == maxY or x == xs or x == maxX then
                tileMap[x .. " " .. y] = tiles["brickWall"]
            else
                tileMap[x .. " " .. y] = tiles["brickFloor"]
            end
            if y > bottomY then bottomY = y end
            if x > rightX then rightX = x end
            if y < topY then topY = y end
            if x < leftX then leftX = x end
        end
    end
end

function scanCorridor(xs, ys, maxX, maxY, length)

    local isX = false
    local rx = math.random(0, 1)
    local ry = math.random(0, 1)

    if rx == 1 then rx = xs + maxX else rx = 0 end
    if ry == 1 then ry = ry + maxY else ry = 0 end
    if math.random(0, 1) == 1 then
        isX = true
        ry = math.random(ys/32, (ys + maxY)/32)*32
    else
        rx = math.random(xs/32, (xs + maxX)/32)*32
    end

    if isX then
        if rx == xs + maxX then
            for x = 32, length, 32 do
                if tileMap[(rx + x) .. " " .. (ry - 64)] ~= nil or
                   tileMap[(rx + x) .. " " .. (ry - 32)] ~= nil or
                   tileMap[(rx + x) .. " " .. ry] ~= nil or
                   tileMap[(rx + x) .. " " .. (ry + 32)] ~= nil or
                   tileMap[(rx + x) .. " " .. (ry + 64)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "x+"}
        else
            for x = 32, length, 32 do
                if tileMap[(rx - x) .. " " .. (ry - 64)] ~= nil or
                   tileMap[(rx - x) .. " " .. (ry - 32)] ~= nil or
                   tileMap[(rx - x) .. " " .. ry] ~= nil or
                   tileMap[(rx - x) .. " " .. (ry + 32)] ~= nil or
                   tileMap[(rx - x) .. " " .. (ry + 64)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "x-"}
        end
    else
        if ry == ys + maxY then
            for y = 32, length, 32 do
                if tileMap[(rx - 64) .. " " .. (ry + y)] ~= nil or
                   tileMap[(rx - 32) .. " " .. (ry + y)] ~= nil or
                   tileMap[rx .. " " .. (ry + y)] ~= nil or
                   tileMap[(rx + 32) .. " " .. (ry + y)] ~= nil or
                   tileMap[(rx + 64) .. " " .. (ry + y)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "y+"}
        else
            for y = 32, length, 32 do
                if tileMap[(rx - 64) .. " " .. (ry - y)] ~= nil or
                   tileMap[(rx - 32) .. " " .. (ry - y)] ~= nil or
                   tileMap[rx .. " " .. (ry - y)] ~= nil or
                   tileMap[(rx + 32) .. " " .. (ry - y)] ~= nil or
                   tileMap[(rx + 64) .. " " .. (ry - y)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "y-"}
        end
    end
    return {av = false}

end

function makeCorridor(xs, ys, dir, length)
    if dir == "x+" then
        for x = 0, length, 32 do
            tileMap[(xs + x) .. " " .. (ys - 64)] = tiles["brickWall"]
            tileMap[(xs + x) .. " " .. (ys - 32)] = tiles["brickFloor"]
            tileMap[(xs + x) .. " " ..        ys] = tiles["brickFloor"]
            tileMap[(xs + x) .. " " .. (ys + 32)] = tiles["brickFloor"]
            tileMap[(xs + x) .. " " .. (ys + 64)] = tiles["brickWall"]
            if xs + x > rightX then rightX = xs + x end
        end

    elseif dir == "x-" then
        for x = 0, length, 32 do
            tileMap[(xs - x) .. " " .. (ys - 64)] = tiles["brickWall"]
            tileMap[(xs - x) .. " " .. (ys - 32)] = tiles["brickFloor"]
            tileMap[(xs - x) .. " " ..        ys] = tiles["brickFloor"]
            tileMap[(xs - x) .. " " .. (ys + 32)] = tiles["brickFloor"]
            tileMap[(xs - x) .. " " .. (ys + 64)] = tiles["brickWall"]
            if xs - x < leftX then leftX = xs - x end
        end

    elseif dir == "y+" then
        for y = 0, length, 32 do
            tileMap[(xs - 64) .. " " .. (ys + y)] = tiles["brickWall"]
            tileMap[(xs - 32) .. " " .. (ys + y)] = tiles["brickFloor"]
            tileMap[       xs .. " " .. (ys + y)] = tiles["brickFloor"]
            tileMap[(xs + 32) .. " " .. (ys + y)] = tiles["brickFloor"]
            tileMap[(xs + 64) .. " " .. (ys + y)] = tiles["brickWall"]
            if ys + y > bottomY then bottomY = ys + y end
        end

    elseif dir == "y-" then
        for y = 0, length, 32 do
            tileMap[(xs - 64) .. " " .. (ys - y)] = tiles["brickWall"]
            tileMap[(xs - 32) .. " " .. (ys - y)] = tiles["brickFloor"]
            tileMap[       xs .. " " .. (ys - y)] = tiles["brickFloor"]
            tileMap[(xs + 32) .. " " .. (ys - y)] = tiles["brickFloor"]
            tileMap[(xs + 64) .. " " .. (ys - y)] = tiles["brickWall"]
            if ys - y < topY then topY = ys - y end
        end
    end

end

function generateMap()
    local roomNum = 0 --math.random(1, 1)
    for room = 0, roomNum do
        local maxX = 0
        local maxY = 0
        while true do
            maxX = math.random(15, 30) * 32
            maxY = math.random(15, 30) * 32
            if scanRoom(0, 0, maxX, maxY) then
                generateRoom(0, 0, maxX, maxY)
                break
            end
        end
        local length = math.random(10,30) * 32
        while true do
            cor = scanCorridor(3*32, 3*32, maxX-(3*32), maxY-(3*32), length)
            if cor.av then
                makeCorridor(cor.x, cor.y, cor.dir, length)
                break
            end
        end
    end
end

function tmpMap()
    generateRoom(0, 0, 50*32, 50*32)
    for x = 20, 30 do
        tileMap[x*32 .. " " .. 25*32] = tiles["brickWall"]
    end
    for y = 20, 30 do
        tileMap[25*32 .. " " .. y*32] = tiles["brickWall"]
    end
end
