-- App.lua
-- do game application stuff
-- control the window, blah blah blah

local ObjectUpdater = require("ObjectUpdater")

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