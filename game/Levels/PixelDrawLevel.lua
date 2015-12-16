-- PixelDrawLevel.lua
-- draw the pixels and stuff

--------------
-- Requires
--------------
local PixelTexture = nil
local PixelBrush = nil
local Color = nil
local Palette = nil
local Value = nil
local Button = nil
local Collision = nil
local Point = nil
local Line = nil
local DrawTools = nil
local SpriteSheet = nil
local Sprite = nil
local pawnGraphics = nil -- animation test with new spriteStuff
local DrawToolsUI = nil
local Panel = nil
local Box = nil
local MapTable = nil
local Link = nil
local InputText = nil
local ParticleSystem = nil
local DrawGroup = nil
local Text = nil

------------------------------------------------------


local Start = function()

	-------------------
	-- Requires Load
	-------------------
	PixelTexture = require("PixelTexture")
	PixelBrush = require("PixelBrush")
	Color = require("Color")
	Palette = require("Palette")
	Value = require("Value")
	Button = require("Button")
	Collision = require("Collision")
	Point = require("Point")
	Line = require("Line")
	DrawTools = require("DrawTools")
	SpriteSheet = require("SpriteSheet")
	Sprite = require("Sprite")
	pawnGraphics = require("AnimationTest") -- animation test with new spriteStuff
	DrawToolsUI = require("DrawToolsUI")
	Panel = require("SimplePanel")
	Box = require("Box")
	MapTable = require("MapTable")
	Link = require("Link")
	InputText = require("InputText")
	ParticleSystem = require("ParticleSystem")
	DrawGroup = require("DrawGroup")
	Text = require("Text")

	-- test stuff code and stuff

	local mouse = Mouse:New{name = "mouse"}

	local textTest = Text:New
	{
		text = "poop",
		size = 32,
		x = 200,
		y = 100,
		timer = 100,
		box = {color = Color:Get("green")}
	}

	-- fixing DrawGroup

	local greenBox = Box:New
	{
		x = 275,
		y = 200,
		width = 100,
		height = 100,
		color = Color:Get("green")
	}

	local orangeBox = Box:New
	{
		x = 300,
		y = 225,
		width = 100,
		height = 100,
		color = Color:Get("orange")
	}


	local blueBox = Box:New
	{
		x = 250,
		y = 150,
		width = 100,
		height = 100,
		color = Color:Get("blue"),
	}


	-- DrawGroup is broken right now
	-->FIX
	local group = DrawGroup:New{objects = {orangeBox, greenBox, blueBox}}


	local bob = Box:New
	{
		width = 32,
		height = 32,
		color = Color:Get("black")
	}


	Link:Simple
	{
		a = {bob, "Pos", {"x", "y"}},
		b = {mouse, {"x", "y"}}
	}


	-- Grid Based panel object placement and size
	local gridPanel = Panel:New
	{
		name = "Panel: the dopeness",
		posType = "bottom",
		gridScale = 16,
		colorSkin = "blue"
	}

	local gbox1 = Box:New
	{
		width = 16,
		height = 16,
		color = Color:Get("orange")
	}

	local gbox2 = Box:New
	{
		width = 16,
		height = 16,
		color = Color:Get("black")
	}

	local gbox3 = Box:New
	{
		width = 16,
		height = 16,
		color = Color:Get("white")
	}


	gridPanel:Add
	{
		object = gbox1,
		x = 1,
		y = 1
	}

	gridPanel:Add
	{
		object = gbox2,
		x = 2,
		y = 1
	}

	gridPanel:Add
	{
		object = gbox3,
		x = 5,
		y = 5
	}



	-- other stuff
	local palPos = 
	{
		x = 500,
		y = 200 
	}

	local palPos2 =
	{
		x = 700,
		y = 200	
	}



	local pix = PixelTexture:New
	{
		width = 32,
		height = 32,
		filename = "RandPixels",
		draw = true,
		pos = 
		{
			x = 200,
			y = 200
		},

		scale =
		{
			x = 1,
			y = 1
		}
	}

	DrawTools.selectedPixelTexture = pix

	local pix2 = PixelTexture:New
	{
		width = 32,
		height = 32,
		filename = "stuff",
		draw = true,
		pos = 
		{
			x = 200,
			y = 200
		},

		scale =
		{
			x = 8,
			y =8
		}
	}

	local pal2 = Palette:New
	{
		Pos = palPos,
		draw = true
	}

	pal2:Interpolated
	{
		colors =
		{
			"red", "blue", "green"
		},

		indexes =
		{
			1, 5, 6
		},
	}

	-- draws and writes pixels to a png
	-- this is just testing function
	-- so feel free to go crazy and change how pixels are drawn
	local selectedPalette = pal2


	---------------------
	-- Buttons
	---------------------

	-- moving all buttons now that they have been made generic

	local monkeyFace = 100

	local pal1 = Palette:New
	{
		Pos = {x = 100, y = 100},
		draw = true
	}


	Button:DefaultLast()


	local loadSpriteToPixTex = Button:New
	{
		text = "Load PNG to PixTex",
		func = function()
			pix:LoadFromSpriteSheet
			{
				spriteSheet = pawnGraphics.pawnSheet
			}
		end
	}

	local actionTest = Button:ActionButton(Button.actionTest, {a = monkeyFace})
	local randomPixels = Button:ActionButton(Button.randPixels, {pix = pix})
	local randPal = Button:ActionButton(Button.randPalette, {pal = pal1})
	
	local testTexture = Button:New
	{
		text = "Create Pal+Pix",
		func = function()

			pal = nil
			pal = Palette:New
			{
					Pos = palPos2,
					draw = true
			}

			pal:Linear
			{
				a = "random",
				b = "random",
				size = 10
			}

			pal:Interpolated
			{
				colors = {"random", "random", "random"},
				indexes = {1, 4, 7}
			}

			pal:CalculateColorStats()

			--selectedPalette = pal
			pix.palette = pal

			MakePixels()
			--pix:TestTextureIndexing()

			pix:RefreshTexture()
		end 
	}

	local savePixels = Button:ActionButton(Button.savePixels, {pix = pix})

	local refreshSprite = Button:New
	{
		text = "Refresh Sprite",
		func = function()
			pix:RefreshSprite()
		end
	}

	local createPix = Button:New
	{
		text = "Create Pix",
		func = function()
			MakePixels()
			pix:RefreshTexture()
		end
	}

	local wash = Button:ActionButton(Button.wash, {pix = pix})
	
	local convertPixels = Button:New
	{
		text = "Convert Pixels",
		func = function()
			MakePixels()
			ConvertPixelTextureToPoints()
		end 
	}
	

	-- create
	local buttonsPanel = Panel:New
	{
		name = "Buttons",
		posType = "bottom",
		gridWidth = 100,
		gridHeight = 64,
		colorSkin = "gray"
	}

	-- add objects
	buttonsPanel:AddVertical
	{
		loadSpriteToPixTex,
		actionTest,
		randomPixels,
		randPal,
		testTexture,
		savePixels,
		refreshSprite,
		createPix,
		wash,
		convertPixels,
	}


