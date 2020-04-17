local Path = (...):gsub("%.", "/")
local Shadows = {}

package.loaded["libs.shadows"] = Shadows
package.preload["libs.shadows.Object"]			=	assert(love.filesystem.load(Path.."/Object.lua"))
package.preload["libs.shadows.Transform"]		=	assert(love.filesystem.load(Path.."/Transform.lua"))
package.preload["libs.shadows.LightWorld"]		=	assert(love.filesystem.load(Path.."/LightWorld.lua"))
package.preload["libs.shadows.Light"]				=	assert(love.filesystem.load(Path.."/Light.lua"))
package.preload["libs.shadows.Star"]				=	assert(love.filesystem.load(Path.."/Star.lua"))
package.preload["libs.shadows.Body"]				=	assert(love.filesystem.load(Path.."/Body.lua"))
package.preload["libs.shadows.OutputShadow"]	=	assert(love.filesystem.load(Path.."/OutputShadow.lua"))
package.preload["libs.shadows.PriorityQueue"]	=	assert(love.filesystem.load(Path.."/PriorityQueue.lua"))

-- Shadow shapes

package.preload["libs.shadows.ShadowShapes.Shadow"]			=	assert(love.filesystem.load(Path.."/ShadowShapes/Shadow.lua"))
package.preload["libs.shadows.ShadowShapes.CircleShadow"]	=	assert(love.filesystem.load(Path.."/ShadowShapes/CircleShadow.lua"))
package.preload["libs.shadows.ShadowShapes.HeightShadow"]	=	assert(love.filesystem.load(Path.."/ShadowShapes/HeightShadow.lua"))
package.preload["libs.shadows.ShadowShapes.ImageShadow"]	=	assert(love.filesystem.load(Path.."/ShadowShapes/ImageShadow.lua"))
package.preload["libs.shadows.ShadowShapes.NormalShadow"]	=	assert(love.filesystem.load(Path.."/ShadowShapes/NormalShadow.lua"))
package.preload["libs.shadows.ShadowShapes.PolygonShadow"]	=	assert(love.filesystem.load(Path.."/ShadowShapes/PolygonShadow.lua"))

-- Rooms

package.preload["libs.shadows.Room"]						=		assert(love.filesystem.load(Path.."/Room/Room.lua"))
package.preload["libs.shadows.Room.CircleRoom"]		=		assert(love.filesystem.load(Path.."/Room/CircleRoom.lua"))
package.preload["libs.shadows.Room.PolygonRoom"]		=		assert(love.filesystem.load(Path.."/Room/PolygonRoom.lua"))
package.preload["libs.shadows.Room.RectangleRoom"]	=		assert(love.filesystem.load(Path.."/Room/RectangleRoom.lua"))

package.preload["libs.shadows.Functions"]				=		assert(love.filesystem.load(Path.."/Functions.lua"))
package.preload["libs.shadows.Shaders"]					=		assert(love.filesystem.load(Path.."/Shaders.lua"))

require("libs.shadows.Shaders")
require("libs.shadows.Functions")

return Shadows
