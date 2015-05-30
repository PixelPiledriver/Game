-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!

-- i fucked wit yo mainz - adam
-- (•_•)
-- ( •_•)>⌐■-■
-- (⌐■_■)
-- DEAL WITH IT

-- Requires --> load and run shit in other files

--Utility requires
require("ObjectUpdater")
require("DrawList")
require("DebugText")
require("DeltaTime")
require("Keyboard")
require("Math")
require("TableSort")
require("PrintDebug")
require("Random")
require("FailNew")
require("Bool")

local Mouse = require("Mouse")

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
local Sound = require("Sound")
local Window = require("Window")
local Graphics = require("Graphics")
local Shader = require("Shader")
local Draw = require("Draw")
local DrawTools = require("DrawTools")
local Panel = require("Panel")



-- other require stuff
require("TestShit")


-- List of Levels
--local TestLevel = require("levels/TestLevel")

--local SnapGridTestLevel = require("levels/SnapGridTestLevel")
local PixelDrawLevel = require("levels/PixelDrawLevel")
--local LerpLevel = require("levels/LerpLevel")
--local BoxTestLevel = require("levels/BoxTestLevel")
--local SnapGridTestLevel = require("levels/SnapGridTestLevel")
--local TextWriteLevel = require("levels/TextWriteLevel")
--local BoxLevel = require("levels/BoxLevel")



--------------------------
-- Functions / Callbacks
--------------------------

-- runs once on startup
function love.load()

	-- yep
	Graphics:Setup()
	love.graphics.setShader(Shader.britShader)

	-- manual camera object
	ObjectUpdater:AddCamera(Camera)

	-- Load your level here

	--TestLevel:Load()
	PixelDrawLevel:Load()
	--LerpLevel:Load()
	--BoxTestLevel:Load()
	--TextWriteLevel:Load()
	--BoxLevel:Load()

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

	--LerpLevel:Update()
	PixelDrawLevel:Update()
	--BoxLevel:Update()

	--Map:Update()

	love.graphics.clear()

end 


-- input
function love.keypressed(key)
	ObjectUpdater:InputUpdate(key, "press")
end

function love.keyreleased(key)
	ObjectUpdater:InputUpdate(key, "release")
end

-- call back for mouse wheel
function love.mousepressed(x, y, button)
	Mouse:MousePressed(x,y,button)
end

-- draw call
function love.draw()
	FrameCounter:Draw()
	DebugText:Draw()
	ObjectUpdater:Draw()
end 


