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

DrawLine.Input:AddKeys
{
	nextIndex, prevIndex
}

------------------------
-- Static Functions
------------------------

function DrawLine:Update()
	if(self.active == false) then
		return
	end 

	self:SetPoint()
	self:MoveSelectedPoints()

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
				b = self.newPoints.b
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



-- move position of points with mouse
-- basic bullshit right now
function DrawLine:MoveSelectedPoints()
	if(#self.lines == 0) then
		return
	end 

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




end 


function DrawLine:PrintDebugText()
	DebugText:TextTable
	{
		{text = "", obj = "DrawLine" },
		{text = "DrawLine"},
		{text = "---------------------"},
		{text = "Lines: " .. #self.lines},
		{text = "Active: " .. Bool:ToString(self.active)},
		{text = "Index: " .. self.selectIndex.index}
	}
end



function DrawLine:Exit()

	for i=1, #self.lines do
		ObjectManager:Destroy(self.lines[i])
		self.lines[i] = nil
	end

	self.lines = nil
	self.lines = {}

	print(#self.lines)

end 




ObjectManager:AddStatic(DrawLine)

return DrawLine

-- Notes
--------------------------


	--[[
	for i=1, #self.selectedPoints do
		print("move")
		self.selectedPoints[i].x = love.mouse.getX()
		self.selectedPoints[i].y = love.mouse.getY()
	end
	--]]


