-- Notes.lua

-- track shit that needs to be coded in the future
-- gonna put new shit at the top and push old shit down



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