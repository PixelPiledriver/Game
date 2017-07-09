-- TemplateLevel.lua

-- Description
---------------------------------------
-- empty level

-- Requires
-------------------
local Image = require("Image")

---------------------------------------------------------

local Start = function()

	booty = Image:New{"graphics/Booty.jpg"}



end

local Update = function()
end

local Restart = function()
end 

local Exit = function()
end



local level = Level:New
{
	Start = Start,
	Update = Update,
	Restart = Restart,
	Exit = Exit,

	filename = "GraphicsTestLevel"
}

return level