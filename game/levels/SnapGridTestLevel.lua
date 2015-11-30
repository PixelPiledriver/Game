--******************************************************************--
-- SnapGridTestLevel.lua
-- 
-- writen by Adam Balk, August 2014
--*******************************************************************--
-- modified: for new level format

-- Requires
----------------------
local SnapGrid = require("SnapGrid") 
local SnapPlayer = require("SnapPlayer")
local Sprites = require("Sprites")
local PlayerSkins = require("PlayerSkins")
local Guns = require("Guns")

--------------------------------------------------------


local Start = function()
	SnapGrid:CreateBoard()

	local gridX = 1
	local gridY = 1
	local redRobot = SnapPlayer:New
	{
		name = "redRobot",

		gridX = gridX,
		gridY = gridY,

		frame = Sprites.dude.red.idle,
		skin = PlayerSkins.red,
		
		playerColor = "darkRed",
		gun = Guns.laserRifle
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

	filename = "SnapGridTestLevel"
}

return level




-- Notes
-------------------
-- this file is garbage
-->DELETE


-- Junk
-----------------------------
--		x = gridX * SnapGrid.cellWidth,
--		y = gridY * SnapGrid.cellHeight,
