-- DrawLine.lua

-- Purpose
--------------------------------------
-- draw lines at run time
-- will be the base for vector animation skeletons

----------------
-- Requires 
----------------
local Line = require("Line")

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

DrawLine.active = true

DrawLine.lines = {}

DrawLine.newPoints =
{
	a = nil,
	b = nil
}

DrawLine.number = 0

function DrawLine:Update()
	if(self.active == false) then
		return
	end 
	
	self:SetPoint()
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
			self.newPoints.b = {}
			self.newPoints.b.x = love.mouse.getX()
			self.newPoints.b.y = love.mouse.getY()

			-- create new line
			self.lines[#self.lines+1] = Line:New
			{
				a = self.newPoints.a,
				b = self.newPoints.b
			}

			self.newPoints.a = nil
			self.newPoints.b = nil
			break
		end 

		until true

	end 	

end 

function DrawLine:CreateLine()
	if(self.newPoints.a and self.newPoints.b) then

	end 

end 

function DrawLine:PrintDebugText()

	DebugText:TextTable
	{
		{text = "", obj = "DrawLine" },
		{text = "DrawLine"},
		{text = "---------------------"},
		{text = "Lines: " .. #self.lines},
		{text = "number: " .. self.number}
	}

end 


ObjectManager:AddStatic(DrawLine)

return DrawLine


