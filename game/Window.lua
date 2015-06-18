-- Window.lua

-- Purpose
----------------------------
-- Handles the window the game is diplayed within

----------------
-- Requires
----------------
local Random = require("Random")



local Window = {}


------------------
-- Static Info
------------------
Window.name = "..."
Window.oType = "Window"
Window.dataType = "App Static"



----------------
-- Title
----------------
-- fun additional text to add to the window title
-- a random title is chosen each time you run the game
Window.titleFlavor = 
{
	"[*___*]",
	"[x___x]",
	"[o___o]",
	"[+___-]",
	"[-___*]",
	":D",
	":)",
	":O",
	":|",
	"aw yeaw",
	"pow pow pachow",
	"oh yes",
	"shabba",
	"yep",
	"do a barrel roll!",
}

Window.title = "PixelRobot: " .. Random:ChooseRandomlyFrom(Window.titleFlavor)

love.window.setTitle(Window.title)


--------------------
-- Size
--------------------
-- sets window to full screen of current monitor
-- love.window.setMode(0,0,{display = 1})


------------------------
-- Functions
------------------------

function Window:PrintDebugText()
	DebugText:TextTable
	{
		{text = "", obj = "Window"},
		{text = "Window"},
		{text = "-----------"},
		{text = "Width: " .. love.window.getWidth()},
		{text = "Height: " .. love.window.getHeight()},
	}
end


ObjectUpdater:Add{Window}

return Window