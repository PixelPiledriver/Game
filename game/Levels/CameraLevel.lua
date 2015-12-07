-- CameraLevel.lua

-- Description
-----------------------------------------------------------
-- level for sorting out camera features and bugs
-- need to run some tests to make sure the camera code works well

----------------
-- Requires
----------------
local Box = require("Box")
local Color = require("Color")

----------------------------------------------------------------

local Start = function()
	print("BAM")

	Box:New
	{
		x = 0,
		y = 0,
		width = 100,
		height = 100,
		color = Color:Get("blue")
	}

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
	Restart = Restart
}

return level