function loadImage(dir, type)
    local loadedImage
    if dir == nil then dir = "" end
    if love.filesystem.getInfo("rsc/" .. dir .. "/" .. type .. ".png") then
        return love.graphics.newImage("rsc/" .. dir .. "/" .. type .. ".png")
    else
        return love.graphics.newImage("rsc/missingTexture.png")
    end
end

function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
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

function inTileMap(x, y)
    return tileMap[x .. " " .. y] ~= nil
end

function ceiling(val)
    if math.ceil(val) == 0 then return 0 else return math.ceil(val) end
end
