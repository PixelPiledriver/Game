-- DrawLine.lua

-- Purpose
--------------------------------------
-- draw lines at run time
-- will be the base for vector animation skeletons

----------------
-- Requires 
----------------
local Line = require("Line")
local Input = require("Input")
local Collision = require("Collision")
local Color = require("Color")
local Panel= require("Panel")
-------------------------------------------------------------

local DrawLine = {}

-------------------
-- Static Info
-------------------
DrawLine.Info = Info:New
{
	objectType = "DrawLine",
	dataType = "Graphics",
	structureType = "Static"
}


-------------------
-- Static Vars
-------------------

DrawLine.active = false

DrawLine.connetToLast = true

DrawLine.lines = {}

DrawLine.newPoints =
{
	a = nil,
	b = nil
}

DrawLine.selectedPoints = {}
DrawLine.selectIndex = Index:New(DrawLine.lines)
DrawLine.selectIndex.maxOffset = 1
DrawLine.selectType = "Index"

DrawLine.joinPoints = 
{
	a = nil,
	b = nil,
}

DrawLine.breakPoints = 
{
	a = nil,
	b = nil
}

-- Color
------------

DrawLine.color = Color:Get("white")

-------------
-- Input
-------------
DrawLine.Input = Input:New{}

local nextIndex =
{
	"6", "press",
	function()
		DrawLine.selectIndex:Plus()
	end 
}

local prevIndex =
{
	"5", "press",
	function()
		DrawLine.selectIndex:Minus()
	end 
}

local joinPoints =
{
	"4", "press",
	function()
		DrawLine:JoinPoints()
	end 	
}

local breakPoints =
{
	"3", "press",

}

DrawLine.Input:AddKeys
{
	nextIndex, prevIndex, joinPoints
}


------------------------
-- Static Functions
------------------------

function DrawLine:Start()

	DrawLine.active = true

	----------------
	-- Collision
	----------------
	DrawLine.collision = Collision:New
	{
		width = 200,
		height = 200,
		mouse = true,
		xOffset = -100,
		yOffset = -100
	}

	DrawLine.resizeBy = 25
	DrawLine.resizeAcceleration = 1.2

	-- Panel
	-----------

	DrawLine.panel = Panel:New
	{
		name = "DrawLine",
		gridWidth = 32,
		gridHeight = 32,
		x = 100,
		y = 100
	}


end 

function DrawLine:Update()
	if(self.active == false) then
		return
	end 

	self:SetPoint() --> draw
	self:MoveSelectedPoints()
	self:TestPointsToCollision()
	self:ClearSelectedPoints()
	self:ResizeSelectionBox()

end 

function DrawLine:JoinPoints()


	if(self.collision.collided) then

		if(self.joinPoints.a == nil) then

			self.joinPoints.a = self.selectedPoints[1]
			printDebug{"JoinPoints: set point A", "DrawLine"}

		else
			self.joinPoints.b = self.selectedPoints[1]
			printDebug{"JoinPoints: set point B", "DrawLine"}

			self.joinPoints.a.x = self.joinPoints.b.x
			self.joinPoints.a.y = self.joinPoints.b.y
			
			printDebug{"JoinPoints!", "DrawLine", 2}

			self.joinPoints.a = nil
			self.joinPoints.b = nil
		end 


	end 
end 

function DrawLine:ResizeSelectionBox()
	if(Mouse.wheelUp) then

		self.collision.Size.width = self.collision.Size.width + self.resizeBy
		self.collision.Size.height = self.collision.Size.height + self.resizeBy

		self.collision.xOffset = self.collision.xOffset - (self.resizeBy/2)
		self.collision.yOffset = self.collision.yOffset - (self.resizeBy/2)
	end 

	if(Mouse.wheelDown) then

		self.collision.Size.width = self.collision.Size.width - self.resizeBy
		self.collision.Size.height = self.collision.Size.height - self.resizeBy
		
		self.collision.xOffset = self.collision.xOffset + (self.resizeBy/2)
		self.collision.yOffset = self.collision.yOffset + (self.resizeBy/2)

		if(self.collision.Size.width <= 8) then
			self.collision.Size.width = 16
			self.collision.Size.height = 16
			
			self.collision.xOffset = -4
			self.collision.yOffset = -4
		end 

	end 

end 


function DrawLine:ClearSelectedPoints()
	-- save for print --> make optional
	self.lastSelectedPoints = nil
	self.lastSelectedPoints = self.selectedPoints

	self.selectedPoints = nil
	self.selectedPoints = {}
