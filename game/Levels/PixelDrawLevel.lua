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

-- DrawTools hud stuff
-- need to move to a new file soon
local iconSheet = SpriteSheet:New
{
	image = "EditorIcons.png",
}

local drawIcon = Sprite:New
{
	spriteSheet = iconSheet,
	xIndex = 1,
	yIndex = 1
}

local moveIcon = Sprite:New
{
	spriteSheet = iconSheet,
	xIndex = 2,
	yIndex = 1
}

local zoomIcon = Sprite:New
{
	spriteSheet = iconSheet,
	xIndex = 3,
	yIndex = 1
}

local colorDropIcon = Sprite:New
{
	spriteSheet = iconSheet,
	xIndex = 4,
	yIndex = 1
}

local selectIcon = Sprite:New
{
	spriteSheet = iconSheet,
	xIndex = 6,
	yIndex = 1
}


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



function PixelDrawLevel:Load()


	-- pixel generation stuff
	-------------------------------------------

---------------------
-- Buttons
---------------------

-- moving all buttons now that they have been made generic

	local monkeyFace = 100
	local actionTest = Button:ActionButton(Button.actionTest, {a = monkeyFace})
	local randomPixels = Button:ActionButton(Button.randPixels, {pix = pix})


	local pal1 = Palette:New
	{
		Pos = {x = 100, y = 100},
		draw = true
	}



	local drawButton = Button:New
	{
		x = 400,
		y = 100,
		text = "toggle!",
		toggle = true,
		sprite = drawIcon,
		printDebugTextActive = true,
		toggleOnFunc = function() 
			DrawTools:ToggleTool("Draw")
		end,
		toggleOffFunc = function()
			DrawTools:ToggleTool("Draw")
		end 
	}

	local moveButton = Button:New
	{
		x = 432,
		y = 100,
		text = "toggle!",
		toggle = true,
		sprite = moveIcon,
		--printDebugTextActive = true
		toggleOnFunc = function()
			DrawTools:ToggleTool("Move")
		end,
		toggleOffFunc = function()
			DrawTools:ToggleTool("Move")
		end 
	}

	local zoomButton = Button:New
	{
		x = 464,
		y = 100,
		text = "toggle!",
		toggle = true,
		sprite = zoomIcon,
		--printDebugTextActive = true
	}

	local colorDropButton = Button:New
	{
		x = 496,
		y = 100,
		text = "toggle!",
		toggle = true,
		sprite = colorDropIcon,
		--printDebugTextActive = true
		toggleOnFunc = function()
			DrawTools:ToggleTool("ColorDrop")
		end,
		toggleOffFunc = function()
			DrawTools:ToggleTool("ColorDrop")
		end 
	}

	local selectButton = Button:New
	{
		x = 528,
		y = 100,
		text = "toggle!",
		toggle = true,
		saveAsLast = false,
		sprite = selectIcon,
		printDebugTextActive = true,
	}
	

	Button:DefaultLast()




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

			pix:CreateTexture()
		end 
	}

	local savePixels = Button:ActionButton(Button.savePixels, {pix = pix})

	local createPix = Button:New
	{
		text = "Create Pix",
		func = function()
			MakePixels()
			pix:CreateTexture()
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












