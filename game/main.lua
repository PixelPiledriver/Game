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
local Map = require("Map")
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
local Graphics = require("Graphics")

--Utility requires
require("DebugText")
require("DeltaTime")
require("Keyboard")
require("Math")

require("PrintDebug")
require("Random")

-- List of Levels
local TestLevel = require("levels/TestLevel")

--local SnapGridTestLevel = require("levels/SnapGridTestLevel")
local PixelDrawLevel = require("levels/PixelDrawLevel")
local SnapGridTestLevel = require("levels/SnapGridTestLevel")



--------------------------
-- Functions / Callbacks
--------------------------

-- runs once on startup
function love.load()

	-- yep
	Graphics:Setup()

	-- manual camera object
	ObjectUpdater:AddCamera(Camera)

	-- Load your level here

	PixelDrawLevel:Load() 
	--TestLevel:Load()

	--SnapGridTestLevel:Load() 

end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)

	ObjectUpdater:Update()
	ObjectUpdater:RepeatedInput()

	Controller.Update()
	CollisionManager:Update()

	--Map:Update()

	love.graphics.clear()

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


