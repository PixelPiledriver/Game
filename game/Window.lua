-- Window
-- tracks shit about the window and stuff


local ObjectUpdater = require("ObjectUpdater")



local Window = {}


Window.name = "GameWindow"
Window.objType = "Window"



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