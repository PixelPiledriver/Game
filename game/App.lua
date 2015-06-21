-- App.lua


-- Purpose
----------------------------
-- Handles game application tasks

------------------
-- Requires
------------------
local Input = require("Input")


---------------------------------------------------------------------------

local App = {}


------------------
-- Static Info
------------------
App.name = "App"
App.oType = "Static"
App.dataType = "Manager"

-----------------------
-- Static Functions
-----------------------

-- close the program
function App:QuitGameInput()
		love.event.quit()
end 

----------------------
-- Input
----------------------

-- Exit the game with ESC
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
---------------------------------------------------------------------------
-- very light file at the moment
-- that's fine, it can be made more robust in the future