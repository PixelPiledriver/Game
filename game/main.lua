
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires
require("DeltaTime")
require("ConsoleSetup")
local FrameCounter = require("FrameCounter")
local App = require("App")
local Box = require("Box")
local Player = require("Player")


-- sprites

local pawnSprite = love.graphics.newImage("graphics/pawn.png")


-- objects

local pawn = Player:New
{
	sprite = pawnSprite,
	x = 200,
	y = 300
}
local pawn2 = Player:New
{
	sprite = pawnSprite,
	x = 300,
	y = 300,
	color = {255, 0, 0, 255},

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down"
	}

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
	pawn:Input(key)
end


-- draw call
function love.draw()
	FrameCounter:Draw()
	pawn:Draw()
	pawn2:Draw()
end 


