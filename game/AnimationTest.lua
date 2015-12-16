-- AnimationTest.lua


-- Purpose
----------------------------
-- file for building test animations


------------------
-- Requires
------------------
local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local Animation = require("Animation")

---------------------------------------------------------------------------

---------------
-- Test Code
---------------

-- Pawn character

local pawnGraphics = {}

-- create SpriteSheet
pawnGraphics.pawnSheet = SpriteSheet:New
{
	image = "pawnSheet.png",
	spriteWidth = 64,
	spriteHeight = 64
}

-- create Sprites --> from SpriteSheet
pawnGraphics.sprites = {}

pawnGraphics.sprites.idle = Sprite:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	xIndex = 1,
	yIndex = 1,
	draw = false
}

pawnGraphics.sprites.walk = Sprite:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	xIndex = 2,
	yIndex = 1,
	draw = false
}

pawnGraphics.sprites.attack = Sprite:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	xIndex = 1,
	yIndex = 2,
	draw = false
}


-- create Animations --> from Sprites
pawnGraphics.animations = {}

pawnGraphics.animations.walk = Animation:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	frames = 
	{
		pawnGraphics.sprites.idle, 
		pawnGraphics.sprites.walk,
		pawnGraphics.sprites.idle, 
		pawnGraphics.sprites.walk
	},
	
	delays =
	{
		--10, 10, 10, 10,
		20, 20, 20, 20,
	},

	colors =
	{
		--"mistyRose", "olive", "thistle", "plum"
		"blue", "red", "green", "yellow"
	}
}


-- place animated sprite in world
pawnGraphics.animations.walk.Pos.x = 100
pawnGraphics.animations.walk.Pos.y = 150


return pawnGraphics




-- Notes
---------------------------------------------------------------------------
-- this file just builds an animated character sprite from test graphics
-- the animation is forced into the game world, along with all the sprites -->REFACTOR
-- Animation and Sprite need to be fixed so that they don't do that
-- this shouldn't happen and should be in reserve for later use, uncreated
-- but this is just a test file, will be removed from the project at some point
