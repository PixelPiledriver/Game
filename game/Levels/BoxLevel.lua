--******************************************************************--
-- TestLevel.lua
-- 1st Test Level (attempts to mitigate out scene specifics to a file 
-- seperate from main)
-- writen by Adam Balk, September 2014
--******************************************************************--

-- requirements for this level
local Box = require("Box")
local Color = require("Color")
local Link = require("Link")
local Mouse = require("Mouse")

-- Table to hold Level objects
local BoxLevel = {}

-- On Level Start
function BoxLevel:Load()

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

-- On Level Update
function BoxLevel:Update()
	
end

-- On Level End
function BoxLevel:Exit()

end

return BoxLevel