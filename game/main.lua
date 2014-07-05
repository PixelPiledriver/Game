
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires --> load and run shit in other files
require("DeltaTime")
require("PrintDebug")
local FrameCounter = require("FrameCounter")
local ObjectUpdater = require("ObjectUpdater")
local App = require("App")
local Box = require("Box")
local Player = require("Player")
local Sprites = require("Sprites")
local Camera = require("Camera")
local Sound = require("Sound")
local Controller = require("Controller")

--------------
-- Objects
--------------

-- will move object loader to own file soon :P
local redRobot = Player:New
{
	x = 200,
	y = 300,
	
	frame = Sprites.dude.idle,
	playerColor = "darkRed"
}

local blueRobot = Player:New
{
	x = 400,
	y = 300,
	
	frame = Sprites.dude.blue.idle,
	playerColor = "blue",

	xShootPos = -25,
	shootDirection = -1,

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down",
		shoot = "=",
		build = "-",
	}

}




ObjectUpdater:AddCamera(Camera)


--------------------------
-- Functions / Callbacks
--------------------------

-- runs once on startup
function love.load()
	-- graphics setup
	love.window.setFullscreen(false, "desktop")
	love.graphics.setBackgroundColor(100,100,100)

-- audio testing
--[[	source = Sound.CreateSoundSource("WilhelmScream.ogg")
	Sound.SetVolume(source, 0.5)
	print(Sound.GetVolume(source))
	Sound.ToggleLooping(source)
	Sound.PlaySource(source)
]]
	require("MathTest") --> wtf?
end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)

	ObjectUpdater:Update()
	ObjectUpdater:RepeatedInput()

	if(love.keyboard.isDown("1")) then
		Sound.PlayStreamLoop("SuperMarioWorld.mp3")
	end

	Controller.Update()

end 


-- input
function love.keypressed(key)
	App:Input(key)
	ObjectUpdater:Input(key)
end


-- draw call
function love.draw()
	FrameCounter:Draw()
	ObjectUpdater:Draw()
end 




-- Notes
---------------------------------------


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