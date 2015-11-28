-- Graphics.lua


-- sets up window and other graphics stuff

--------------
-- Requires
--------------

local Color = require("Color")


--------------------------------------------------------------------------------

local Graphics = {}

-------------------
-- Static Info
-------------------
Graphics.Info = Info:New
{
  objectType = "Graphics",
  dataType = "Graphics",
  structureType = "Manager"
}


----------------------
-- Static Functions
----------------------

-- initialize graphics settings on startup
-- called only once from main
function Graphics:Setup()
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

-- will need to give more flexible control to cpu and player
-- access to the graphics options

-- on startup cpu should seek the best settings by default
-- and player should be able to change some of them


