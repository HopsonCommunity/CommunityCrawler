require "full"
Prop = class:new()
Prop:addparent(Entity)

Prop.id = "prop"
Prop.type = "props"
function Prop:load(id)
    self.id = id
    self:loadAnim()
end
