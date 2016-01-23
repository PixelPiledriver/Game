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
local Panel = require("Panel")
local Text  = require("Text")
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

AnimationEditor.currentAnimation = nil

AnimationEditor.frameIndex = 1
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

function AnimationEditor:Update()

	if(self.currentAnimation.frames) then
		self.infoPanel.frameCount.text = "Frames:" .. #self.currentAnimation.frames
		self.infoPanel.framePos.text = "FrameIndex:" .. self.frameIndex
	else
		self.infoPanel.frameCount.text = "Frames:0"
		self.infoPanel.framePos.text = "FrameIndex:1"
	end

end 

function AnimationEditor:Setup()
	-- create draw component
	self.Draw = Draw:New
	{
		parent = self	
	}	

	-- create a blank animation, ready to be filled with frames
	self.currentAnimation = Animation:New{x = 200, y = 200}

	------------------
	-- Info Panel -->move to new file as sub file
	------------------
	self.infoPanel = {}
	self.infoPanel.panel = Panel:New
	{
		name = "Info",
		gridWidth = 80,
		gridHeight = 16,
		x = 100, 
		y = 100,
	}

	Text.default.color = "black"
	Text.default.size = 10

	self.infoPanel.frameCount = Text:New{}
	self.infoPanel.framePos = Text:New{}

	self.infoPanel.panel:AddVertical
	{
		self.infoPanel.frameCount,
		self.infoPanel.framePos
	}

	self.buttonsPanel = Panel:New
	{
		name = "Buttons",
		x = 200,
		y = 200,
		gridWidth = 32,
		gridHeight = 32,
	}

	self:CreateIndexButtons()

	self.spriteSheetPanel = Panel:New
	{
		name = "SpriteSheet",
		x = 300,
		y = 300,	
	}

end




function AnimationEditor:CreateIndexButtons()

	local buttonSize = 24

	self.nextFrameIndexButton = Button:New
	{
		name = "NextFrameIndex",
		text = ">",
		x = 250,
		y = 400,
		width = buttonSize,
		height = buttonSize,

		func = function()
			self.frameIndex = self.frameIndex + 1

			if(self.currentAnimation.frames) then
				if(self.frameIndex > #self.currentAnimation.frames) then
					self.frameIndex = #self.currentAnimation.frames
				end
			else
				self.frameIndex = 1
			end 
		end 
	}

	self.prevFrameIndexButton = Button:New
	{
		name = "PrevFrameIndex",
		text = "<",
		x = 200,
		y = 400,
		width = buttonSize,
		height = buttonSize,

		func = function()
			self.frameIndex = self.frameIndex - 1
			if(self.frameIndex < 1) then
				self.frameIndex = 1
			end 
		end
	}

	self.buttonsPanel:AddHorizontal
	{
		self.prevFrameIndexButton,
		self.nextFrameIndexButton
	}

end

function AnimationEditor:LoadSpriteSheet(spriteSheet)
	self.spriteSheet = spriteSheet
	self.spriteSheetQuad = love.graphics.newQuad(0, 0, spriteSheet.width, spriteSheet.height, spriteSheet.width, spriteSheet.height)
	self.currentAnimation.spriteSheet = self.spriteSheet
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
					self.currentAnimation:AddFrame(self.newSprite)
					printDebug{"add frame", "AnimationEditor"}
				end
			}

			self.spriteSheetPanel:AddHorizontal
			{
				self.addFrameButtons[#self.addFrameButtons]
			}

		end 
	end

	--self.spriteSheetPanel:AddHorizontal{self.spriteSheet}



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




-- editor draws its spritesheet manually
-- this might not be neccessary
-- maybe change
function AnimationEditor:DrawCall()
	love.graphics.setColor(Color:AsTable(self.color))
	love.graphics.draw(self.spriteSheet.image, self.spriteSheetQuad, self.spriteSheetPos.x, self.spriteSheetPos.y, angle, xScale, yScale)
end 

-- runs on level exit
function AnimationEditor:Exit()
	ObjectManager:Destroy(self.currentAnimation)
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








-- Junk
--------------------------------------------------
--[==[

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
			self.currentAnimation:AddFrame(self.newSprite)
		end,
	}
	--]]


--]==]