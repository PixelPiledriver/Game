-- Notes.lua



-- old junk code goes here








--[[
local pawn2 = Player:New
{
	x = 400,
	y = 400,
	color = {1,1,1,1}, 
	animation = Sprites.pawn.animation1,

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down"
	}

}

--]]

--[[
local box1 = Box:New
{
	x = 200,
	y = 200
}
--]]





--[[

local Steve = Collision:New
{
	x = 200,
	y = 200,
	width = 32,
	height = 32,
	shape = "rect",
	color = Color.blue,
	name = "Steve",
	collisionList = {"Greg"}
}


local box1 = Box:New
{
	x = 150,
	y = 150,
	color = Color.green
}

--]]