end 

-- check for points under mouse selection
function DrawLine:TestPointsToCollision()

	-- points to test?
	if(self.collision.pointsList == nil) then
		self.collision.pointsList = {}
	end 

	-- add all points to collision
	for i=1, #self.lines do
		self.collision.pointsList[#self.collision.pointsList+1] = self.lines[i].a
		self.collision.pointsList[#self.collision.pointsList+1] = self.lines[i].b
	end 

end 

function DrawLine:SetPoint()

	if(Mouse:SingleClick("l")) then

		repeat

		if(self.newPoints.a == nil) then
			self.newPoints.a = {}
			self.newPoints.a.x = love.mouse.getX()
			self.newPoints.a.y = love.mouse.getY()
			break
		end 

		if(self.newPoints.b == nil) then

			--print("make B")

			self.newPoints.b = {}
			self.newPoints.b.x = love.mouse.getX()
			self.newPoints.b.y = love.mouse.getY()

			-- create new line
			self.lines[#self.lines+1] = Line:New
			{
				a = self.newPoints.a,
				b = self.newPoints.b,
				collidablePoints = true,
				DrawLine = self,
				color = self.color
			}

			local copyB = nil
			
			if(self.connetToLast) then
				copyB = 
				{
					x = self.newPoints.b.x,
					y = self.newPoints.b.y
				}
			end 

			self.newPoints.a = nil
			self.newPoints.b = nil

			self.newPoints.a = 
			{
				x = copyB.x,
				y = copyB.y
			}

			break
		end 

		until true

	end 	

end 

function DrawLine:AddSelectedPoint(point)
	point.xOffset = point.x - love.mouse.getX()
	point.yOffset = point.y - love.mouse.getY()
	self.selectedPoints[#self.selectedPoints + 1] = point

end 

-- move position of points with mouse
-- basic bullshit right now
function DrawLine:MoveSelectedPoints()
	if(#self.lines == 0) then
		return
	end 

	if(love.mouse.isDown("r")) then

		for i=1, #self.selectedPoints do
			self.selectedPoints[i].x = love.mouse.getX() + self.selectedPoints[i].xOffset
			self.selectedPoints[i].y = love.mouse.getY() + self.selectedPoints[i].yOffset
		end 

	end 

end 


function DrawLine:PrintDebugText()

	local text = 
	{
		{text = "", obj = "DrawLine" },
		{text = "DrawLine"},
		{text = "---------------------"},
		{text = "Lines: " .. #self.lines},
		{text = "Active: " .. Bool:ToString(self.active)},
		{text = "Index: " .. self.selectIndex.index}
	}

	text[#text+1] = {text = "Selected Points: " .. (self.lastSelectedPoints and #self.lastSelectedPoints or 0)}

	if(self.collision) then
		text[#text+1] = {text = "Selection Size: " .. self.collision.Size.width}
	end 

	DebugText:TextTable(text)

end



function DrawLine:Exit()

	for i=1, #self.lines do
		ObjectManager:Destroy(self.lines[i])
		self.lines[i] = nil
	end

	self.lines = nil
	self.lines = {}

	for i=1, #self.selectedPoints do
		self.selectedPoints[i] = nil
	end 

	self.selectedPoints = nil

	self.joinPoints.a = nil
	self.joinPoints.b = nil

	ObjectManager:Destroy(self.collision)
	self.collision = nil

end 


ObjectManager:AddStatic(DrawLine)

return DrawLine

-- Notes
--------------------------

-- break points

-- join points



-- Junk
------------------------------------------------------------------

	--[[

	if(self.selectType == "Index") then

		if(self.selectIndex.index == 1) then
			self.lines[1].a.x = love.mouse.getX()
			self.lines[1].a.y = love.mouse.getY()
		
		elseif(self.selectIndex:IsMax()) then

			self.lines[#self.lines].b.x = love.mouse.getX()
			self.lines[#self.lines].b.y = love.mouse.getY()

		else
			self.lines[self.selectIndex.index-1].b.x = love.mouse.getX()
			self.lines[self.selectIndex.index-1].b.y = love.mouse.getY()

			self.lines[self.selectIndex.index].a.x = love.mouse.getX()
			self.lines[self.selectIndex.index].a.y = love.mouse.getY()

		end

	end 

	--]]


	--[[
	for i=1, #self.selectedPoints do
		print("move")
		self.selectedPoints[i].x = love.mouse.getX()
		self.selectedPoints[i].y = love.mouse.getY()
	end
	--]]











