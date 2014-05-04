
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires
require("DeltaTime")
require("ConsoleSetup")
local FrameCounter = require("FrameCounter")


-- game start
-- runs only once
function love.load()
	require("MathTest")
end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)
end 


-- draw call
function love.draw()
	FrameCounter:Draw()
end 


