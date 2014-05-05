
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires
require("DeltaTime")
require("ConsoleSetup")
local FrameCounter = require("FrameCounter")
local Box = require("Box")

local box1 = Box:New{}
local box2 = Box:New
{
	x = 200,
	y = 200,
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
	require("MathTest")
end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)

	box1:RepeatedInput()
	box2:RepeatedInput()
end 


-- input
function love.keypressed(key)
	box1:Input(key)
	box2:Input(key)
end


-- draw call
function love.draw()
	FrameCounter:Draw()
	box1:Draw()
	box2:Draw()
end 


