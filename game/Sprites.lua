-- load sprites here
-- just messy shit for now
-- no biggie

local Animation = require("Animation")

local Sprites = {}


------------------
-- Functions
------------------

local function MakeFrame(data)
	local f = {}

	f.x = data.x or 0
	f.y = data.y or 0
	f.width = data.width or 1
	f.height = data.height or 1
	f.imageWidth = data.imageWidth or 128
	f.imageHeight = data.imageHeight or 128

	return love.graphics.newQuad(f.x, f.y, f.width, f.height, f.imageWidth, f.imageHeight)
end 



------------------
-- Pawn
------------------
Sprites.pawn = {}


-- create sprite sheet
Sprites.pawn.sheet = love.graphics.newImage("graphics/pawnSheet.png")
Sprites.pawn.sheet:setFilter("nearest", "nearest")

-- create frames
-- eventually will change to create animations
-- but this is just some shit for now :P
Sprites.pawn.idle = MakeFrame
{
	x = 0,
	y = 0,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128
}

Sprites.pawn.attack = MakeFrame
{
	x = 0,
	y = 64,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128
}

Sprites.pawn.walk = MakeFrame
{
	x = 64,
	y = 0,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128
}

Sprites.pawn.damage = MakeFrame
{
	x = 64,
	y = 64,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128	
}


Sprites.pawn.animation1 = Animation:New
{
	name = "stuff",

	sheet = Sprites.pawn.sheet,
	frames =	{
							Sprites.pawn.walk, 
							Sprites.pawn.damage, 
							Sprites.pawn.attack, 
							Sprites.pawn.idle
						},

	delays = {20, 3, 12, 3},
	speed = 1,
}

return Sprites