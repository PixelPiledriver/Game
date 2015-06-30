-- BulletTypes.lua
-->OLD


-- Purpose
----------------------------
-- different kinds of bullets that player can fire
-- each bullet has its own stats and vars


------------------
-- Requires
------------------
local Sprites = require("Sprites")



---------------------------------------------------------------------------

local BulletTypes = {}

BulletTypes = Info:New
{
	objectType = "BulletTypes",
	dataType = "Game"
	structureType = "List"
}


BulletTypes.laser = 
{
	damage = 2,
	speed = 10,
	lifespan = 30,

	frames = 
	{
		red = Sprites.bullet.red,
		blue = Sprites.bullet.blue
	}

}

BulletTypes.bolt =
{
	damage = 15,
	speed = 40,
	lifespan = 80
}

BulletTypes.blaster =
{
	damage = 5,
	speed = 3,
	lifespan = 100,

	frames = 
	{
		red = Sprites.bullet.red,
		blue = Sprites.bullet.blue
	}
}

BulletTypes.missle =
{
	damage = 25,
	speed = 8,
	lifespan = -1,

	frames = 
	{
		red = Sprites.bullet.red,
		blue = Sprites.bullet.blue
	}
}

BulletTypes.rocket = 
{
	damage = 50,
	speed = 6,
	lifespan = -1,

	frames = 
	{
		red = Sprites.bullet.red,
		blue = Sprites.bullet.blue
	}
}

BulletTypes.mine =
{
	damage = 100,
	speed = 0,
	lifespan = -1,

	frames = 
	{
		red = Sprites.bullet.red,
		blue = Sprites.bullet.blue
	}
}



---------------
-- Static End
---------------

return BulletTypes


-- Notes
---------------------------------------
-- this file is just tables of data waiting to be sent to Bullet.lua
-- might still be useful
