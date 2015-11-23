-- MapObject_Sprites.lua


local MapObject = require("MapObject")
local Sprite = require("Sprite")
local SpriteSheet = require("SpriteSheet")
-----------------------------------------------
-- sub component

MapObject.Sprites = {}

function MapObject.Sprites:Get(name)

	Sprite.defaultSpriteSheet = MapObject.Sprites.sheet

	return Sprite:New(MapObject.Sprites[name])
end 

-- create SpriteSheet
MapObject.Sprites.sheet = SpriteSheet:New
{
	image = "MapSprites.png",
	spriteWidth = 32,
	spriteHeight = 32
}




MapObject.Sprites.human =
{
	xIndex = 1,
	yIndex = 1,
}

MapObject.Sprites.orc =
{
	xIndex = 2,
	yIndex = 1,
}

MapObject.Sprites.tree =
{
	xIndex = 3,
	yIndex = 1
}

MapObject.Sprites.rock =
{
	xIndex = 4,
	yIndex = 1
}

MapObject.Sprites.pond =
{
	xIndex = 5,
	yIndex = 1
}



