-- PlayerSkins.lua

-- Purpose
--------------------
-- Skins for players
-- tables of all related art assets

-------------
-- Requires
-------------
local Sprites = require("Sprites")

----------------------------------------------------------

local PlayerSkins = {}

----------------
-- Static Info
----------------
PlayerSkins.Info = Info:New
{
	objectType = "PlayerSkins",
	dataType = "Data",
	structureType = "Static"
}


-- red
PlayerSkins.red = 
{
	idle = Sprites.dude.red.idle,
	bullet = Sprites.bullet.red,
	block = Sprites.block.red,
	color = red
}

-- blue
PlayerSkins.blue =
{
	idle = Sprites.dude.blue.idle,
	bullet = Sprites.bullet.blue,
	block = Sprites.block.blue,
	color = blue
}



return PlayerSkins