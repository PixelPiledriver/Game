-- ShaderLevel.lua

-- Description
---------------------------------------
-- test room for shader stuff

-- Requires
----------------------
local Image = require("Image")
local ScrollerSystem = require("ScrollerSystem")

---------------------------------------------------------


local Start = function()
	--[[
	Image:New
	{
		filename = "scroller/" .. "woman1.png",
		layer = "Scroll1",
		--shader = "blue",
		x = 300,
		y = 100
	}

	Image:New
	{
		filename = "UserFiles/dog.png",
		layer = "Scroll2",
		x = 100,
		y = 300
	}
	--]]

	local LevelScroll = ScrollerSystem:New{folder = "UserFiles"}

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

	filename = "ShaderLevel"
}

return level