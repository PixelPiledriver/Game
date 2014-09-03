--******************************************************************--
-- SnapGrid.lua
-- Prototyping MMBN-esque movement and map system
-- writen by Adam Balk, August 2014
--******************************************************************--

local Box = require("Box")
local Color = require("Color")

local SnapGrid = {}

SnapGrid.cellWidth = 37
SnapGrid.cellHeight = 22

SnapGrid.boardWidth = 20
SnapGrid.boardHeight = 20

SnapGrid.x = 0
SnapGrid.y = 0

function SnapGrid:CreateCell(data)
	local gridCell = Box:New
	{
		x = data.x,		
		y = data.y,
		width  = data.width,
		height = data.height,
		color = Color:Get("red"),
		fill = false
	}	
end

function SnapGrid:CreateBoard()
	for ix=1, self.boardWidth do
		for iy=1, self.boardHeight do
			self:CreateCell
			{
				x = self.x + (ix * SnapGrid.cellWidth),
				y = self.y + (iy * SnapGrid.cellHeight),
				width  = SnapGrid.cellWidth,
				height = SnapGrid.cellHeight
			}
		end
	end
end

--SnapGrid:CreateBoard()

return SnapGrid