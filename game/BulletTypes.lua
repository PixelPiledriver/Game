-- Bullet types
-- different kinds of bullets with stats and stuff


local Sprites = require("Sprites")

local BulletTypes = {}


BulletTypes.laser = 
{
	damage = 1,
	speed = 10,
	lifespan = 30,

	frames = 
	{
		red = Sprites.bullet.red,
		blue = Sprites.bullet.blue
	}

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






return BulletTypes