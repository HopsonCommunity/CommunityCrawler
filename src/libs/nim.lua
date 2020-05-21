local nim = {}
local particles = {}

--[[
function nim.newAnim(image, width, height, duration)
    local animation = {}
	local fim = image
	fim:setFilter("nearest", "nearest")
    animation.spriteSheet = fim
    animation.quads = {}
	animation.width = width
	animation.height = height
 
    for y = 0, fim:getHeight() - height, height do
        for x = 0, fim:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, fim:getDimensions()))
        end
    end
 
    animation.duration = duration or 1
    animation.currentTime = 0
	function animation:update(t)
		self.currentTime = (self.currentTime + t) % animation.duration
		return self
	end
 
    return animation
end
]]

function nim.newAnim(image, width, height, duration, row, ox, oy)
	if row < 1 then return end
	
    local animation = {}
	local fim = image
	fim:setFilter("nearest", "nearest")
    animation.spriteSheet = fim
    animation.quads = {}
	animation.width = width
	animation.height = height
	animation.ox = ox or 0
	animation.oy = oy or 0
 
    for x = 0, fim:getWidth() - width, width do
		table.insert(animation.quads, love.graphics.newQuad(x, (row-1) * height, width, height, fim:getDimensions()))
	end
 
    animation.duration = duration or 1
    animation.currentTime = 0
	function animation:update(t)
		self.currentTime = (self.currentTime + t) % animation.duration
		return self
	end
 
    return animation
end

function nim.drawAnim(anim, x, y, r, flip)
	local spriteNum = math.floor(anim.currentTime / anim.duration * #anim.quads) + 1
	if spriteNum < 1 then return end
	if flip then
		love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], x + (anim.width / 2) + anim.ox, y + (anim.height / 2) + anim.oy, math.rad((r or 90) - 90), -1, 1, anim.width / 2, anim.height / 2)
	else
		love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], x + (anim.width / 2) + anim.ox, y + (anim.height / 2) + anim.oy, math.rad((r or 90) - 90), 1, 1, anim.width / 2, anim.height / 2)
	end
end

function nim.drawTile(anim, x, y, r, flip)
	local spriteNum = (anim.duration - math.floor(anim.duration - anim.currentTime)) + 1
	if spriteNum < 1 then return end
	if flip then
		love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], x + (anim.width / 2) + anim.ox, y + (anim.height / 2) + anim.oy, math.rad((r or 90) - 90), -1, 1, anim.width / 2, anim.height / 2)
	else
		love.graphics.draw(anim.spriteSheet, anim.quads[spriteNum], x + (anim.width / 2) + anim.ox, y + (anim.height / 2) + anim.oy, math.rad((r or 90) - 90), 1, 1, anim.width / 2, anim.height / 2)
	end
end

local function split(self, inSplitPattern, outResults) -- snippet
	if not outResults then
		outResults = {}
	end
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
	while theSplitStart do
		table.insert(outResults, string.sub(self, theStart, theSplitStart-1))
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
	end
	table.insert(outResults, string.sub(self, theStart))
	return outResults
end

local function lcp(t)
	local ot = {}
	for k, v in pairs(t) do ot[k] = v end
	return ot
end

local function lerp(c, t, o)
	local lo = math.max(math.min(o or 0.5, 1), 0)
	return ((c * (1 - lo)) + (t * lo))
end

function nim.newParticle(c, ncs, mcs, ss, ns, ms, t, nd, md, nxv, mxv, nyv, myv, f, g, fl, sr, nrot, mrot)
	return {c = c, _cs = {min = (ncs or c), max = (mcs or c)}, _s = {min = (ns or 1), max = (ms or 1), start = (ss or 0)}, t = t, _d = {min = nd, max = md}, _xv = {min = (nxv or -1), max = (mxv or 1)}, _yv = {min = (nyv or -1), max = (myv or 1)}, g = g, f = f, fl = fl, _rot = {min = (nrot or -1), max = (mrot or 1), start = (sr or 0)}, tmr = 0}
