-- DrawToolsUI.lua

-- Purpose
----------------------------
-- sprites and buttons for DrawTools
-- require this file in the scene you are using
-- and it will create the assets, buttons and stuff and put them on screen

------------------
-- Requires
------------------
local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local Button = require("Button")
local DrawTools = require("DrawTools")
local Panel = require("SimplePanel")

-----------------------------------------------------------------------------------

local DrawToolsUI = {}


DrawToolsUI.Info = Info:New
{
	objectType = "DrawToolsUI",
	dataType = "Tools",
	structureType = "Manager" -- not sure this is the appropriate stuctureType name
}

DrawToolsUI.iconSheet = SpriteSheet:New
{
	image = "EditorIcons.png",
}

DrawToolsUI.drawIcon = Sprite:New
{
	spriteSheet = DrawToolsUI.iconSheet,
	xIndex = 1,
	yIndex = 1
}

DrawToolsUI.moveIcon = Sprite:New
{
	spriteSheet = DrawToolsUI.iconSheet,
	xIndex = 2,
	yIndex = 1
}

DrawToolsUI.zoomIcon = Sprite:New
{
	spriteSheet = DrawToolsUI.iconSheet,
	xIndex = 3,
	yIndex = 1
}

DrawToolsUI.colorDropIcon = Sprite:New
{
	spriteSheet = DrawToolsUI.iconSheet,
	xIndex = 4,
	yIndex = 1
}

DrawToolsUI.selectIcon = Sprite:New
{
	spriteSheet = DrawToolsUI.iconSheet,
	xIndex = 6,
	yIndex = 1
}


DrawToolsUI.drawButton = Button:New
{
	x = 400,
	y = 100,
	text = "toggle!",
	toggle = true,
	sprite = DrawToolsUI.drawIcon,
	printDebugTextActive = true,
	toggleOnFunc = function() 
		DrawTools:ToggleTool("Draw")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("Draw")
	end 
}

DrawToolsUI.moveButton = Button:New
{
	x = 432,
	y = 100,
	text = "toggle!",
	buttonName = "Move",
	toggle = true,
	sprite = DrawToolsUI.moveIcon,
	--printDebugTextActive = true
	toggleOnFunc = function()
		DrawTools:ToggleTool("Move")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("Move")
	end 
}

DrawToolsUI.zoomButton = Button:New
{
	x = 464,
	y = 100,
	text = "toggle!",
	toggle = true,
	sprite = DrawToolsUI.zoomIcon,
	toggleOnFunc = function()
		DrawTools:ToggleTool("Zoom")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("Zoom")
	end
}

DrawToolsUI.colorDropButton = Button:New
{
	x = 496,
	y = 100,
	text = "toggle!",
	toggle = true,
	sprite = DrawToolsUI.colorDropIcon,
	--printDebugTextActive = true
	toggleOnFunc = function()
		DrawTools:ToggleTool("ColorDrop")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("ColorDrop")
	end 
}

DrawToolsUI.selectButton = Button:New
{
	x = 528,
	y = 100,
	text = "toggle!",
	toggle = true,
	saveAsLast = false,
	sprite = DrawToolsUI.selectIcon,
	printDebugTextActive = true,
}

-------------
-- Panel
-------------

-- create
DrawToolsUI.panel = Panel:New
{
	name = "DrawTools",
	posType = "bottom",
	gridSize = 32	
}

-- add objects
DrawToolsUI.panel:AddHorizontal
{
	DrawToolsUI.drawButton, 
	DrawToolsUI.moveButton,
	DrawToolsUI.zoomButton,
	DrawToolsUI.
}

--[[
DrawToolsUI.panel:Add
{
	object = DrawToolsUI.moveButton,
	x = 2,
	y = 1
}


DrawToolsUI.panel:Add
{
	object = DrawToolsUI.zoomButton,
	x = 3,
	y = 1
}

DrawToolsUI.panel:Add
{
	object = DrawToolsUI.colorDropButton,
	x = 4,
	y = 1
}

DrawToolsUI.panel:Add
{
	object = DrawToolsUI.selectButton,
	x = 5,
	y = 1
}
--]]
---------------
-- Static End
---------------

return DrawToolsUI



-- Notes
---------------------------------------
-- this file is like a collecetion of objects
-- that get created when required -> require("DrawToolsUI")
