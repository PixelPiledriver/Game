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
local Arrow = require("Arrow")

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

	Arrow:New{}

	for i=1, 10 do

		Arrow:New
		{
			angle = 0 - i * 49,
			color = Color:Get("orange"),
			length = 100 - (i * 5)
		}

	end 

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