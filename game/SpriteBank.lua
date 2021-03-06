-- SpriteBank.lua

-- Purpose
--------------------------------------------------------------
-- add and get sprites that all share a sprite sheet

-----------------
-- Requires
-----------------
local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local Animation = require("Animation")
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

	o.animations = {}
	o.animations.index = {}

	o.createdSprites = {}

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
		--Sprite.default.draw = false

		local newSprite = Sprite:Simple(self.sprites[name])

		--Sprite.default.draw = false

		return newSprite
	end


	-- pass in table for animation definition
	function o:AddAnimation(data)
		self.animations[data.name] = data
		self.animations.index[#self.animations.index + 1] = data.name
	end 

	function o:GetAnimation(name)

		local frames = {}

		for i=1, #self.animations[name].frames do
			frames[#frames+1] = self:Get(self.animations[name].frames[i])
		end 

		local newAnimation =
		{
			frames = frames,
			spriteSheet = self.spriteSheet,
			loopMax = self.animations[name].loopMax or nil,
			whenDonePlay = self.animations[name].whenDonePlay or nil,
			delay = self.animations[name].delay or nil,
			delays = self.animations[name].delays or nil
		}

		--print(newAnimation.whenDonePlay)

		return Animation:New(newAnimation)	

	end

	function o:CreateAnimation(name)
		local frames = {}

		for i=1, #self.animations[name].frames do
			frames[#frames+1] = self:Get(self.animations[name].frames[i])
		end

		self.createdSprites[name] = frames

		local newAnimation =
		{
			frames = frames,
			spriteSheet = self.spriteSheet,
			loopMax = self.animations[name].loopMax or nil,
			whenDonePlay = self.animations[name].whenDonePlay or nil,
			add = self.animations[name].add or false,
			delay = self.animations[name].delay or nil,
			delays = self.animations[name].delays or nil
		}

		return Animation:New(newAnimation)	
	end 

	function o:CopyAnimation(name)

		local newAnimation =
		{
			frames = self.createdSprites[name],
			spriteSheet = self.spriteSheet,
			loopMax = self.animations[name].loopMax or nil,
			whenDonePlay = self.animations[name].whenDonePlay or nil,
			delay = self.animations[name].delay or nil,
			delays = self.animations[name].delays or nil
		}

		return Animation:New(newAnimation)	
	end 



	-- print list of sprites in this bank
	function o:PrintSprites()
		for i=1, #self.sprites.index do
			printDebug{self.sprites.index[i], "SpriteBank"}
		end 
	end 

	function o:Destroy()
		printDebug{"SPRITE BANK", "SpriteBank"}
		for i=1, #self.sprites.index do
			printDebug{self.sprites.index[i], "SpriteBank"}
			ObjectManager:Destroy(self.sprites[self.sprites.index[i]])
		end 

		for i=1, #self.animations.index do
			printDebug{self.animations.index[i], "SpriteBank"}
			ObjectManager:Destroy(self.animations[self.animations.index[i]])
		end 

	end

	-------------
	-- End
	-------------

	return o

end 


return SpriteBank


-- Notes
--------------------------------
-- add function GetAnimation --> returns table of values to be passed to 
-- an AnimationComponent

-- this file might seem redundant
-- but it makes using sprites waaaay easier
-- so fuck it
-- wrappers-4-life