end

function nim.addParticle(pa, x, y)
	local p = lcp(pa)
	local rand = {"s", "d", "xv", "yv", "rot"}
	for i, v in ipairs(rand) do
		p[v] = math.random() * (p["_" .. v].max - p["_" .. v].min) + p["_" .. v].min
	end
	p.cs = {}
	local lv = math.random()
	p.cs[1] = lerp(p._cs.min[1], p._cs.max[1], lv)
	p.cs[2] = lerp(p._cs.min[2], p._cs.max[2], lv)
	p.cs[3] = lerp(p._cs.min[3], p._cs.max[3], lv)
	p.cs[4] = lerp(p._cs.min[4] or 1, p._cs.max[4] or 1, lv)
	p.x, p.y = x, y
	table.insert(particles, p)
end

function nim.updateParticles(dt)
	local rem = {}
	for i, p in ipairs(particles) do
		if p.f then
			p.xv = p.xv * p.f
		end
		if p.g then
			p.yv = p.yv + (p.g * dt)
		end
		p.x = p.x + (p.xv * dt)
		p.y = p.y + (p.yv * dt)
		p.tmr = p.tmr + dt
		if p.tmr > p.d then table.insert(rem, i) end
	end
	local off = 0
	for i, v in ipairs(rem) do
		table.remove(particles, v - off)
		off = off + 1
	end
end

function nim.drawParticles()
	local oc = {love.graphics.getColor()}
	for i, p in ipairs(particles) do
		local c = {}
		local l = p.tmr / p.d
		c[1] = lerp(p.c[1], p.cs[1], l)
		c[2] = lerp(p.c[2], p.cs[2], l)
		c[3] = lerp(p.c[3], p.cs[3], l)
		c[4] = lerp(p.c[4] or 1, p.cs[4] or 1, l)
		local s = lerp(p._s.start, p.s, l)
		local r = lerp(p._rot.start, p.rot, l)
		love.graphics.push()
		love.graphics.translate(p.x, p.y)
		love.graphics.rotate(math.rad(r))
		love.graphics.translate(-p.x, -p.y)
		if p.t == "circle" then
			love.graphics.setColor(c)
			love.graphics.circle(p.fl, p.x, p.y, s / 2)
		elseif p.t == "square" then
			love.graphics.setColor(c)
			love.graphics.rectangle(p.fl, p.x - s / 2, p.y - s / 2, s, s)
		end
		love.graphics.pop()
	end
	love.graphics.setColor(oc)
end

function nim.loadTilemap(tm, file, loader)
	local map = {}
	tm.tiles = {}
	if (loader == nil) or (loader == "csv") then
		for line in love.filesystem.lines(fil) do
			table.insert(map, line)
		end
		for i in ipairs(map) do
			map[i] = split(map[i], ",")
		end
	end
	for x, s in ipairs(map) do
		for y, tile in ipairs(s) do
			tm:set(x, y, tile)
		end
	end
end

function nim.newTaggedTile(name, tag)
	local tile = {name = name, tag = tag}
	return tile
end

function nim.newDataTile(name, data, tag)
	local tile = {name = name, data = data, tag = tag}
	return tile
end

function nim.newTilemap(tilegfx, size)
	local map = {tiles = {}, tilegfx = tilegfx or {}, size = size or 16}
	function map:set(x, y, v, layer)
		local l = layer or 1
		if not map.tiles[l] then map.tiles[l] = {} end
		if map.tiles[l][x] then
			map.tiles[l][x][y] = v
		else
			map.tiles[l][x] = {}
			map.tiles[l][x][y] = v
		end
	end
	function map:get(x, y, layer)
		local l = layer or 1
		if map.tiles[l][x] then
			return map.tiles[l][x][y]
		else
			return nil
		end
	end
	return map
end

