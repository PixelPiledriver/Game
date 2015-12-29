-- DrawLineLevel.lua

-- Description
---------------------------------------
-- test vector drawing

local DrawLine = require("DrawLine")
---------------------------------------------------------

local Start = function()
	DrawLine.active = true
end


local Update = function()

end


local Exit = function()
	DrawLine.active = false
end


local Restart = function()

end 






local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "DrawLineLevel"
}

return level