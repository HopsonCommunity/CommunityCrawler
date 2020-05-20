require "libs.SECL.full"
props = {}

props["crate"] = {
	shadow = {
		{x = 4, y = 0},
		{x = 26, y = 0},
		{x = 26, y = 32},
		{x = 4, y = 32}
	}
}

Prop = class:new()
Prop:addparent(Entity)

Prop.id = "prop"
Prop.type = "props"
function Prop:load(floor)
	self.floor = floor
	self.shadow = props[self.id].shadow
    self:loadAnim()
	self:loadShadow()
end

function Prop:update()
end
