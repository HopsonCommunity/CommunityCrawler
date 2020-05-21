local listeners = {}

function addListener(message, func)
	if not listeners[message] then listeners[message] = {} end
	table.insert(listeners[message], func)
end

function removeListener(message, func) -- returns whether it could remove that listener
	for i, v in ipairs(listeners[message]) do
		if v == func then
			table.remove(listeners[message], i)
			if #listeners[message] == 0 then
				listeners[message] = nil
			end
			return true
		end
	end
	return false
end

function publish(message, ...) -- returns whether received
	if listeners[message] then
		for i, v in ipairs(listeners[message]) do
			v(...)
		end
		return true
	else
		return false
	end
end