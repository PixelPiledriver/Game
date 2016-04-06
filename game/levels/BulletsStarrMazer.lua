-- BulletsStarrMazer.lua

-- Description
---------------------------------------
-- Test animations for work here

-- Requires
----------------------
local Color = require("Color")
local BulletShooter = require("BulletShooter")

---------------------------------------------------------


local Start = function()

	local Pewpew = BulletShooter:New{}

	love.graphics.setBackgroundColor(Color:AsTable(Color:Get("black")))

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

	filename = "BulletsStarrMazer"
}

return level