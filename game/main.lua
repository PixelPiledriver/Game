
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires --> load and run shit in other files
require("DeltaTime")
require("PrintDebug")
local FrameCounter = require("FrameCounter")
local App = require("App")
local Box = require("Box")
local Player = require("Player")
local Sprites = require("Sprites")
local ObjectUpdater = require("ObjectUpdater")
local Camera = require("Camera")
local Sound = require("Sound")

--------------
-- Objects
--------------

-- will move object loader to own file soon :P
local pawn = Player:New
{
	x = 200,
	y = 300,
	
	frame = Sprites.pawn.damage,
	color = {255,255,255,255}
}

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

local box1 = Box:New
{
	x = 200,
	y = 200
}

ObjectUpdater:Add{pawn, pawn2, box1}
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

	if(love.keyboard.isDown("q")) then
		Sound.PlayStreamLoop("SuperMarioWorld.mp3")
	end

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


