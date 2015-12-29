-- DrawLineLevel.lua

-- Description
---------------------------------------
-- test vector drawing

require("DrawLine")
---------------------------------------------------------

local Start = function()

end


local Update = function()

end


local Exit = function()

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