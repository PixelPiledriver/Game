
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires --> load and run shit in other files
require("DeltaTime")
require("ConsoleSetup")
local FrameCounter = require("FrameCounter")
local App = require("App")
local Box = require("Box")
local Player = require("Player")
local Sprites = require("Sprites")

--------------
-- Objects
--------------

-- will move object loader to own file soon :P
local pawn = Player:New
{
	x = 200,
	y = 300,
	
	useFrame = true,
	sheet = Sprites.pawn.sheet,
	frame = Sprites.pawn.attack,
	
	color = {255,255,255,255}
}

--[[
local pawn2 = Player:New
{
	x = 300,
	y = 300,
	color = {255, 100, 100, 255},

	useFrame = true,
	sheet = Sprites.pawn.sheet,
	frame = Sprites.pawn.damage,
	
	xScale = -1, -- flip this dude, this is junk code that will be removed

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down"
	}

}
--]]

local pawn2 = Player:New
{
	x = 400,
	y = 400,
	color = {1,1,1,1},
	useAnimation = true,
	animation = Sprites.pawn.animation1,

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down"
	}

}

local box1 = Box:New
{
	x = 200,
	y = 200
}





-- game start
-- runs only once
function love.load()
	-- graphics setup
	love.window.setFullscreen(false, "desktop")
	love.graphics.setBackgroundColor(100,100,100)

	require("MathTest")

end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)

	pawn:RepeatedInput()
	pawn2:RepeatedInput()
end 


-- input
function love.keypressed(key)
	App:Input(key)
	pawn:Input(key)
	pawn2:Input(key)
end


-- draw call
function love.draw()
	FrameCounter:Draw()

	pawn2:Draw()
	pawn:Draw()
	box1:Draw()
	
	
end 