end 





local Update = function()

--[[
	local pointTest = Collision:PointInRect
	{
		point = {x = 100, y = 100},
		rect = 
		{
			a = {x = 0, y = 0},
			b = {x = 100, y = 100}
		}
	}

	print(pointTest)
	--]]

end


local Exit = function()
end 

local Restart = function()
end 



local function MakePixels()
	pix:Clear()
	pix:AllRandomFromPalette(selectedPalette)
	pix2:Split()
	pix:Mask(pix2)
end 


local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "PixelDrawLevel"
}

return level


-- Notes
------------------------------------------------------
-- use love.graphics.setScissor and self.itemOffset to create a scrolling panel
-- items outside the draw area should be deativated



-------------------------
-- Test Code
-------------------------
--[[


local boxy = Box:New{}

local inputTextTest = InputText:New
{
	keys =
	{
		"q","w","e","r","t","y",
		"u","i","o","p","a","s",
		"d","f","g","h","j","k",
		"l","z","x","c","v","b","n","m"
	}
}



local billy = Box:New
{
	x = 200,
	y = 200,
	width = 16,
	height = 16,
	color = Color:Get("peru")
}

local heightLink = Link:New
{
	a = {
				o = billy,
				comp = "Size",
				var = "height"
			},
	b = {
				o = mouse,
				var = "y",
			},
	type = "value"
}

local xLink = Link:New
{
	a = {
				o = billy,
				comp = "Pos",
				var = "x",
			},
	b = {
				o = mouse,
				var = "x"
			},

	type = "value"
}


-- 1st Test panel
--------------------------------
local panel = Panel:New
{
	posType = "bottom",
	name = "Test Panel"
}

local pBox = Box:New
{
	width = 50,
	height = 20,
	color = Color:Get("white")
}

local pBox2 = Box:New
{
	width = 50,
	height = 20,
	color = Color:Get("orange")
}

local pBox3 = Box:New
{
	width = 50,
	height = 20,
	color = Color:Get("yellow")
}

local pBox4 = Box:New
{
	width = 50,
	height = 20,
	color = Color:Get("lightGreen")
}


local button1 = Button:New
{
	text = "Button1",
	func = function()
	end
}

panel:Add(pBox)
panel:Add(pBox2)
panel:Add(pBox3)
panel:Add(pBox4)
panel:Add(pawnGraphics.sprites.idle)
panel:Add(pawnGraphics.sprites.attack)
panel:Add(pawnGraphics.sprites.walk)
panel:Add(button1)



	local hidePanel = Button:New
	{
		text = "Hide Panel",
		toggle = true,
		toggleOnFunc = function()
			panel:ToggleDraw()
		end,
		toggleOffFunc = function()
			panel:ToggleDraw()
		end 
	}



--]]