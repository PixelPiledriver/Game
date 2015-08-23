--******************************************************************--
-- SnapGrid.lua
-- Prototyping MMBN-esque movement and map system
-- writen by Adam Balk, August 2014
--******************************************************************--

-------------
-- Requires
-------------
local Box = require("Box")
local Color = require("Color")

------------------------------------------------
local SnapGrid = {}

-----------------
-- Static Info
-----------------

SnapGrid.Info = Info:New
{
	objectType = "SnapGrid",
	dataType = "Level",
	structureType = "Static"
}

-------------------
-- Static Vars
-------------------

SnapGrid.board = {}
SnapGrid.cellWidth = 37
SnapGrid.cellHeight = 22

SnapGrid.boardWidth = 20
SnapGrid.boardHeight = 20

SnapGrid.x = 0
SnapGrid.y = 0

-------------------------
-- Static Functions
-------------------------

function SnapGrid:CreateCell(data)
--[[
	local gridCell = Box:New
	{
		x = data.x,		
		y = data.y,
		width  = data.width,
		height = data.height,
		color = Color:Get("red"),
		fill = false
	}
--]]
	gridCell.gridPosX = 0
	gridCell.gridPosY = 0

	return gridCell

end

function SnapGrid:SetPosition(x, y)
	self.x = x
	self.y = y
end

function SnapGrid:CreateBoard()
	self.x = 200
	self.y = 200 
	for ix=1, self.boardWidth do
		for iy=1, self.boardHeight do
			-- Create cell and append it to the table of cells in a board
			self.board[#self.board + 1] = self:CreateCell
			{
				gridPosX = ix,
				gridPosY = iy,
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

-- Notes
--------------------
