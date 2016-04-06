-- FightStage.lua

-- Purpose
----------------
-- environment data for fighting game level

-- Requires

local Color = require("Color")
local Line = require("Line")
-------------------------------------------

local FightStage = {}

-------------
-- Vars
-------------
FightStage.width = 600
FightStage.height = 300

FightStage.y = Window.height * 0.5
FightStage.x = Window.width * 0.5

FightStage.playerStart =
{
	{x = FightStage.x - 50, y = FightStage.y},
	{x =FightStage.x + 50, y = FightStage.y}
}

-----------------
-- Functions
-----------------
function FightStage:RightEdge()
	return self.x + self.width/2
end 

function FightStage:LeftEdge()
	return self.x - self.width/2
end 

----------------
-- Graphics
----------------

function FightStage:CreateStage()
	local leftCornerPoint = {x = FightStage.x - FightStage.width/2, y = FightStage.y}
	local rightCornerPoint = {x = FightStage.x + FightStage.width/2, y = FightStage.y}
	-- debug stage layout
	FightStage.floor = Line:New
	{
		a = leftCornerPoint,
		b = rightCornerPoint,
		color = Color:Get("yellow")
	}

	FightStage.wallLeft = Line:New
	{
		a = leftCornerPoint,
		b = {x = leftCornerPoint.x, y = leftCornerPoint.y - 100}	
	}

	FightStage.wallRight = Line:New
	{
		a = rightCornerPoint,
		b = {x = rightCornerPoint.x, y = rightCornerPoint.y -  100}
	}
end 

return FightStage