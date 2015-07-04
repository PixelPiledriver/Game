-- Graphics.lua


-- sets up window and other graphics stuff

--------------
-- Requires
--------------

local Color = require("Color")


--------------------------------------------------------------------------------

local Graphics = {}


----------------------
-- Static Functions
----------------------

function Graphics:Setup()
		-- graphics setup

	love.window.setFullscreen(false, "desktop")
	love.graphics.setBackgroundColor(Color:AsTable(Color:Get("gray")))

end 



function Graphics:Update()
end 


----------------
-- Static End
----------------

return Graphics



-- Notes 
------------------------------------------------------------------------------
-- this is just a temp file until 
-- I break the features down into other components



