-- PixelDrawLevel.lua
-- draw the pixels and stuff


local ObjectUpdater = require("ObjectUpdater")
local Color = require("Color")
local Box = require("Box")


local LerpLevel = {}

local box = Box:New
{
	width = 64,
	height = 64,
	x = 100,
	y = 100,
	color = Color:Get("black")
}

local t = 0.01
local bigNumber = 0

function LerpLevel:Load()

end 


function LerpLevel:Update()

	local xStart = 100 
	local xEnd = 400
	local xMid = (xStart - xEnd) * 0.5

	local x = Math:Lerp
	{
		a = xStart,
		b = xEnd,
		t = t
	}

	local inverse = Math:InverseLerp
	{
		a = xStart,
		b = xEnd,
		t = x
	}

	local lerpSpeed = 0

	if(inverse < 0.5) then
		lerpSpeed = math.abs(( (xStart - xMid) - (box.Pos.x - xMid)) * 0.0001) * 2
	else
		lerpSpeed = math.abs(( (xEnd - box.Pos.x) * 0.0001))
	end 

	t = t + lerpSpeed

	if(t > 0.999) then
		t = 0
		box.Pos.x = xStart
		lerpSpeed = 0.01
	end 

	box.Pos.x = x


end


function LerpLevel:Exit()

end 

return LerpLevel



-- Notes
------------------------------------------------------

--[[


	local lerpSpeed = 0

	if(inverse < 0.5) then

		lerpSpeed = math.abs( (((xStart - xMid) ) - (box.Pos.x - xMid))  * 0.0001)
		--lerpSpeed = (box.Pos.x - xMid) * 0.00001

		--print((box.Pos.x - xMid))
		print(box.Pos.x)

		--print(lerpSpeed)

	end 

	t = t + lerpSpeed
--]]












