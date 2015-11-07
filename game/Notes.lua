-- Notes.lua



-- track stuff that needs to be coded in the future
-- gonna put new stuff at the top and push old stuff down



-- Event Log
---------------------
-- Global component that records things that happen
-- works like a console in other games
-- log can be saved to a file
-- not all objects need to be supported, but it would be useful
-- for many different situations




-- Test Automation
---------------------------------------
-- need to write a test component to interact with current object types
-- use input and check for correct output
-- test files are submitted to the TestAutomation component
-- these tests need to each be run and print out pass of fail results

-- simple example 
	-- create 100 of each type of object
	-- delete all 
	-- # of objects in updater should be 0
	-- return pass or fail

-- then keep adding more tests and periodically run them all

-- this can go on the back burner for now







-- NEED
-------------

-- Object creator factory

-- Input list 
-- only check objects with input component during input call back 
-- like draw list


-- Other
----------------



-- DONE
-- do we need a Link type?
-- an object that allows another to stay updated with an objects values?
-- perhaps prototype that and see if its helpful in some way



-- Window
-------------------
-- change size
-- change to full screen
-- at run time


-- Color Selector
-----------------------
-- pick colors in various ways
-- rgb, hsl, etc
-- sliders, numbers, and color box


-- Palettes
-----------------------

-- DONE
-- make drawable
-- clickable --> change color
-- cuz Preece said so

-- Add new functions for generating palette
-- contrast control
-- Bilinear --> etc

-- Buttons
------------------------
-- Add bool buttons --> check boxes, for options --> done :D


-- Components
-------------------------
-- adding a component could be a function, just pass the data and parent tables
-- this has been somewhat taken care of with the default component tables





-- Pixel Robot
-------------------------------------
-- Random pixel generator
-- characters
-- Educational and useful
-- Composition theory
-- Creates a daily image that you get to rate and tweak




-- old junk code goes here

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