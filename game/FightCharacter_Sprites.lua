-- FightCharacter_Sprites.lua


--------------
-- Requires
--------------
local SpriteBank = require("SpriteBank")
local FightCharacter = require("FightCharacter")


FightCharacter.Sprites = {}


---------------
-- Blue
---------------

FightCharacter.Sprites.blue = SpriteBank:New
{
	image = "fighters.png",
	spriteWidth = 64,
	spriteHeight = 64,
}


FightCharacter.Sprites.blue:Add
{
	{"idle",1,1},
	{"punch",1,2},
	{"fireball",1,3},
	{"fireball2",1,4},
	{"spinKick", 3,2},
	{"spinKick2",3,3},
}

FightCharacter.Sprites.blue:AddAnimation
{
	name = "idle",
	frames =
	{
		"idle",
	},
}

FightCharacter.Sprites.blue:AddAnimation
{
	name = "punch",
	frames =
	{
		"punch",
		"punch"
	},
	loopMax = 1,
	whenDonePlay = "idle"
}

FightCharacter.Sprites.blue:AddAnimation
{
	name = "fireball",
	frames =
	{
		"fireball",
		"fireball2"
	},
	loopMax = 3,
	whenDonePlay = "idle"
}

FightCharacter.Sprites.blue:AddAnimation
{
	name = "spinKick",
	frames =
	{
		"spinKick",
		"spinKick2"
	},
	loopMax = 3
}




---------------
-- Red
---------------

FightCharacter.Sprites.red = SpriteBank:New
{
	image = "fighters.png",
	spriteWidth = 64,
	spriteHeight = 64,
}


FightCharacter.Sprites.red:Add
{
	{"idle",2,1},
	{"punch",2,2},
	{"fireball",2,3},
	{"fireball2",2,4},
	{"spinKick", 4,2},
	{"spinKick2",4,3},
}

FightCharacter.Sprites.red:AddAnimation
{
	name = "idle",
	frames =
	{
		"idle",
	},
}

FightCharacter.Sprites.red:AddAnimation
{
	name = "punch",
	frames =
	{
		"punch",
		"punch"
	},
	loopMax = 1,
	whenDonePlay = "idle"
}

FightCharacter.Sprites.red:AddAnimation
{
	name = "fireball",
	frames =
	{
		"fireball",
		"fireball2"
	},
	loopMax = 3,
	whenDonePlay = "idle"
}


FightCharacter.Sprites.red:AddAnimation
{
	name = "spinKick",
	frames =
	{
		"spinKick",
		"spinKick2"
	},
	loopMax = 3,
	whenDonePlay = "idle"
}


--[[
FightCharacter.SpriteBank = SpriteBank:New
{
	image = "fighters.png",
	spriteWidth = 64,
	spriteHeight = 64,
}

FightCharacter.SpriteBank:Add
{
	{"blueIdle",1,1},
	{"bluePunch",1,2},
	{"redIdle",2,1},
	{"redPunch",2,2}
}

FightCharacter.SpriteBank:AddAnimation
{
	name = "idle",
	frames =
	{
		"blueIdle",
	},
}

FightCharacter.SpriteBank:AddAnimation
{
	name = "punch",
	frames =
	{
		"bluePunch",
		"redPunch",
	},
	loopMax = 1,
	whenDonePlay = "idle"
}













--]]