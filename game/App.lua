-- App.lua
-- do game application stuff
-- control the window, blah blah blah

local Input = require("Input")

local App = {}

---------------------------
-- Vars
------------------------
-- object
App.name = "App"
App.oType = "Static"
App.dataType = "Manager"

---------------------
-- Functions
---------------------

function App:QuitGameInput()
		love.event.quit()
end 


----------------------
-- Input
----------------------
App.Input = Input:New
{
	keys = 
	{ 
		{ "escape", "press", App.QuitGameInput}
	}
}




ObjectUpdater:AddStatic(App)

return App



-- Notes
---------------------------------------
-- gonna test the new input component on this
-- Cool, the new input system works


