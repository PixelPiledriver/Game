-- CollisionLists.lua
-->OLD

-- Purpose
----------------------------
-- pre mdade collision lists of objects to apply to bullets and stuff
-- instead of having to rebuild the tables each time a bullet is shot


---------------------------------------------------------------------

local CollisionLists = {}

CollisionLists.Info = Info:New
{	
	objectType = "CollisionLists",
	dataType = "List",
	structureType = "Static"
}

----------------
-- Static Vars
----------------
CollisionLists.redRobot =
{
	robot =
	{
		"blueBullet",
		"blueRobot",
		"redBlock"
	},

	bullet = 
	{
		"blueRobot",
		"blueBlock"
	},

	block =
	{
		"redRobot",
		"blueBullet"
	}

}

CollisionLists.blueRobot =
{
	robot =
	{
		"redBullet",
		"redRobot",
		"blueBlock"
	},

	bullet = 
	{
		["redRobot"] = "player",
		["redBlock"] = "block",

	},

	block =
	{
		["blueRobot"] = "player",
		["redBullet"] = "bullet"
	}

}

---------------
-- Static End
---------------

return CollisionLists




-- Notes
-------------------------------------------------------
-- this file most likely isnt needed anymore
-- will look into it



--------------------
--[[ Test Code
--------------------

CollisionLists.redRobot =
{
	robot =
	{
		["blueBullet"] = "bullet",
		["blueRobot"] = "player",
		["redBlock"] = "block",
	},

	bullet = 
	{
		["blueRobot"] = "player",
		["blueBlock"] = "block",
	},

	block =
	{
		["redRobot"] = "player",
		["blueBullet"] = "bullet",
		
	}

}




--]]