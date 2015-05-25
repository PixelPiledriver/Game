-- App.lua
-- do game application stuff
-- control the window, blah blah blah

local ObjectUpdater = require("ObjectUpdater")
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
--------------------
-- gonna test the new input component on this shit
-- Cool, the new input system works

-- original file


--[[
-- App.lua
-- do game application stuff
-- control the window, blah blah blah

local ObjectUpdater = require("ObjectUpdater")
local Input = require("Input")

local App = {}

---------------------------
-- Vars
------------------------
-- object
App.name = "App"
App.oType = "Static"
App.dataType = "Manager"

----------------------
-- Components
----------------------
App.Input = Input:New()
App.


---------------------
-- Functions
---------------------

function App:QuitGameInput(key)
	-- exit game
	if(key == "escape") then
		love.event.quit()
	end 

end 

function App:Input(key)
	self:QuitGameInput(key)
end 


ObjectUpdater:AddStatic(App)

return App


-- Notes
--------------------
--gonna test the new input component on this shit

--]]