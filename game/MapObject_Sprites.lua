-- MapObject_Sprites.lua


local MapObject = require("MapObject")
local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local Animation = require("Animation")
-----------------------------------------------
-- sub component

MapObject.Sprites = {}

----------------------
-- Sprite Functions
----------------------

-- custom get function specific to this file
function MapObject.Sprites:Get(name)

	Sprite.default.SpriteSheet = MapObject.Sprites.sheet
	Sprite.default.draw = true

	local newSprite = Sprite:Simple(MapObject.Sprites[name])

	Sprite.default.draw = false

	return newSprite
end 

--------------------
-- SpriteSheet
--------------------

MapObject.Sprites.sheet = SpriteSheet:New
{
	image = "MapSprites.png",
	spriteWidth = 32,
	spriteHeight = 32
}

----------------
-- Sprites
----------------
MapObject.Sprites.human = {1,1}
MapObject.Sprites.orc = {2,1}
MapObject.Sprites.tree = {3,1}
MapObject.Sprites.rock = {4,1}
MapObject.Sprites.pond = {5,1}


-------------------
-- Animations
-------------------
Sprite.defaultSpriteSheet = MapObject.Sprites.sheet
MapObject.Animations = {}

MapObject.Sprites.humanWalk1 = {1,2}
MapObject.Sprites.humanWalk2 = {1,3}

MapObject.Animations.humanWalk =
{
	frames = 
	{
		"humanWalk1",
		"humanWalk2"
	},

	loopMax = 1,
	whenDonePlay = "idle"
}

MapObject.Sprites.humanChat1 = {1,4}
MapObject.Sprites.humanChat2 = {1,5}
MapObject.Animations.humanChat =
{
	frames =
	{
		"humanChat1",
		"humanChat2"
	},

	loopMax = 3,
	whenDonePlay = "idle"
}

MapObject.Sprites.humanPush1 = {1,6}
MapObject.Sprites.humanPush2 = {1,7}
MapObject.Animations.humanPush =
{
	frames =
	{
		"humanPush1",
		"humanPush2"
	},

	loopMax = 1,
	whenDonePlay = "idle"
}


MapObject.Sprites.humanIdle1 = {1,1}
MapObject.Sprites.humanIdle2 = {1,8}
MapObject.Animations.humanIdle =
{
	frames =
	{
		"humanIdle1",
		"humanIdle2"
	}
}


MapObject.Sprites.tree1 = {3,2}
MapObject.Sprites.tree2 = {3,3}
MapObject.Sprites.tree3 = {3,4}

MapObject.Animations.tree =
{
	frames =
	{
		"tree1", 
		"tree2", 
		"tree3"
	}
}


MapObject.Sprites.orc1 = {2,2}
MapObject.Sprites.orc2 = {2,3}

MapObject.Animations.orc =
{
	frames = 
	{
		"orc1", 
		"orc2"
	}
}

------------------------
-- Animation Functions
------------------------
-- custom get function specific to this file
function MapObject.Animations:Get(name)

	local frames = {}

	for i=1, #MapObject.Animations[name].frames do
		frames[#frames+1] = MapObject.Sprites:Get(MapObject.Animations[name].frames[i])
	end 

	local newAnimation =
	{
		frames = frames,
		spriteSheet = MapObject.Sprites.sheet, 
		loopMax = MapObject.Animations[name].loopMax or nil,
		whenDonePlay = MapObject.Animations[name].whenDonePlay or nil
	}

	return Animation:New(newAnimation)

end 




-- Notes
-------------------
-- the custom file Get function approach is sort of nice
-- but can probly find a way to standardize it :P










-- Junk
---------------------------------------
--frames[#frames].draw = false