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
	{"nextColor",2,2},
	{"paint",3,2}
}


---------------
-- Buttons
---------------
DrawLine.UI.buttons = {}

local NewToolsButton = function(toolName)
	
	DrawLine.UI.buttons[toolName] = Button:New
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
DrawLine.UI.breakPointsButton = NewToolsButton("breakPoints")
DrawLine.UI.paintButton = NewToolsButton("paint")

DrawLine.panel:AddVertical
{
	DrawLine.UI.buttons.line,
	DrawLine.UI.buttons.movePoints,
	DrawLine.UI.buttons.joinPoints,
	DrawLine.UI.buttons.breakPoints,
	DrawLine.UI.buttons.paint
}





-- Junk
--------------------------------------------------------
--[==[


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


-- old tools button maker

local NewToolsButton = function(toolName)
	
	return Button:New
	{
		sprite = DrawLine.SpriteBank:Get(toolName),
		toggle = true, 
		on = DrawLine.tools[toolName].On,
		off = DrawLine.tools[toolName].Off
	}
end 


--]==]



