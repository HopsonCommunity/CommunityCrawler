function scanRoom(xs, ys, maxX, maxY, floor)
    maxX = xs + maxX
    maxY = ys + maxY
    for y = ys, maxY do
        for x = xs, maxX do
            if y == ys or y == maxY or x == xs or x == maxX then
                if floor.tileMap[x .. " " .. y] ~= nil then return false end
            else
                if floor.tileMap[x .. " " .. y] ~= nil then return false end
            end
        end
    end
    return true
end

function generateRoom(xs, ys, maxX, maxY, floor)
    maxX = xs + maxX
    maxY = ys + maxY
    for y = ys, maxY do
        for x = xs, maxX do
            if y == ys or y == maxY or x == xs or x == maxX then
                floor.tileMap[x .. " " .. y] = tiles["brickWall"]
            else
                floor.tileMap[x .. " " .. y] = tiles["brickFloor"]
            end
            if y > floor.bottomY then floor.bottomY = y end
            if x > floor.rightX then floor.rightX = x end
            if y < floor.topY then floor.topY = y end
            if x < floor.leftX then floor.leftX = x end
        end
    end
end

function scanCorridor(xs, ys, maxX, maxY, length, floor)

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
                if floor.tileMap[(rx + x) .. " " .. (ry - 2)] ~= nil or
                   floor.tileMap[(rx + x) .. " " .. (ry - 1)] ~= nil or
                   floor.tileMap[(rx + x) .. " " .. ry] ~= nil or
                   floor.tileMap[(rx + x) .. " " .. (ry + 1)] ~= nil or
                   floor.tileMap[(rx + x) .. " " .. (ry + 2)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "x+"}
        else
            for x = 1, length do
                if floor.tileMap[(rx - x) .. " " .. (ry - 2)] ~= nil or
                   floor.tileMap[(rx - x) .. " " .. (ry - 1)] ~= nil or
                   floor.tileMap[(rx - x) .. " " .. ry] ~= nil or
                   floor.tileMap[(rx - x) .. " " .. (ry + 1)] ~= nil or
                   floor.tileMap[(rx - x) .. " " .. (ry + 2)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "x-"}
        end
    else
        if ry == ys + maxY then
            for y = 1, length do
                if floor.tileMap[(rx - 2) .. " " .. (ry + y)] ~= nil or
                   floor.tileMap[(rx - 1) .. " " .. (ry + y)] ~= nil or
                   floor.tileMap[rx .. " " .. (ry + y)] ~= nil or
                   floor.tileMap[(rx + 1) .. " " .. (ry + y)] ~= nil or
                   floor.tileMap[(rx + 2) .. " " .. (ry + y)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "y+"}
        else
            for y = 1, length do
                if floor.tileMap[(rx - 2) .. " " .. (ry - y)] ~= nil or
                   floor.tileMap[(rx - 1) .. " " .. (ry - y)] ~= nil or
                   floor.tileMap[rx .. " " .. (ry - y)] ~= nil or
                   floor.tileMap[(rx + 1) .. " " .. (ry - y)] ~= nil or
                   floor.tileMap[(rx + 2) .. " " .. (ry - y)] ~= nil then
                       return {av = false}
                   end
            end
            return {x = rx, y = ry, av = true, dir = "y-"}
        end
    end
    return {av = false}

end

function makeCorridor(xs, ys, dir, length, floor)
    if dir == "x+" then
        for x = 0, length do
            floor.tileMap[(xs + x) .. " " .. (ys - 2)] = tiles["brickWall"]
            floor.tileMap[(xs + x) .. " " .. (ys - 1)] = tiles["brickFloor"]
            floor.tileMap[(xs + x) .. " " ..        ys] = tiles["brickFloor"]
            floor.tileMap[(xs + x) .. " " .. (ys + 1)] = tiles["brickFloor"]
            floor.tileMap[(xs + x) .. " " .. (ys + 2)] = tiles["brickWall"]
            if xs + x > floor.rightX then floor.rightX = xs + x end
        end

    elseif dir == "x-" then
        for x = 0, length do
            floor.tileMap[(xs - x) .. " " .. (ys - 2)] = tiles["brickWall"]
            floor.tileMap[(xs - x) .. " " .. (ys - 1)] = tiles["brickFloor"]
            floor.tileMap[(xs - x) .. " " ..        ys] = tiles["brickFloor"]
            floor.tileMap[(xs - x) .. " " .. (ys + 1)] = tiles["brickFloor"]
            floor.tileMap[(xs - x) .. " " .. (ys + 2)] = tiles["brickWall"]
            if xs - x < floor.leftX then floor.leftX = xs - x end
        end

    elseif dir == "y+" then
        for y = 0, length do
            floor.tileMap[(xs - 2) .. " " .. (ys + y)] = tiles["brickWall"]
            floor.tileMap[(xs - 1) .. " " .. (ys + y)] = tiles["brickFloor"]
            floor.tileMap[       xs .. " " .. (ys + y)] = tiles["brickFloor"]
            floor.tileMap[(xs + 1) .. " " .. (ys + y)] = tiles["brickFloor"]
            floor.tileMap[(xs + 2) .. " " .. (ys + y)] = tiles["brickWall"]
            if ys + y > floor.bottomY then floor.bottomY = ys + y end
        end

    elseif dir == "y-" then
        for y = 0, length do
            floor.tileMap[(xs - 2) .. " " .. (ys - y)] = tiles["brickWall"]
            floor.tileMap[(xs - 1) .. " " .. (ys - y)] = tiles["brickFloor"]
            floor.tileMap[       xs .. " " .. (ys - y)] = tiles["brickFloor"]
            floor.tileMap[(xs + 1) .. " " .. (ys - y)] = tiles["brickFloor"]
            floor.tileMap[(xs + 2) .. " " .. (ys - y)] = tiles["brickWall"]
            if ys - y < floor.topY then floor.topY = ys - y end
        end
    end

