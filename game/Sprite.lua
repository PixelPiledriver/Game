-- Sprite.lua
-- redo of sprite loading code
-- want to try and rewrite it cuz the old stuff is a little weird

local SpriteSheet = require("SpriteSheet")
local Color = require("Color")
local Pos = require("Pos")
local Size = require("Size")

local Sprite = {}

Sprite.name = "Sprite"
Sprite.oType = "Static"
Sprite.dataType = "Graphics Constructor"

-- default values
-- this makes it easier to load lots of sprites from the same sheet
Sprite.defaultSpriteSheet = SpriteSheet.noImage
Sprite.defaultWidth = 32
Sprite.defaultHeight = 32
Sprite.defaultXIndex = 1
Sprite.defaultYIndex = 1
Sprite.defaultX = 0
Sprite.defaultY = 0
Sprite.useSpriteSheetSpriteSize = true

-- global draw toggle
Sprite.drawNone = false


-- {spriteSheet, x, y, width, height}
function Sprite:New(data)

	FailNew
	{
		table = data,
		members = {}
	}

	----------------
	-- Create
	----------------

	local o = {}

	-- other
	o.name = data.name or "..."
	o.oType = "Sprite"
	o.dataType = "Graphics"

	-- vars
	o.spriteSheet = data.spriteSheet or Sprite.defaultSpriteSheet

	-- Size
	o.Size = Size:New{}

	-- use sprite size defined by sprite sheet?
	if(Sprite.useSpriteSheetSpriteSize) then
		o.Size.width = o.spriteSheet.spriteWidth
		o.Size.height = o.spriteSheet.spriteHeight
	else
		o.Size.width = data.width or Sprite.defaultWidth
		o.Size.height = data.height or Sprite.defaultHeight
	end 

	o.xIndex = data.xIndex or Sprite.defaultXIndex
	o.yIndex = data.yIndex or Sprite.defaultYIndex

	-- NOTE: calculate the x and y below using the index above after break

	-- use index?
	if(data.xIndex) then
		o.x = o.Size.width * (data.xIndex - 1)
	-- no index
	else 
		o.x = data.x or Sprite.defaultX
	end 

	-- use index?
	if(data.yIndex) then
		o.y = o.Size.height * (data.yIndex - 1)
	else
		o.y = data.y or Sprite.defaultY
	end 
	

	o.color = Color:Get("white")

	-- create sprite from sheet
	o.sprite = love.graphics.newQuad(o.x, o.y, o.Size.width, o.Size.height, o.spriteSheet.width, o.spriteSheet.height)

	o.draw = data.draw or true


	o.parent = data.parent or nil


	--------------------
	-- Components
	--------------------

	o.Pos = Pos:New(data.pos or Pos.defaultPos)

	--------------------
	-- Functions
	--------------------


	function o:Update()
		-- nothing to do here yet
	end 


	-- draw sprite
	function o:Draw()

		-- global draw toggle
		if(Sprite.drawNone) then
			return
		end 

		-- object draw toggle
		if(self.draw == false) then
			return
		end 

		love.graphics.setColor(Color:AsTable(self.color))

		local x = 0
		local y = 0
		local angle = 0
		local xScale = 1
		local yScale = 1

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

		love.graphics.draw(self.spriteSheet.image, self.sprite, x, y, angle, xScale, yScale)

	end 

	ObjectUpdater:Add{o}

	return o

end 

ObjectUpdater:AddStatic(Sprite)

return Sprite