function nim.drawTilemap(map, px, py)
	local x, y = px or 0, py or 0
	for l, layer in pairs(map.tiles) do
		for _x, s in pairs(layer) do
			for _y, tile in pairs(s) do
				if (type(tile) == "string") or (type(tile) == "number") then
					if map.tilegfx[tile] then
						love.graphics.draw(map.tilegfx[tile], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
					else
						love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
					end
				else
					if type(map.tilegfx[tile.name]) == "table" then
						if map.tilegfx[tile.name][tile.tag] then
							love.graphics.draw(map.tilegfx[tile.name][tile.tag], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
						else
							love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
						end
					else
						if map.tilegfx[tile.name] then
							love.graphics.draw(map.tilegfx[tile.name], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
						else
							love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
						end
					end
				end
			end
		end
	end
end

function nim.drawTilemapLayer(map, dl, px, py)
	local x, y = px or 0, py or 0
	for _x, s in pairs(map.tiles[dl]) do
		for _y, tile in pairs(s) do
			if (type(tile) == "string") or (type(tile) == "number") then
				if map.tilegfx[tile] then
					love.graphics.draw(map.tilegfx[tile], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
				else
					love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
				end
			else
				if type(map.tilegfx[tile.name]) == "table" then
					if map.tilegfx[tile.name][tile.tag] then
						love.graphics.draw(map.tilegfx[tile.name][tile.tag], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
					else
						love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
					end
				else
					if map.tilegfx[tile.name] then
						love.graphics.draw(map.tilegfx[tile.name], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
					else
						love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
					end
				end
			end
		end
	end
end

function nim.drawTilemapNotLayer(map, nl, px, py)
	local x, y = px or 0, py or 0
	for l, layer in pairs(map.tiles) do
		if l ~= nl then
			for _x, s in pairs(layer) do
				for _y, tile in pairs(s) do
					if (type(tile) == "string") or (type(tile) == "number") then
						if map.tilegfx[tile] then
							love.graphics.draw(map.tilegfx[tile], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
						else
							love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
						end
					else
						if type(map.tilegfx[tile.name]) == "table" then
							if map.tilegfx[tile.name][tile.tag] then
								love.graphics.draw(map.tilegfx[tile.name][tile.tag], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
							else
								love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
							end
						else
							if map.tilegfx[tile.name] then
								love.graphics.draw(map.tilegfx[tile.name], x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
							else
								love.graphics.draw(map.tilegfx.notex, x + ((_x - 1) * map.size), y + ((_y - 1) * map.size))
							end
						end
					end
				end
			end
		end
	end
end

function nim.newProgressBar(sx, sy, typ, f, c, bc, oc)
	local bar = {sx = sx, sy = sy, typ = (typ or "horizontal"), c = c or {0.2, 1, 0.4}, bc = bc or {((c or {})[1] or 0.2) * 0.3, ((c or {})[2] or 1) * 0.3, ((c or {})[3] or 0.4) * 0.3, 0.7}, oc = oc or {((c or {})[1] or 0.2) * 0.5, ((c or {})[2] or 1) * 0.5, ((c or {})[3] or 0.4) * 0.5, 0.7}, f = f or 0}
	return bar
end

function nim.drawProgressBar(bar, x, y)
	local c = {love.graphics.getColor()}
	love.graphics.setColor(bar.oc)
	love.graphics.rectangle("line", x, y, bar.sx, bar.sy)
	love.graphics.setColor(bar.bc)
	love.graphics.rectangle("fill", x + 1, y + 1, bar.sx - 2, bar.sy - 2)
	love.graphics.setColor(bar.c)
	if bar.typ == "horizontal" then
		if bar.f ~= 0 then
			love.graphics.rectangle("fill", x + 1, y + 1, (bar.sx*(bar.f/100)) - 2, bar.sy - 2)
		end
	elseif bar.typ == "vertical" then
		if bar.f ~= 0 then
			love.graphics.rectangle("fill", x + 1, y + 1, bar.sx - 2, (bar.sy*(bar.f/100)) - 2)
		end
	end
	love.graphics.setColor(c)
end

return nim