end

function generateMap(floor)
    local roomNum = math.random(5, 10)
    generateRoom(0, 0, 20, 20, floor)
    for room = 0, roomNum do
        while true do
            local xs = math.random(-100, 100)
            local ys = math.random(-100, 100)
            local maxX = math.random(15, 30)
            local maxY = math.random(15, 30)
            if scanRoom(xs, ys, maxX, maxY, floor) then
                generateRoom(xs, ys, maxX, maxY, floor)
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

function randWalkMap(steps, floor)
    local tileNum = 0
    local pos = {x = 0, y = 0}

    while tileNum < steps do

        if floor.tileMap[pos.x .. " " .. pos.y] == nil then
            floor.tileMap[pos.x .. " " .. pos.y] = tiles["brickFloor"]
            tileNum = tileNum + 1
            if pos.x > floor.rightX  then floor.rightX = pos.x end
            if pos.x < floor.leftX   then floor.leftX = pos.x end
            if pos.y > floor.bottomY then floor.bottomY = pos.y end
            if pos.y < floor.topY    then floor.topY = pos.y end
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

function fillHolesAndSetWalls(floor)
    for i = 0, 5 do
        for y = floor.topY - 1, floor.bottomY + 1 do
            for x = floor.leftX - 1, floor.rightX + 1 do
                if floor.tileMap[x .. " " .. y] == nil or floor.tileMap[x .. " " .. y].solid then

                    local surround = 0

                    if floor.tileMap[x + 1 .. " " .. y]     == nil or floor.tileMap[x + 1 .. " " .. y].solid then surround = surround + 1 end
                    if floor.tileMap[x - 1 .. " " .. y]     == nil or floor.tileMap[x - 1 .. " " .. y].solid then surround = surround + 1 end
                    if floor.tileMap[x .. " " .. y + 1]     == nil or floor.tileMap[x .. " " .. y + 1].solid then surround = surround + 1 end
                    if floor.tileMap[x .. " " .. y - 1]     == nil or floor.tileMap[x .. " " .. y - 1].solid then surround = surround + 1 end
                    if floor.tileMap[x + 1 .. " " .. y + 1] == nil or floor.tileMap[x + 1 .. " " .. y + 1].solid then surround = surround + 1 end
                    if floor.tileMap[x + 1 .. " " .. y - 1] == nil or floor.tileMap[x + 1 .. " " .. y - 1].solid then surround = surround + 1 end
                    if floor.tileMap[x - 1 .. " " .. y + 1] == nil or floor.tileMap[x - 1 .. " " .. y + 1].solid then surround = surround + 1 end
                    if floor.tileMap[x - 1 .. " " .. y - 1] == nil or floor.tileMap[x - 1 .. " " .. y - 1].solid then surround = surround + 1 end

                    if surround <= 3 then floor.tileMap[x .. " " .. y] = tiles["brickFloor"]
                    else floor.tileMap[x .. " " .. y] = tiles["brickWall"] end

                end
            end
        end
    end
end

function addProps(floor)
    for y = floor.topY - 1, floor.bottomY + 1 do
        for x = floor.leftX - 1, floor.rightX + 1 do
            if floor.tileMap[x .. " " .. y] ~= nil and floor.tileMap[x .. " ".. y].id == "brickFloor" and math.random(0, 50) == 1 then
                local crate = Prop()
				crate.x = x
                crate.y = y
                crate.id = "crate"
                crate:load()
                table.insert(entities, crate)
            end
        end
    end
end

function exampleMap(floor)
    generateRoom(0, 0, 50, 50, floor)
    for x = 20, 30 do
        floor.tileMap[x .. " " .. 25] = tiles["brickWall"]
    end
    for y = 20, 30 do
        floor.tileMap[25 .. " " .. y] = tiles["brickWall"]
    end
end

function generateStringMap(floor)
    for y = floor.topY - 1, floor.bottomY + 1 do
        local row = {}
        for x = floor.leftX - 1, floor.rightX + 1 do
            if floor.tileMap[x .. " " .. y].solid then
                table.insert(row, 1)
            else
                table.insert(row, 0)
            end
        end
        table.insert(floor.stringTileMap, row)
    end
end
