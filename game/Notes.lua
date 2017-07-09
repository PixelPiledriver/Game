-- Notes.lua

-- Purpose
------------------------------
-- this file is a place for any and all thoughts
-- features needed, ideas, etc
-- new stuff at the top, old at the bottom
 
--------------------------------------------------------------------------------


-- Micro Book
-------------------------
-- engine for sharing pixel animations and comics
-- pixel art does not share well as video or on the web sometimes 
--> solved, look at art ideas dog
--> but yes realtime pixel art is the most crips --> or html/java put together by hand
-- Micro Book is designed to let people view and possibly create pixel stories in editor
 



-- Sprite Bank
----------------------
-- add and get sprites

-- Button
--------------
-- prev <-  -> next
-- button type that comes with two buttons in 1 call

-- Panel
-----------------------
-- code Add functions for basic ui object types
-- text, button, box, color select, etc
-- make a way to pass in a var of the object to update
-- this way new panel handles all ui objects instead of the static
-- will clean up panel creation and make it faster? easier at least

-- DrawLine
------------------
-->NEED
-- color
-- keyframes
-- break apart points
-- scale points
-- rotate from A or B
-- fast click or hold click draw
-- line preview
-- draw cancel
-- select only 1 point --> keyboard choices

-->DONE
-- join points
-- move points
-- select area


-- simple vector drawing and editing tools

-- Thoughts on Game production
-------------------------------------------
-- http://wayofthepixel.net/index.php?action=profile;u=9280;area=showposts;start=720


-- Animation Editor
-------------------------------
-- look at this post
-- http://wayofthepixel.net/index.php?action=profile;u=9280;area=showposts;start=730

-- i want to be able to create animations like this easily in the editor
-- so be able to keyframe objects to move and rotate in space

-- also want vector animation to create skeletons to trace like that online pixel editor
-- i forget the name


-- Beefing up text write/read
-- going to add lua code features
-- this will be used to write and read animations
-- that are created at runtime
-- this is also an important feature for many other things
-- so make it nice :P

-- OnExit needed when game quits

-- Added Matrix.lua
-- has some decent matricie features and blah
-- still needs some work

-- So whats next?
---------------------------
-- LevelManager UI
-- Window overhaul
-- Sprite overhaul
-- Animation builder/editor
-- Super Sprite --> sprite with features that make it an actual game object
-- other?

-->WORKING
-- Camera overhaul --> object based, fix shake, fix rotation, nodes, etc

-->NAW
-- Ludum Dare maybe?



-- Load Level/Game
----------------------

-->FIX
-- when PixelDrawLevel is Exited and then Started again
-- the sprites don't show up
-- this might be because they are created by a raw require load run
-- and the next time require is called that code is not run --> require on additional runs only returns
-- that is the most likely case
-- or there is something weird with Sprite?
-- but it is most likely the behaviour of require causing that --> almost positive thats the problem
-- need to keep that in mind or it could creep in weird problems
-- if that is the case it means its not a code bug, just stupidly placed code
-- look into it

-->PROGRESS
-- Level loading is really old code and janky
-- needs to be updated very soon


-- Destroy Statics
---------------
-- need to be able to add and remove statics

-- Camera
--------------------
-- need to work on moving camera code soon




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




-- Fixed
-----------------------------------------------------
-->FIXED
-- Hold input type doesn't work for any objects
-- need to update it to work how camera works
-- call all Input:RepeatedInput of objects
-- its different than how a single key press works








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