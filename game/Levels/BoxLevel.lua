-- BoxLevel.lua

--------------
-- Requrires
--------------
local Box = require("Box")
local Color = require("Color")
local Link = require("Link")


-- On Level Start
local Start = function()

	local mouse = Mouse:New{name = "mouse"}

	local box1 = Box:New
	{
		name = "Box",
		x = 300,
		y = 200,
		width = 50,
		height = 50,
	}

	local widthLink = Link:New
	{
		a = {
					o = box1,
					comp = "Size",
					var = "width"
				},

		b = {
					o = mouse,
					var = "x"
				},

		linkType = "value"
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
	Restart = Restart,

	filename = "BoxLevel"
}

return level