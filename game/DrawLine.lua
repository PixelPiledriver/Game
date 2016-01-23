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
local Panel = require("Panel")
local Text = require("Text")
local Button = require("Button")
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

DrawLine.previewLine = Line:New
{
	color = Color:Get("hidden")
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

------------
-- Color
------------

DrawLine.color = Color:Get("white")
DrawLine.colors =
{
	Color:Get("white"),
	Color:Get("orange"),
	Color:Get("black"),
	Color:Get("red"),
	Color:Get("blue"),
	Color:Get("green"),
	Color:Get("pink")
}
DrawLine.colorsIndex = Index:New(DrawLine.colors)

-------------
-- Input
-------------
DrawLine.Input = Input:New{}

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
	function()
		DrawLine:BreakPoints()
	end 
}

DrawLine.Input:AddKeys
{
	joinPoints, breakPoints
}

-------------
-- Tools
-------------
DrawLine.tools = {}
DrawLine.tools.line =
{
	active = false,
	
	On = function()
		DrawLine.tools.line.active = true
	end,
	
	Off = function()
		DrawLine.newPoints.a = nil
		DrawLine.newPoints.b = nil
		DrawLine.tools.line.active = false
		DrawLine:ShowPreviewLine(false)
	end,

	Use = function()

		if(Mouse:SingleClick("l")) then

			repeat

			if(DrawLine.newPoints.a == nil) then
				DrawLine.newPoints.a = {}
				DrawLine.newPoints.a.x = Mouse.xView
				DrawLine.newPoints.a.y = Mouse.yView

				DrawLine:ShowPreviewLine(true)
				break
			end 

			if(DrawLine.newPoints.b == nil) then

				DrawLine.newPoints.b = {}
				DrawLine.newPoints.b.x = Mouse.xView
				DrawLine.newPoints.b.y = Mouse.yView

				-- create new line
				DrawLine.lines[#DrawLine.lines+1] = Line:New
				{
					a = DrawLine.newPoints.a,
					b = DrawLine.newPoints.b,
					collidablePoints = true,
					DrawLine = DrawLine,
					color = DrawLine.color
				}

				local copyB = nil
				
				if(DrawLine.connetToLast) then
					copyB = 
					{
						x = DrawLine.newPoints.b.x,
						y = DrawLine.newPoints.b.y
					}
				end 

				DrawLine.newPoints.a = nil
				DrawLine.newPoints.b = nil

				DrawLine.newPoints.a = 
				{
					x = copyB.x,
					y = copyB.y
				}

				DrawLine:ShowPreviewLine(true)

				break
			end 

			until true

		end 	

	end
}

-- move position of points with mouse
DrawLine.tools.movePoints = 
{
	active = false,

	On = function()
		DrawLine.tools.movePoints.active = true
	end,

	Off = function()
		DrawLine.tools.movePoints.active = false
	end,

	Use = function()

		if(#DrawLine.lines == 0) then
			return
		end 

		if(love.mouse.isDown("r")) then

			for i=1, #DrawLine.selectedPoints do
				DrawLine.selectedPoints[i].x = love.mouse.getX() + DrawLine.selectedPoints[i].xOffset
				DrawLine.selectedPoints[i].y = love.mouse.getY() + DrawLine.selectedPoints[i].yOffset
			end 

		end 

	end
}

DrawLine.tools.joinPoints = 
{
	active = false,

	On = function()
		DrawLine.tools.joinPoints.active = true
	end,

	Off = function()
		DrawLine.tools.joinPoints.active = false
	end,

	Use = function()

		if(Mouse:SingleClick("l")) then
			if(DrawLine.collision.collided) then

				-- one point, 2 clicks
				if(#DrawLine.selectedPoints == 1) then
					DrawLine.tools.joinPoints.UsePointCountVariations:Single()

				-- two points, 1 click
				elseif(#DrawLine.selectedPoints == 2) then
					DrawLine.tools.joinPoints.UsePointCountVariations:Two()

				-- lots of points, 1 click
				elseif(#DrawLine.selectedPoints > 2) then
					DrawLine.tools.joinPoints.UsePointCountVariations:Many()
				end 


			end 
		end

	end,

	UsePointCountVariations =
	{
		Single = function()
			if(DrawLine.joinPoints.a == nil) then

			
				DrawLine.joinPoints.a = DrawLine.selectedPoints[1]
				
				printDebug{"JoinPoints: set point A", "DrawLine"}

			else
				DrawLine.joinPoints.b = DrawLine.selectedPoints[1]
				printDebug{"JoinPoints: set point B", "DrawLine"}

				DrawLine.joinPoints.a.x = DrawLine.joinPoints.b.x
				DrawLine.joinPoints.a.y = DrawLine.joinPoints.b.y
				
				printDebug{"JoinPoints!", "DrawLine"}

				DrawLine.joinPoints.a = nil
				DrawLine.joinPoints.b = nil
			end 
		end,

		Two = function()
			DrawLine.selectedPoints[1].x = DrawLine.selectedPoints[2].x
			DrawLine.selectedPoints[1].y = DrawLine.selectedPoints[2].y
		end,

		Many = function()
			for i=2, #DrawLine.selectedPoints do
				DrawLine.selectedPoints[i].x = DrawLine.selectedPoints[1].x
				DrawLine.selectedPoints[i].y = DrawLine.selectedPoints[1].y
			end
		end 
	}
}

DrawLine.tools.breakPoints =
{
	active = false,

	On = function()
		DrawLine.tools.breakPoints.active = true
	end,

	Off = function()
		DrawLine.tools.breakPoints.active = false
	end,

	distance = 8,

	Use = function()
	
		if(Mouse:SingleClick("l")) then

			if(#DrawLine.selectedPoints > 1) then

				local broken = false

				for i=1, #DrawLine.selectedPoints do
					for j=i+1, #DrawLine.selectedPoints do

						if(DrawLine.selectedPoints[i].x == DrawLine.selectedPoints[j].x and DrawLine.selectedPoints[i].y == DrawLine.selectedPoints[j].y) then

							DrawLine.selectedPoints[i].x = DrawLine.selectedPoints[i].x - DrawLine.tools.breakPoints.distance
							DrawLine.selectedPoints[j].x = DrawLine.selectedPoints[j].x + DrawLine.tools.breakPoints.distance

							DrawLine.selectedPoints[i].y = DrawLine.selectedPoints[i].y - DrawLine.tools.breakPoints.distance
							DrawLine.selectedPoints[j].y = DrawLine.selectedPoints[j].y + DrawLine.tools.breakPoints.distance

							broken = true
						end 
					end 	
				end 

				if(broken) then
					printDebug{"points broken apart", "DrawLine"}
				end 

			end 		

		end 
	end 
}

DrawLine.tools.paint =
{
	active = false,

	On = function()
		DrawLine.tools.paint.active = true
	end,

	Off = function()
		DrawLine.tools.paint.active = false
	end,

	Use = function()

		if(Mouse:Hold("l")) then
			for i=1, #DrawLine.selectedPoints do
				DrawLine.selectedPoints[i].parent.color = DrawLine.color
			end 
		end 

	end 
}

DrawLine.tools.index =
{
	"line", "movePoints", "joinPoints",	"breakPoints", "paint"
}

-- runs all tool functions, if they are activated
function DrawLine.tools:UpdateAllTools()

	for i=1, #DrawLine.tools.index do
		if(DrawLine.tools[DrawLine.tools.index[i]].active) then
			DrawLine.tools[DrawLine.tools.index[i]].Use()
		end 
	end 

end 

DrawLine.number = 0

function DrawLine.tools:ChangeTest()
	DrawLine.number = DrawLine.number + 1
end 

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
		offsetBySize = true
	}

	DrawLine.resizeBy = 25
	DrawLine.resizeAcceleration = 1.2


	-----------
	-- Panel
	-----------

	DrawLine.colorText = Text:New
	{
		text = "Color",
		color = self.color,
		box = {}
	}



	DrawLine.colorNext = Button:New
	{
		name = "Next Color",
		text = ">",
		width = 32,
		height = 32,
		func = function()
			DrawLine.colorsIndex:Next()
			DrawLine.color = DrawLine.colors[DrawLine.colorsIndex.index] 
		end 
	}

	DrawLine.colorPrev = Button:New
	{
		name = "Prev Color",
		text = "<",
		width = 32,
		height = 32,
		func = function()
			DrawLine.colorsIndex:Prev()
			DrawLine.color = DrawLine.colors[DrawLine.colorsIndex.index] 
		end 
	}

	DrawLine.panel = Panel:New
	{
		name = "DrawLine",
		gridWidth = 48,
		gridHeight = 32,
		x = 100,
		y = 100
	}

	DrawLine.panel:AddVertical
	{
		DrawLine.colorText, DrawLine.colorPrev, DrawLine.colorNext
	}

	--DrawLine.panel:AddHorizontal{DrawLine.colorNext}

	require("DrawLine_UI")

end 


function DrawLine:Update()
	if(self.active == false) then
		return
	end 

	self.tools:UpdateAllTools()
	--self:SetPoint() --> draw
	--self:MoveSelectedPoints()
	self:TestPointsToCollision()
	self:ClearSelectedPoints()
	self:ResizeSelectionBox()
	self:UpdatePreviewLine()
	self:CancelDraw()


	

	self.colorText.color = self.color
end 
 
function DrawLine:CancelDraw()

	if(Mouse:SingleClick("r") and self.newPoints.a) then
		self:ShowPreviewLine(false)
		self.newPoints.a = nil
		printDebug{"Line draw canceled", "DrawLine"}
	end 

end 


local breakDistance = 8
function DrawLine:BreakPoints()

	if(self.tools.breakPoints.active == false) then
		return
	end 

	if(#self.selectedPoints > 1) then

		local broken = false

		for i=1, #self.selectedPoints do
			for j=i+1, #self.selectedPoints do

				if(self.selectedPoints[i].x == self.selectedPoints[j].x and self.selectedPoints[i].y == self.selectedPoints[j].y) then

					self.selectedPoints[i].x = self.selectedPoints[i].x - breakDistance
					self.selectedPoints[j].x = self.selectedPoints[j].x + breakDistance

					self.selectedPoints[i].y = self.selectedPoints[i].y - breakDistance
					self.selectedPoints[j].y = self.selectedPoints[j].y + breakDistance

					broken = true
				end 
			end 	
		end 

		if(broken) then
			printDebug{"points broken apart", "DrawLine"}
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
			
			self.collision.xOffset = -8
			self.collision.yOffset = -8
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

function DrawLine:UpdatePreviewLine()
	if(self.showPreviewLine == false) then
		return 
	end 

	self.previewLine.color.r = self.color.r
	self.previewLine.color.g = self.color.g
	self.previewLine.color.b = self.color.b

	self.previewLine.b.x = Mouse.xView
	self.previewLine.b.y = Mouse.yView
end

function DrawLine:ShowPreviewLine(state)

	-- hide
	if(state == false) then
		self.previewLine.color.a = 0
		self.showPreviewLine = false
	end 

	-- show
	if(state == true) then
		self.previewLine.a.x = Mouse.xView
		self.previewLine.a.y = Mouse.yView

		self.previewLine.color.a = 255
		self.showPreviewLine = true
	end 

end 





function DrawLine:AddSelectedPoint(point)
	point.xOffset = point.x - love.mouse.getX()
	point.yOffset = point.y - love.mouse.getY()
	self.selectedPoints[#self.selectedPoints + 1] = point

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

-- move .tools to its own file

-- delete line tool

-- set frames and animation playback

-- join points - single click joins 2 or more in box

-- buttons --> selection list for buttons that cannot be used with other buttons
-- tools --> can define more than one button for
-- all functions a tool can perform should be run on Use

-- select point max

-- select line

-->works
-- preview line

-->works
-- break points

-->works
-- join points



-- Junk
------------------------------------------------------------------
--[==[

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

	


	
	for i=1, #self.selectedPoints do
		print("move")
		self.selectedPoints[i].x = love.mouse.getX()
		self.selectedPoints[i].y = love.mouse.getY()
	end






-- old input 
----------------
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



-- move position of points with mouse
-- basic bullshit right now
function DrawLine:MoveSelectedPoints()

	if(#self.lines == 0) then
		return
	end 

	if(self.tools.movePoints.active == false) then
		return
	end 

	if(love.mouse.isDown("r")) then

		for i=1, #self.selectedPoints do
			self.selectedPoints[i].x = love.mouse.getX() + self.selectedPoints[i].xOffset
			self.selectedPoints[i].y = love.mouse.getY() + self.selectedPoints[i].yOffset
		end 

	end 

end 




function DrawLine:SetPoint()

	if(DrawLine.tools.line.active == false) then
		printDebug{"Line tool not active", "DrawLine", 2}
		return
	end 


	if(Mouse:SingleClick("l")) then

		repeat

		if(self.newPoints.a == nil) then
			self.newPoints.a = {}
			self.newPoints.a.x = Mouse.xView
			self.newPoints.a.y = Mouse.yView

			self:ShowPreviewLine(true)
			break
		end 

		if(self.newPoints.b == nil) then

			self.newPoints.b = {}
			self.newPoints.b.x = Mouse.xView
			self.newPoints.b.y = Mouse.yView

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

			self:ShowPreviewLine(true)

			break
		end 

		until true

	end 	

end 



function DrawLine:JoinPoints()

	if(self.tools.joinPoints.active == false) then
		return
	end

	if(self.collision.collided) then

		if(self.joinPoints.a == nil) then

			self.joinPoints.a = self.selectedPoints[1]
			printDebug{"JoinPoints: set point A", "DrawLine"}

		else
			self.joinPoints.b = self.selectedPoints[1]
			printDebug{"JoinPoints: set point B", "DrawLine"}

			self.joinPoints.a.x = self.joinPoints.b.x
			self.joinPoints.a.y = self.joinPoints.b.y
			
			printDebug{"JoinPoints!", "DrawLine"}

			self.joinPoints.a = nil
			self.joinPoints.b = nil
		end 
	end 

end 




--]==]











