require "libs.SECL.full"

DroppedItem = class:new()
DroppedItem:addparent(Entity)

DroppedItem.id = "droppedItem"
DroppedItem.type = "items"
function DroppedItem:load(floor)
	self.floor = floor
    self:loadAnim()
end

function DroppedItem:update()
end
