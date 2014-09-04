-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!

-- i fucked wit yo mainz - adam
-- (•_•)
-- ( •_•)>⌐■-■
-- (⌐■_■)
-- DEAL WITH IT

-- Requires --> load and run shit in other files


-- Only requires that are globally necessary should be listed here
local App = require("App")
local Camera = require("Camera")
local Controller = require("Controller")
local Color = require("Color")
local Collision = require("Collision")
local CollisionManager = require("CollisionManager")
local CollisionLists = require("CollisionLists")
local FrameCounter = require("FrameCounter")
local ObjectUpdater = require("ObjectUpdater")
local Sound = require("Sound")
local Window = require("Window")

--Utility requires
require("DebugText")
require("DeltaTime")
require("Keyboard")
require("Math")
require("PixelTexture")
require("PrintDebug")
require("Random")

-- List of Levels
local TestLevel = require("levels/TestLevel")
local SnapGridTestLevel = require("levels/SnapGridTestLevel")
--------------------------
-- Functions / Callbacks
--------------------------

-- runs once on startup
function love.load()
	-- graphics setup
	love.window.setFullscreen(false, "desktop")
	love.graphics.setBackgroundColor(100,100,100)
	-- manual camera object
	ObjectUpdater:AddCamera(Camera)
	-- Load your level here
	SnapGridTestLevel:Load() 
end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)

	ObjectUpdater:Update()
	ObjectUpdater:RepeatedInput()

	Controller.Update()
	CollisionManager:Update()
end 


-- input
function love.keypressed(key)
	App:Input(key)
	ObjectUpdater:Input(key)
end


-- draw call
function love.draw()
	FrameCounter:Draw()
	DebugText:Draw()
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