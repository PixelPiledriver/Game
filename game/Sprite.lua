-- Sprite.lua

-- Purpose
----------------------
-- redo of sprite loading code
-- want to try and rewrite it cuz the old stuff is a little weird

-------------
-- Requires
-------------
local SpriteSheet = require("SpriteSheet")
local Color = require("Color")
local Pos = require("Pos")
local Size = require("Size")
local Scale = require("Scale")
local Draw = require("Draw")

-------------------------------------------------------------------------------

local Sprite = {}

------------------
-- Static Info
------------------
Sprite.Info = Info:New
{
	objectType = "Sprite",
	dataType = "Graphics",
	structureType = "Static"
}


----------------
-- Static Vars
----------------

-- default values
-- this makes it easier to load lots of sprites from the same sheet
Sprite.default = {}

Sprite.default.SpriteSheet = SpriteSheet.noImage
Sprite.default.Width = 32
Sprite.default.Height = 32
Sprite.default.XIndex = 1
Sprite.default.YIndex = 1
Sprite.default.X = 0
Sprite.default.Y = 0
Sprite.default.draw = false

Sprite.useSpriteSheetSpriteSize = true

-- global draw toggle
Sprite.drawNone = false


------------
-- Object
------------

function Sprite:Simple(data)
	return Sprite:New
	{
		xIndex = data[1],
		yIndex = data[2]
	}
end 

-- {spriteSheet, x, y, width, height}
function Sprite:New(data)

	FailNew
	{
		table = data,
		members = {}
	}

	local o = {}

	------------
	-- Info
	------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Sprite",
		dataType = "Graphics",
		structureType = "Object"
	}
	
	------------
	-- Vars
	------------

	o.spriteSheet = data.spriteSheet or Sprite.default.SpriteSheet

	-- Size
	o.Size = Size:New{}

	-- use sprite size defined by sprite sheet?
	if(Sprite.useSpriteSheetSpriteSize) then
		o.Size.width = o.spriteSheet.spriteWidth
		o.Size.height = o.spriteSheet.spriteHeight
	else
		o.Size.width = data.width or Sprite.default.Width
		o.Size.height = data.height or Sprite.default.Height
	end 

	o.xIndex = data.xIndex or Sprite.default.XIndex
	o.yIndex = data.yIndex or Sprite.default.YIndex

	-- NOTE: calculate the x and y below using the index above after break

	-- use index?
	if(data.xIndex) then
		o.x = o.Size.width * (data.xIndex - 1)
	-- no index
	else 
		o.x = data.x or Sprite.default.X
	end 

	-- use index?
	if(data.yIndex) then
		o.y = o.Size.height * (data.yIndex - 1)
	else
		o.y = data.y or Sprite.default.Y
	end 
	

	o.color = data.color or Color:Get("white")

	-- create sprite from sheet
	o.sprite = love.graphics.newQuad(o.x, o.y, o.Size.width, o.Size.height, o.spriteSheet.width, o.spriteSheet.height)

	
	-- display sprite
	o.draw = Bool:DataOrDefault(data.draw, self.default.draw)

	------------------
	-- Components
	------------------

	o.Pos = Pos:New(data.pos or Pos.defaultPos)

	o.Scale = Scale:New{}

	o.Draw = Draw:New
	{
		parent = o,
		depth = data.depth or "Objects"
	}

	--------------------
	-- Functions
	--------------------

	function o:Update()		

	end 

	-- draw sprite
	function o:DrawCall()

		-- global draw toggle
		if(Sprite.drawNone) then
			return
		end 

		-- object draw toggle
		if(self.draw == false) then
			return
		end 

		love.graphics.setColor(Color:AsTable(self.color))

		local x = self.Pos.x
		local y = self.Pos.y

		if(self.parent) then
			x = self.parent.Pos and self.parent.Pos.x or self.parent.xAbs or self.parent.x
			y = self.parent.Pos and self.parent.Pos.y or self.parent.yAbs or self.parent.y
		end 

		local angle = 0
		local xScale = 1
		local yScale = 1

		love.graphics.draw(self.spriteSheet.image, self.sprite, x, y, angle, self.Scale.x, self.Scale.y)

	end 

	-- what?
	-- this function might be pointless
	function o:Copy()
		local copy = Sprite:New
		{
			spriteSheet = self.spriteSheet,
			width = self.width,
			height = self.height,
			xIndex = self.xIndex,
			yIndex = self.yIndex,
			draw = true
		}

		return copy
	end 

	-- ?
	function o:CopyFor(object)

		local copy = Sprite:New
		{
			spriteSheet = self.spriteSheet,
			width = self.width,
			height = self.height,
			xIndex = self.xIndex,
			yIndex = self.yIndex,
			draw = true,
			parent = object,
		}		

		return copy
		
	end 

	function o:Destroy()
		ObjectManager:Destroy(o.Info)
		ObjectManager:Destroy(o.Size)
		ObjectManager:Destroy(o.Pos)
		ObjectManager:Destroy(o.Draw)
	end 

	----------
	-- End
	----------

	ObjectManager:Add{o}

	return o

end 


----------------------
-- Static Functions
----------------------
-- this is pointless
function Sprite:Set(object, sprite)
	object.sprite = sprite:Copy()
	object.sprite.parent = object
end 

function Sprite:GetFor(object, sprite)
	local spriteCopy = sprite:Copy()
	spriteCopy.parent = object
	return spriteCopy
end 

----------------
-- Static End
----------------

ObjectManager:AddStatic(Sprite)

return Sprite



-- Notes
-------------------
-- LOD - zoom level sprites
-- sprite has a table of other sprites to use in its place
-- depending on camera zoom, and or scale, based on options selected






-- Junk
---------------------------------------------------------------
		-- old style link
		-- this code is trash
		--[[
		if(self.parent) then

			if(self.parent.Pos) then
				x = self.parent.Pos.x + self.Pos.x
				y = self.parent.Pos.y + self.Pos.y
			else
				x = self.Pos.x
				y = self.Pos.y
			end 

		else
			x = self.Pos.x
			y = self.Pos.y
		end
		--]]
