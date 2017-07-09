-- ScrollTest.lua

-- Description
---------------------------------------
-- level for testing paralax scrolling


-- Requires
------------------------------------
local ScrollerSystem = require("ScrollerSystem")
local Scroller = require("Scroller")
local Image = require("Image")
local Slider = require("Slider")

---------------------------------------------------------

local Start = function()

	local LevelScroll = ScrollerSystem:New{}

	local slider = Slider:New
	{
		x = 150,
		y = 50,
		maxValue = 0.05,
		-- busted because this value is nil sometimes and it needs to build
		-- the access to the var when it exists from strings --> use table of strings
		-- do this tomorrow
		control = {LevelScroll.layers[1], "scrollSpeed"}	
	}

	local slider2 = Slider:New
	{
		x = 250,
		y = 50,
		maxValue = 0.05,
		control = {LevelScroll.layers[2], "scrollSpeed"}	
	}

	local slider3 = Slider:New
	{
		x = 350,
		y = 50,
		maxValue = 0.05,
		control = {LevelScroll.layers[3], "scrollSpeed"}	
	}
	
	--[[
	local slider4 = Slider:New
	{
		x = 450,
		y = 50,
		maxValue = 50,
		control = {LevelScroll, "globalSpeed"}	
	}
	--]]

	--local building = Scroller:New{filename = "woman2.png"}
	--local building2 = Scroller:New{filename = "woman3.png", y = 300}
	
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

	filename = "ScrollTest"
}

return level











-- Junk
------------------------------------
--[[
	local LevelScroll = ScrollerSystem:New{}

	local slider = Slider:New
	{
		x = 150,
		y = 50,
		maxValue = 0.05,
		-- busted because this value is nil sometimes and it needs to build
		-- the access to the var when it exists from strings --> use table of strings
		-- do this tomorrow
		control = {LevelScroll.layers[1], "scrollSpeed"}	
	}

	local slider2 = Slider:New
	{
		x = 250,
		y = 50,
		maxValue = 50,
		control = {LevelScroll.layers[2], "speed"}	
	}

	local slider3 = Slider:New
	{
		x = 350,
		y = 50,
		maxValue = 50,
		control = {LevelScroll.layers[3], "speed"}	
	}
	
	local slider4 = Slider:New
	{
		x = 450,
		y = 50,
		maxValue = 50,
		control = {LevelScroll, "globalSpeed"}	
	}

--]]