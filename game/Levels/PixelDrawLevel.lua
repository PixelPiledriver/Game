-- PixelDrawLevel.lua
-- draw the pixels and stuff


local PixelTexture = require("PixelTexture")
local PixelBrush = require("PixelBrush")
local Color = require("Color")
local Palette = require("Palette")
local Value = require("Value")
local Button = require("Button")
local Collision = require("Collision")
local Point = require("Point")
local Line = require("Line")
local DrawTools = require("DrawTools")
local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local pawnGraphics = require("AnimationTest") -- animation test with new spriteStuff
local DrawToolsHUD = require("DrawToolsHUD")
local Panel = require("Panel")
local SimplePanel = require("SimplePanel")
local Box = require("Box")
local MapTable = require("MapTable")
local Link = require("Link")
local InputText = require("InputText")
local ParticleSystem = require("ParticleSystem")
local DrawGroup = require("DrawGroup")
local Text = require("Text")

-- test stuff code and stuff

local mouse = Mouse:New{name = "mouse"}

local textTest = Text:New
{
	text = "Shit Buddies",
	size = 32,
	x = 100,
	y = 100
}

local billy = Box:New
{
	x = 275,
	y = 200,
	width = 200,
	height = 100,
	color = Color:Get("black")
}

local billy2 = Box:New
{
	x = 300,
	y = 225,
	width = 200,
	height = 100,
	color = Color:Get("white")
}


local billy3 = Box:New
{
	x = 200,
	y = 150,
	width = 222,
	height = 222,
	color = Color:Get("red"),
}



local group = DrawGroup:New{billy2, billy3}


local bob = Box:New
{
	width = 32,
	height = 32,
	color = Color:Get("orange")
}


local xLink = Link:New
{
	a = {
				o = bob,
				comp = "Pos",
				var = "x",
			},
	b = {
				o = mouse,
				var = "x"
			},

	type = "value"
}

local yLink = Link:New
{
		a = {
				o = bob,
				comp = "Pos",
				var = "y",
			},
	b = {
				o = mouse,
				var = "y"
			},

	type = "value"
}



-- Grid Based panel object placement and size
local gridPanel = SimplePanel:New
{
	name = "Panel: the dopeness",
	posType = "bottom",
	gridScale = 16
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

--]]


-- other stuff
local palPos = 
{
	x = 500,
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
		x = 8,
		y = 8
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

function MakePixels()
	pix:Clear()
	pix:AllRandomFromPalette(selectedPalette)
	pix2:Split()
	pix:Mask(pix2)
end 

local PixelDrawLevel = {}



function PixelDrawLevel:Load()


	-- pixel generation stuff
	-------------------------------------------

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
					Pos = palPos,
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




end 





function PixelDrawLevel:Update()



end


function PixelDrawLevel:Exit()
end 

return PixelDrawLevel



-- Notes
------------------------------------------------------





-- old test stuff
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





--]]

--]]

-- 1st Test panel
--[[
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

--]]