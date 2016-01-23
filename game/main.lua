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
require("ObjectManager")
require("Info")
require("FileManager")
require("Random")
require("CollisionManager")
require("Window")
require("DrawList")
require("DrawManager")
require("DebugText")
require("DeltaTime")
require("Keyboard")
require("Vertex")
require("Math")
require("Matrix")
require("TableSort")
require("PrintDebug")
require("FailNew")
require("Bool")
require("Game")
require("EventLog")
require("Level")
require("Link")

local Camera = require("Camera")
require("Camera_Node")
require("Mouse")


--------------------
-- Post Utilities
--------------------
LevelManager:PostRequire()


---------------------------------
-- Create Important Data Types 
---------------------------------

local App = require("App")
local Map = require("Map")
local Controller = require("Controller")
local Color = require("Color")
local Collision = require("Collision")
local CollisionLists = require("CollisionLists")
local FrameCounter = require("FrameCounter")
--local Sound = require("Sound")

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

		LevelManager:Setup()

		ObjectManager:DestroyAllObjectsOwnedBy("shit")


	end 


	-- for each frame step
	function love.update(dt)

		-- time and frame rate -->CHANGE
		deltaTime = dt
		FrameCounter:Update(dt)

		-- Camera
		-- reworking to update on its own
		Camera:Update()

		-- draw components
		DrawList:Update()

		-- objects
		ObjectManager:Update()
		
		-- input
		Camera:RepeatedInput()
		ObjectManager:RepeatedInput()
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
		ObjectManager:PostUpdate()
		DrawList:PostUpdate()
	end 

	-----------
	-- Input 
	-----------

	function love.keypressed(key)
		Camera:InputUpdate(key, "press")
		ObjectManager:InputUpdate(key, "press")
	end

	function love.keyreleased(key)
		Camera:InputUpdate(key, "release")
		ObjectManager:InputUpdate(key, "release")
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






