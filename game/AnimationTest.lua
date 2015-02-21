-- AnimationTest.lua

local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local Animation = require("Animation")


local pawnGraphics = {}

pawnGraphics.pawnSheet = SpriteSheet:New
{
	image = "pawnSheet.png",
	spriteWidth = 64,
	spriteHeight = 64
}


pawnGraphics.sprites = {}


pawnGraphics.sprites.idle = Sprite:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	xIndex = 1,
	yIndex = 1
}


pawnGraphics.sprites.walk = Sprite:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	xIndex = 2,
	yIndex = 1,
}

pawnGraphics.sprites.attack = Sprite:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	xIndex = 1,
	yIndex = 2,
}

pawnGraphics.animations = {}

pawnGraphics.animations.walk = Animation:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	frames = 
	{
		pawnGraphics.sprites.idle, 
		pawnGraphics.sprites.walk
	},
	
	delays =
	{
		10, 10
	}
}

pawnGraphics.animations.walk.Pos.x = 100
pawnGraphics.animations.walk.Pos.y = 150


return pawnGraphics




