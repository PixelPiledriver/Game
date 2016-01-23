-- SpriteBank.lua

-- Purpose
--------------------------------------------------------------
-- add and get sprites that all share a sprite sheet

-----------------
-- Requires
-----------------
local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")

---------------------------------------------------
local SpriteBank = {}

-------------------
-- Static Info
-------------------
SpriteBank.Info = Info:New
{
	objectType = "SpriteBank",
	dataType = "Graphics",
	structureType = "Static"
}

-------------
-- Object
-------------

function SpriteBank:New(data)

	-------------
	-- Fails
	-------------
	local fail = FailNew
	{
		table = data,
		members = 
		{
			"image", "spriteWidth", "spriteHeight" 
		}
	}

	if(fail) then
		return
	end 

	local o = {}

	-----------
	-- Info
	-----------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "SpriteBank",
		dataType = "Graphics",
		structureType = "Object"
	}

	----------
	-- Vars
	----------
	o.spriteSheet = SpriteSheet:New
	{
		image = data.image,
		spriteWidth = data.spriteWidth,
		spriteHeight = data.spriteHeight
	}

	o.sprites = {}
	o.sprites.index = {}

	---------------
	-- Functions
	---------------

	-- add sprites
	-- data = { {name,x,y}, ...}
	function o:Add(data)
		for i=1, #data do
			self.sprites[data[i][1]] = {data[i][2], data[i][3]}
			self.sprites.index[#self.sprites.index+1] = data[i][1]
		end 
	end

	-- get a new duplicate of sprite by name
	-- out of the bank
	function o:Get(name)

		-- set spritesheet to be passed to new Sprites from Sprite static
		Sprite.default.SpriteSheet = self.spriteSheet
		
		-->MAKE OPTIONAL
		Sprite.default.draw = true 

		local newSprite = Sprite:Simple(self.sprites[name])

		Sprite.default.draw = false

		return newSprite
	end


	-- print list of sprites in this bank
	function o:PrintSprites()
		for i=1, #self.sprites.index do
			print(self.sprites.index[i])
		end 
	end 

	-------------
	-- Setup
	-------------

	return o

end 


return SpriteBank


-- Notes
--------------------------------
-- this file might seem redundant
-- but it makes using sprites waaaay easier
-- so fuck it
-- wrappers-4-life