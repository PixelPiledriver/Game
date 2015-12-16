-- AnimationEditor.lua

-- Purpose
-----------------------------------
-- create animations at runtime
-- from sprites

-------------
-- Requires
-------------

local Animation = require("Animation")
local Draw = require("Draw")
local Color = require("Color")
local Collision = require("Collision")
local Button = require("Button")
local Pos = require("Pos")
local Sprite = require("Sprite")
----------------------------------------------------------

local AnimationEditor = {}

-------------------
-- Static Info
-------------------
AnimationEditor.Info = Info:New
{
	objectType = "AnimationEditor",
	dataType = "Graphics",
	structureType = "Static"
}

-----------------
-- Static Vars
-----------------

AnimationEditor.selectedAnimation = nil

AnimationEditor.frameSpace = 16
AnimationEditor.displayFrames = true

AnimationEditor.spriteSheet = nil
AnimationEditor.color = Color:Get("white")

AnimationEditor.sprites = nil

AnimationEditor.currentAnimaion = nil

----------------
-- Components
----------------
AnimationEditor.Pos = Pos:New
{
	x = 10,
	y = 10
}

--------------
-- Functions
--------------
function AnimationEditor:Setup()
	self.Draw = Draw:New
	{
		parent = self	
	}	

	self.currentAnimaion = Animation:New{x = 200, y = 200}

end


function AnimationEditor:LoadSpriteSheet(spriteSheet)
	self.spriteSheet = spriteSheet
	self.spriteSheetQuad = love.graphics.newQuad(0, 0, spriteSheet.width, spriteSheet.height, spriteSheet.width, spriteSheet.height)
	self.currentAnimaion.spriteSheet = self.spriteSheet
	self.spriteSheetPos = Pos:New
	{
		x = 300,
		y = 100
	}

	-- create add frame Buttons
	self.addFrameButtons = {}

	for i=1, self.spriteSheet.width / self.spriteSheet.spriteWidth do
		for j=1, self.spriteSheet.height / self.spriteSheet.spriteHeight do

		
			self.addFrameButtons[#self.addFrameButtons+1] = Button:New
			{
				name = "Add Frame: " .. i,
				drawText = false,
				x = self.spriteSheetPos.x + (self.spriteSheet.spriteWidth * (i - 1)),
				y = self.spriteSheetPos.y + (self.spriteSheet.spriteHeight * (j - 1)),
				width = self.spriteSheet.spriteWidth,
				height = self.spriteSheet.spriteHeight,

				func = function()
					self:CreateSpriteFromSheet(i, j)
					self.currentAnimaion:AddFrame(self.newSprite)
					print("add frame")
				end,
			}

		end 
	end 

	--[[
	self.addFrameButton = Button:New
	{
		name = "Add Frame",
		text = "Add Frame",
		x = self.spriteSheetPos.x,
		y = self.spriteSheetPos.y,
		width = self.spriteSheet.spriteWidth,
		height = self.spriteSheet.spriteHeight,

		func = function()
			self:CreateSpriteFromSheet()
			self.currentAnimaion:AddFrame(self.newSprite)
		end,
	}
	--]]
end 

function AnimationEditor:CreateSpriteFromSheet(x, y)

	self.newSprite = Sprite:New
	{
		spriteSheet = self.spriteSheet,
		xIndex = x,
		yIndex = y,
		draw = false
	}


end 

function AnimationEditor:DrawCall()
	love.graphics.setColor(Color:AsTable(self.color))
	love.graphics.draw(self.spriteSheet.image, self.spriteSheetQuad, self.spriteSheetPos.x, self.spriteSheetPos.y, angle, xScale, yScale)
end 

-- runs on level exit
function AnimationEditor:Exit()
	ObjectManager:Destroy(self.currentAnimaion)
	ObjectManager:Destroy(self.Draw)
	ObjectManager:Destroy(self.Pos)
	ObjectManager:Destroy(self.addFrameButton)
	ObjectManager:Destroy(self.Info)

	for i=1, #self.addFrameButtons do
		ObjectManager:Destroy(self.addFrameButtons[i])
		self.addFrameButtons[i] = nil
	end

end 


-------------------
-- Static End
-------------------




-- Notes
------------------------------
-- how to work with SpriteSheet, Sprite, and Animation


--[[


-- SpriteSheet
------------------
pawnGraphics.pawnSheet = SpriteSheet:New
{
	image = "pawnSheet.png",
	spriteWidth = 64,
	spriteHeight = 64
}


-- Sprite
------------------
pawnGraphics.sprites.idle = Sprite:New
{
	spriteSheet = pawnGraphics.pawnSheet,
	xIndex = 1,
	yIndex = 1,
}


-- Animation
------------------
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

--]]

















return AnimationEditor






-- Notes
----------------------
-- this will be a somewhat complex and changing file
-- changes to Sprite and SpriteSheet may be needed
