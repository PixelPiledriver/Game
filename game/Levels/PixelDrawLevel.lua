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


-- other stuff
local palPos = 
{
	x = 500,
	y = 200 
}



local PixelDrawLevel = {}


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
		y =8
	}
}

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



function PixelDrawLevel:Load()


	-- pixel generation stuff
	-------------------------------------------

-- Buttons


	local actionTest = Button:NewObjectAction(Button.actionTest)


	local pal = nil
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

			selectedPalette = pal

			MakePixels()
			--pix:TestTextureIndexing()

			pix:CreateTexture()
		end 
	}

	local createPix = Button:New
	{
		text = "Create Pix",
		func = function()
			MakePixels()
			pix:CreateTexture()
		end
		
	}

	local wash = Button:New
	{
		text = "Wash",
		func = function()
			pix:Wash()
		end 
	}
	
	local convertPixels = Button:New
	{
		text = "Convert Pixels",
		func = function()
			MakePixels()
			ConvertPixelTextureToPoints()
		end 
	}
	
	local savePixels = Button:New
	{
		text = "Save Pixels",
		func = function()
			pix:SaveToFileByIndex()
		end
	}


	local valueTest = Button:New(Button.valueTest)
	local createPoint = Button:New(Button.createPoint)
	local rfUp = Button:New(Button.repeatFunctionUp)
	local rfDown = Button:New(Button.repeatFunctionDown)
	local britUp = Button:New(Button.britUp)
	local britDown = Button:New(Button.britDown)
	local quit = Button:New(Button.quit)

end 





function PixelDrawLevel:Update()
end


function PixelDrawLevel:Exit()
end 

return PixelDrawLevel



-- Notes
------------------------------------------------------












