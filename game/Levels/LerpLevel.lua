-- LerpLevel.lua

-- Description
----------------------------------
-- helped Decroded with some lerp code
-- this level isnt really needed
-->DELETE soon

----------------
-- Requires
----------------
local Color = require("Color")
local Box = require("Box")

--------------------------------------------

-- need to premake vars
-- that level functions share
-- is that a problem?
-- I don't really think so
-- but it could make a mass of nil vars that go unused
-- might think of another way of doing it
-- could make a level table and then put all vars inside of it
-- but I dunno we'll see
-- most of the time this wont be needed since objects update themselves
-- will give ti some thought
local box = nil
local t = nil
local bigNumber = nil


local Start = function()

	box = Box:New
	{
		width = 64,
		height = 64,
		x = 100,
		y = 100,
		color = Color:Get("black")
	}

	t = 0.01
	bigNumber = 0

end 

local Update = function()

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


local Exit = function()
end 


local Restart = function()
end 


-----------
-- End
-----------
local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "LerpLevel"
}

return level







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












