function evalCommands(cmd)
    cmd = string.sub(cmd, 2, string.len(cmd))

    local w = {}
    local cmds = {}
    for w in cmd:gmatch("%S+") do table.insert(cmds, w) end

    if cmds[1] == "debug" then
        player.debugMode = not playerDebugMode
        return
    end

    if cmds[1] == "summon" or cmds[1] == "spawn" then
        if cmds[2] == nil then return end
        local entity = entityFactory(cmds[2])
        if entity == nil then return end
        entity:load()
        if cmds[3] ~= nil and cmds[4] ~= nil then
            entity.x = tonumber(cmds[3])
            entity.y = tonumber(cmds[4])
        elseif cmds[3] == "random" then
            randWalkSpawn(entity, 20)
        else
            entity.x = player.x
            entity.y = player.y
        end
        table.insert(entities, entity)
        return
    end

    if cmds[1] == "heal" then
        if cmds[2] == nil then cmds[2] = player.maxHealth else cmds[2] = tonumber(cmds[2]) end
        player:heal(cmds[2])
        return
    end

    if cmds[1] == "hurt" then
        if cmds[2] == nil then cmds[2] = math.random(1, player.health) else cmds[2] = tonumber(cmds[2]) end
        player:hurt(cmds[2])
        return
    end

    if cmds[1] == "teleport" or cmds[1] == "tp" then
        local amount = 1
        if cmds[4] ~= nil then amount = tonumber(cmds[4]) end
        if cmds[2] ~= nil and cmds[3] ~= nil then
            player.x = tonumber(cmds[2]*amount)
            player.y = tonumber(cmds[3]*amount)
        end
        return
    end

end
