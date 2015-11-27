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
require("TestCode")


----------------------------
-- Vars
----------------------------
-- Level -- change how this works-->REFACTOR
--local PixelDrawLevel = require("levels/PixelDrawLevel")
local MapWorldLevel = require("levels.MapWorldLevel")


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

		-- Load your level here
		--PixelDrawLevel:Load()
		MapWorldLevel:Load()

	end 


	-- for each frame step
	function love.update(dt)
		deltaTime = dt
		FrameCounter:Update(dt)

		ObjectUpdater:Update()
		ObjectUpdater:RepeatedInput()
		Controller.Update()
		CollisionManager:Update()

		--PixelDrawLevel:Update()
		MapWorldLevel:Update()
		

		-- Post Update
		PostUpdate(dt)
		
		-- this should happen somewhere else
		-- Window.lua, Graphics.lua or something ->MOVE to Graphics.lua
		love.graphics.clear()

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


