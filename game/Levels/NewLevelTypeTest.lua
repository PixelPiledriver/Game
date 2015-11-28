-- NewLevelTypeTest.lua

-- Description
-------------------------------------------
-- testing Level and LevelManager

---------------
-- Requires
---------------
local Box = require("Box")

------------------------------------------------------

--------------------
-- Level Functions
--------------------

-- define a function for each action a level can take


local Start = function()
	local box = Box:New
	{
		x = 300,
		y = 300
	}

	
end


local Update = function()

end 


local Exit = function()

end 


local Restart = function()

end 

-- create level object 
-- add all functions needed to run
local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart
}

return level


