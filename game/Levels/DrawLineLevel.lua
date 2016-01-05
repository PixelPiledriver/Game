-- DrawLineLevel.lua

-- Description
---------------------------------------
-- test vector drawing

local DrawLine = require("DrawLine")
---------------------------------------------------------

local Start = function()
	local mouse = Mouse:New{name = "mouse"}
	DrawLine:Start()
end

local Update = function()
end

local Restart = function()
end 

local Exit = function()
	DrawLine.active = false
	DrawLine:Exit()
end




local level = Level:New
{
	Start = Start,
	Update = Update,
	Restart = Restart,
	Exit = Exit,

	filename = "DrawLineLevel"
}

return level