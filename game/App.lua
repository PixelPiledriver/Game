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
App.objectType = "Static"
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

App.Input = Input:New
{
	keys = 
	{ 
		{ "escape", "press", App.QuitGameInput}
	}
}



---------------
-- Static End
---------------

ObjectUpdater:AddStatic(App)

return App



-- Notes
---------------------------------------------------------------------------
-- very light file at the moment
-- that's fine, it can be made more robust in the future