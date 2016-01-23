-- DrawLineUI.lua

-- Purpose
--------------------------
-- sprites and objects for DrawLine user interface


---------------
-- Requires
---------------
local DrawLine = require("DrawLine")
local SpriteBank = require("SpriteBank")
local Button = require("Button")
local Panel = require("Panel")

-----------------------------------------
-- sub static
DrawLine.UI = {}


-------------
-- Panel
-------------

------------------
-- Sprites
------------------
DrawLine.SpriteBank = SpriteBank:New
{
	image = "DrawLineSprites.png",
	spriteWidth = 32,
	spriteHeight = 32
}

DrawLine.SpriteBank:Add
{
	{"line",1,1},
	{"movePoints",2,1},
	{"joinPoints",3,1},
	{"breakPoints",4,1},
	{"prevColor",1,2},
	{"nextColor",2,2}
}


---------------
-- Buttons
---------------
local NewToolsButton = function(toolName)
	return Button:New
	{
		sprite = DrawLine.SpriteBank:Get(toolName),
		toggle = true, 
		on = DrawLine.tools[toolName].On,
		off = DrawLine.tools[toolName].Off
	}
end 

DrawLine.UI.lineButton = NewToolsButton("line")
DrawLine.UI.movePointsButton = NewToolsButton("movePoints")
DrawLine.UI.joinPointsButton = NewToolsButton("joinPoints")

--[==[
DrawLine.UI.lineButton = Button:New
{
	sprite = DrawLine.SpriteBank:Get("line"),
	toggle = true, 
	on = DrawLine.tools.line.On,
	off = DrawLine.tools.line.Off
}

DrawLine.UI.moveButton = Button:New
{
	sprite = DrawLine.SpriteBank:Get("movePoints"),
	toggle = true,
	on = DrawLine.tools.move.On,
	off = DrawLine.tools.move.Off	
}

DrawLine.UI.joinPointsButton = Button:New
{
	sprite = DrawLine.SpriteBank:Get("joinPoints"),
	toggle = true,
	on = DrawLine.tools.joinPoints.On,
	off = DrawLine.tools.joinPoints.Off	
}
--]==]

DrawLine.panel:AddVertical
{
	DrawLine.UI.lineButton,
	DrawLine.UI.movePointsButton,
	DrawLine.UI.joinPointsButton
}


















--[[
DrawLine.UI.Sprites = {}


-- Sprite Sheet
DrawLine.UI.Sprites.sheet = SpriteSheet:New
{
	image = "DrawLineSprites.png",
	spriteWidth = 32,
	spriteHeight = 32	
}

-- Sprites
DrawLine.UI.Sprites.line = {1,1}



--]]



