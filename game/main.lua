-- main.lua

-- Purpose
--------------------------------------
-- entry point of the program
-- every thing starts here
-- contains all Callbacks for looping

---------------------------
-- Utilities and Globals
---------------------------
require("MemoryManager")
require("LevelManager")
require("ObjectUpdater")
require("Info")
require("CollisionManager")
require("DrawList")
require("DrawManager")
require("DebugText")
require("DeltaTime")
require("Keyboard")
require("Math")
require("TableSort")
require("PrintDebug")
require("Random")
require("FailNew")
require("Bool")
require("Mouse")
require("Game")
require("EventLog")
require("Level")

-- Post Utilities
----------------------
LevelManager:PostRequire()


---------------------------------
-- Create Important Data Types 
---------------------------------
local App = require("App")
local Map = require("Map")
local Camera = require("Camera")
local Controller = require("Controller")
local Color = require("Color")
local Collision = require("Collision")
local CollisionLists = require("CollisionLists")
local FrameCounter = require("FrameCounter")
local Sound = require("Sound")
local Window = require("Window")
local Graphics = require("Graphics")
local Shader = require("Shader")
local Draw = require("Draw")
local Canvas = require("Canvas")
local DrawTools = require("DrawTools")
local Panel = require("Panel")
local Polygon = require("Polygon")
local Text = require("Text")

----------------------
-- Run Test Code
----------------------
-- this is pretty much useless now
-->REMOVE
require("TestCode") 


----------------------------
-- Vars
----------------------------



----------------
-- Callbacks
----------------

	------------
	-- Run
	------------

	-- runs once on startup
	function love.load()

		-- Graphics 
		Graphics:Setup()
		love.graphics.setShader(Shader.britShader) -->MOVE

		-- manual camera object -->REFACTOR
		ObjectUpdater:AddCamera(Camera)

		LevelManager:Setup()


	end 


	-- for each frame step
	function love.update(dt)

		-- time and frame rate -->CHANGE
		deltaTime = dt
		FrameCounter:Update(dt)

		-- objects
		ObjectUpdater:Update()

		-- Input
		ObjectUpdater:RepeatedInput()
		Controller.Update()

		-- collision
		CollisionManager:Update()

		-- Level/Scene
		LevelManager:UpdateLevel()
		
		-- things to do after
		PostUpdate(dt)
		
	end 

	-- after all objects have updated
	-- a special list of objects that depend 
	-- on calculations made in Update are updated
	function PostUpdate(dt)
		ObjectUpdater:PostUpdate()
		DrawList:PostUpdate()
	end 

	-----------
	-- Input 
	-----------

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

	---------------
	-- Graphics
	---------------

	-- render graphics
	function love.draw()
		DrawManager:Draw()
		DrawManager:PostDraw()
	end




-- Notes
---------------------------------------
-->FIX fps counter




-- Junk
-------------------------------------------------

-- old level style stuff



-- Level 
-- change how this works
-->REFACTOR
--local PixelDrawLevel = require("levels/PixelDrawLevel")
--local MapWorldLevel = require("levels/MapWorldLevel")


		-- Load your level here
		--PixelDrawLevel:Load()
		--MapWorldLevel:Load()


--PixelDrawLevel:Update()
--MapWorldLevel:Update()






