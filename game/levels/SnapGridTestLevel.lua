--******************************************************************--
-- Timer.lua
-- Class for timer objects
-- writen by Adam Balk, August 2014
--*******************************************************************--

local SnapGrid = require("SnapGrid") 
local SnapPlayer = require("SnapPlayer")
local Sprites = require("Sprites")
local PlayerSkins = require("PlayerSkins")

local Guns = require("Guns")

local SnapGridTestLevel = {}



function SnapGridTestLevel:Load()
	SnapGrid:CreateBoard()

	local gridX = 1
	local gridY = 1
	local redRobot = SnapPlayer:New
	{
		name = "redRobot",

		gridX = gridX,
		gridY = gridY,

--		x = gridX * SnapGrid.cellWidth,
--		y = gridY * SnapGrid.cellHeight,
		frame = Sprites.dude.red.idle,
		skin = PlayerSkins.red,
		
		playerColor = "darkRed",
		gun = Guns.laserRifle
	}
end

function SnapGridTestLevel:Update()

end

function SnapGridTestLevel:Exit()
end

return SnapGridTestLevel 