function scanRoom(xs, ys, maxX, maxY)
    maxX = xs + maxX
    maxY = ys + maxY
    for y = ys, maxY do
        for x = xs, maxX do
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
    maxX = xs + maxX
    maxY = ys + maxY
    for y = ys, maxY do
        for x = xs, maxX do
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
        ry = math.random(ys, (ys + maxY))
    else
        rx = math.random(xs, (xs + maxX))
    end

    if isX then
        if rx == xs + maxX then
            for x = 1, length do
                if tileMap[(rx + x) .. " " .. (ry - 2)] ~= nil or
                   tileMap[(rx + x) .. " " .. (ry - 1)] ~= nil or
                   tileMap[(rx + x) .. " " .. ry] ~= nil or
                   tileMap[(rx + x) .. " " .. (ry + 1)] ~= nil or
                   tileMap[(rx + x) .. " " .. (ry + 2)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "x+"}
        else
            for x = 1, length do
                if tileMap[(rx - x) .. " " .. (ry - 2)] ~= nil or
                   tileMap[(rx - x) .. " " .. (ry - 1)] ~= nil or
                   tileMap[(rx - x) .. " " .. ry] ~= nil or
                   tileMap[(rx - x) .. " " .. (ry + 1)] ~= nil or
                   tileMap[(rx - x) .. " " .. (ry + 2)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "x-"}
        end
    else
        if ry == ys + maxY then
            for y = 1, length do
                if tileMap[(rx - 2) .. " " .. (ry + y)] ~= nil or
                   tileMap[(rx - 1) .. " " .. (ry + y)] ~= nil or
                   tileMap[rx .. " " .. (ry + y)] ~= nil or
                   tileMap[(rx + 1) .. " " .. (ry + y)] ~= nil or
                   tileMap[(rx + 2) .. " " .. (ry + y)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "y+"}
        else
            for y = 1, length do
                if tileMap[(rx - 2) .. " " .. (ry - y)] ~= nil or
                   tileMap[(rx - 1) .. " " .. (ry - y)] ~= nil or
                   tileMap[rx .. " " .. (ry - y)] ~= nil or
                   tileMap[(rx + 1) .. " " .. (ry - y)] ~= nil or
                   tileMap[(rx + 2) .. " " .. (ry - y)] ~= nil then
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
        for x = 0, length do
            tileMap[(xs + x) .. " " .. (ys - 2)] = tiles["brickWall"]
            tileMap[(xs + x) .. " " .. (ys - 1)] = tiles["brickFloor"]
            tileMap[(xs + x) .. " " ..        ys] = tiles["brickFloor"]
            tileMap[(xs + x) .. " " .. (ys + 1)] = tiles["brickFloor"]
            tileMap[(xs + x) .. " " .. (ys + 2)] = tiles["brickWall"]
            if xs + x > rightX then rightX = xs + x end
        end

    elseif dir == "x-" then
        for x = 0, length do
            tileMap[(xs - x) .. " " .. (ys - 2)] = tiles["brickWall"]
            tileMap[(xs - x) .. " " .. (ys - 1)] = tiles["brickFloor"]
            tileMap[(xs - x) .. " " ..        ys] = tiles["brickFloor"]
            tileMap[(xs - x) .. " " .. (ys + 1)] = tiles["brickFloor"]
            tileMap[(xs - x) .. " " .. (ys + 2)] = tiles["brickWall"]
            if xs - x < leftX then leftX = xs - x end
        end

    elseif dir == "y+" then
        for y = 0, length do
            tileMap[(xs - 2) .. " " .. (ys + y)] = tiles["brickWall"]
            tileMap[(xs - 1) .. " " .. (ys + y)] = tiles["brickFloor"]
            tileMap[       xs .. " " .. (ys + y)] = tiles["brickFloor"]
            tileMap[(xs + 1) .. " " .. (ys + y)] = tiles["brickFloor"]
            tileMap[(xs + 2) .. " " .. (ys + y)] = tiles["brickWall"]
            if ys + y > bottomY then bottomY = ys + y end
        end

    elseif dir == "y-" then
        for y = 0, length do
            tileMap[(xs - 2) .. " " .. (ys - y)] = tiles["brickWall"]
            tileMap[(xs - 1) .. " " .. (ys - y)] = tiles["brickFloor"]
            tileMap[       xs .. " " .. (ys - y)] = tiles["brickFloor"]
            tileMap[(xs + 1) .. " " .. (ys - y)] = tiles["brickFloor"]
            tileMap[(xs + 2) .. " " .. (ys - y)] = tiles["brickWall"]
            if ys - y < topY then topY = ys - y end
        end
    end

end

function generateMap()
    local roomNum = math.random(5, 10)
    generateRoom(0, 0, 20, 20)
    for room = 0, roomNum do
        while true do
            local xs = math.random(-100, 100)
            local ys = math.random(-100, 100)
            local maxX = math.random(15, 30)
            local maxY = math.random(15, 30)
            if scanRoom(xs, ys, maxX, maxY) then
                generateRoom(xs, ys, maxX, maxY)
                break
            end
        end
        --[[
        local length = math.random(10,30)
        while true do
            cor = scanCorridor(3, 3, maxX-(3), maxY-(3), length)
            if cor.av then
                makeCorridor(cor.x, cor.y, cor.dir, length)
                break
            end
        end
        ]]--
    end
end

function randWalkMap(steps)
    local tileNum = 0
    local pos = {x = 0, y = 0}

    while tileNum < steps do

        if tileMap[pos.x .. " " .. pos.y] == nil then
            tileMap[pos.x .. " " .. pos.y] = tiles["brickFloor"]
            tileNum = tileNum + 1
            if pos.x > rightX  then rightX = pos.x end
            if pos.x < leftX   then leftX = pos.x end
            if pos.y > bottomY then bottomY = pos.y end
            if pos.y < topY    then topY = pos.y end
        end

        local dir = math.random(1, 4)

        if dir == 1 then
            pos = {x = pos.x + 1, y = pos.y}
        elseif dir == 2 then
            pos = {x = pos.x - 1, y = pos.y}
        elseif dir == 3 then
            pos = {x = pos.x, y = pos.y + 1}
        elseif dir == 4 then
            pos = {x = pos.x, y = pos.y - 1}
        end

    end
end

function exampleMap()
    generateRoom(0, 0, 50, 50)
    for x = 20, 30 do
        tileMap[x .. " " .. 25] = tiles["brickWall"]
    end
    for y = 20, 30 do
        tileMap[25 .. " " .. y] = tiles["brickWall"]
    end
end
