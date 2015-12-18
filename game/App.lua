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
App.Info = Info:New
{
	objectType = "App",
	dataType = "Game",
	structureType = "Static"
}

-----------------------
-- Static Functions
-----------------------

-- close the program
function App:QuitGame()

	-- run any exit functions that need to be done
	ObjectManager:OnExit()
	EventLog:OnExit()

	-- close the game
	love.event.quit()
end 

----------------------
-- Input
----------------------

App.Input = Input:New
{
	keys = 
	{ 
		{ "escape", "press", App.QuitGame},
	}
}



function App:Destroy()
	ObjectManager:Destroy(self.Info)
	ObjectManager:Destroy(self.Input)

end 
---------------
-- Static End
---------------

ObjectManager:AddStatic(App)

return App



-- Notes
---------------------------------------------------------------------------
-- very light file at the moment
-- that's fine, it can be made more robust in the future



-- Junk
---------------------------
--[=[

		{ "z", "press", LevelManager.ExitLevel, LevelManager},
		{ "x", "press", LevelManager.StartDefaultLevel, LevelManager}



--]=]
