-- CollisionLists
-- pre mdade collision lists of objects to apply to bullets and stuff
-- instead of having to rebuild the tables each time a bullet is shot


local CollisionLists = {}


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

CollisionLists.blueRobot =
{
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

return CollisionLists