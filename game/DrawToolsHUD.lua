-- DrawToolsHUD.lua

-- sprites and buttons for DrawTools
-- require this file in the scene you are using
-- and it will create all of the buttons and stuff :D


local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local Button = require("Button")
local DrawTools = require("DrawTools")



local DrawToolsHUD = {}
-- DrawTools hud stuff
-- need to move to a new file soon
DrawToolsHUD.iconSheet = SpriteSheet:New
{
	image = "EditorIcons.png",
}

DrawToolsHUD.drawIcon = Sprite:New
{
	spriteSheet = DrawToolsHUD.iconSheet,
	xIndex = 1,
	yIndex = 1
}

DrawToolsHUD.moveIcon = Sprite:New
{
	spriteSheet = DrawToolsHUD.iconSheet,
	xIndex = 2,
	yIndex = 1
}

DrawToolsHUD.zoomIcon = Sprite:New
{
	spriteSheet = DrawToolsHUD.iconSheet,
	xIndex = 3,
	yIndex = 1
}

DrawToolsHUD.colorDropIcon = Sprite:New
{
	spriteSheet = DrawToolsHUD.iconSheet,
	xIndex = 4,
	yIndex = 1
}

DrawToolsHUD.selectIcon = Sprite:New
{
	spriteSheet = DrawToolsHUD.iconSheet,
	xIndex = 6,
	yIndex = 1
}


DrawToolsHUD.drawButton = Button:New
{
	x = 400,
	y = 100,
	text = "toggle!",
	toggle = true,
	sprite = DrawToolsHUD.drawIcon,
	printDebugTextActive = true,
	toggleOnFunc = function() 
		DrawTools:ToggleTool("Draw")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("Draw")
	end 
}

DrawToolsHUD.moveButton = Button:New
{
	x = 432,
	y = 100,
	text = "toggle!",
	buttonName = "Move",
	toggle = true,
	sprite = DrawToolsHUD.moveIcon,
	--printDebugTextActive = true
	toggleOnFunc = function()
		DrawTools:ToggleTool("Move")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("Move")
	end 
}

DrawToolsHUD.zoomButton = Button:New
{
	x = 464,
	y = 100,
	text = "toggle!",
	toggle = true,
	sprite = DrawToolsHUD.zoomIcon,
	toggleOnFunc = function()
		DrawTools:ToggleTool("Zoom")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("Zoom")
	end
}

DrawToolsHUD.colorDropButton = Button:New
{
	x = 496,
	y = 100,
	text = "toggle!",
	toggle = true,
	sprite = DrawToolsHUD.colorDropIcon,
	--printDebugTextActive = true
	toggleOnFunc = function()
		DrawTools:ToggleTool("ColorDrop")
	end,
	toggleOffFunc = function()
		DrawTools:ToggleTool("ColorDrop")
	end 
}

DrawToolsHUD.selectButton = Button:New
{
	x = 528,
	y = 100,
	text = "toggle!",
	toggle = true,
	saveAsLast = false,
	sprite = DrawToolsHUD.selectIcon,
	printDebugTextActive = true,
}


return DrawToolsHUD