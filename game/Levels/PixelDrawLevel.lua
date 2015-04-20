-- PixelDrawLevel.lua
-- draw the pixels and stuff


local ObjectUpdater = require("ObjectUpdater")
local PixelTexture = require("PixelTexture")
local PixelBrush = require("PixelBrush")
local Color = require("Color")
local Palette = require("Palette")
local Value = require("Value")
local Button = require("Button")
local Collision = require("Collision")
local Mouse = require("Mouse")
local Point = require("Point")
local Line = require("Line")
local DrawTools = require("DrawTools")
local SpriteSheet = require("SpriteSheet")
local Sprite = require("Sprite")
local DrawToolsHUD = require("DrawToolsHUD")
local Panel = require("Panel")
local SimplePanel = require("SimplePanel")
local Box = require("Box")
local MapTable = require("MapTable")

-- animation test with new spriteStuff
local pawnGraphics = require("AnimationTest")


--[[
local maptable = MapTable:New
{
	width = 3,
	height = 3
}

maptable:Add
{
	object = 27,
	x = 1,
	y = 1
}
maptable:Add
{
	object = 27,
	x = 1,
	y = 2
}
maptable:Add
{
	object = 27,
	x = 1,
	y = 3
}

maptable:Add
{
	object = "fuck",
	x = 5, 
	y = 3
}

maptable:Add
{
	object = 1234,
	x = 2,
	y = 6
}
--]]
--print(maptable:Get{x=4, y=2})

-- Grid Based panel object placement and size
local gridPanel = SimplePanel:New
{
	name = "grid panel",
	posType = "bottom",	
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

---[[
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
	x = 10,
	y = 5
}
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




-- other stuff
local palPos = 
{
	x = 500,
	y = 200 
}




local mouse = Mouse:New{name = "mouse"}

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












