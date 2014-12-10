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


--[[
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
--]]

--pal2:PrintSelf()

--[[
pal2:Linear
{
	a = "black",
	b = "green",
	size = 4
}
--]]

-- draws and writes pixels to a png
-- this is just testing function
-- so feel free to go crazy and change how pixels are drawn
local selectedPalette = pal2

function MakePixels()

	pix:Clear()

--[[
	for i=1, 15 do

		pix:DirectionalStroke
		{
			x = Value:Range{min = 0, max = pix.width},
			y = Value:Range{min = 0, max = pix.height},
			length = Value:Range{min = 5, max = 900},
			angle = Value:Range{min = 0, max = 360},
			rot = Value:Range{min = -1, max = 1},
			rotVelocity = Value:Range{min = -20, max = 20},
			speed = Value:Value(1),
			--color = Value:Value("random"),
			color = Value:Random{values = {"blue"}},
			brush = Value:Random{values = {PixelBrush.x2}},
			--fade = Value:Value(0.99)
		}

	end
	--]]

	--[[
	for i = 1, 80, 2 do
		pix:Cluster
		{
			x = pix.width/2 + love.math.random(-pix.width/4, pix.width/4),
			y = pix.height/16 + i, 
			xRange = love.math.random(0,30),
			yRange = 3,
			color = selectedPalette.colors,
			brush = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4},
			count = 200,
		}
	end 
	--]]

	pix:AllRandomFromPalette(selectedPalette)
	pix2:Split()

	pix:Mask(pix2)

	--pix:XSymmetry()
	--pix:YSymmetry() 

end 



function PixelDrawLevel:Load()


	-- line
	----------------------------------------
	local line1 = Line:New
	{
		a = {x = 400, y = 400},
		b = {x = 500, y = 420},
		width = 10,
		color = "black",
		life = 200,
		fade = true,
		fadeWithLife = true
	}

--[[
	local point1 = Point:New
	{
		pos =
		{
			x = 100,
			y = 100
		},
		color = "blue",
		life = 100,
		fade = true,
		fadeWithLife = true,
		sizeSpeed = 1,
		speed = 
		{
			x = 0.1
		}
	}
	
	local point2 = Point:New
	{
		color = "black",

		pos =
		{
			x = 200,
			y = 400,
		},

		speed = 
		{
			x = 1,
			y = -1
		},
		--life = 100
	}
	--]]

	-- palette
	-------------------------------------------

	local pal = Palette:NewRandom{size=4}




	-- pixel generation stuff
	-------------------------------------------

-- Buttons


	local selectedPixelTexture = pix
	local points = {}
	function ConvertPixelTextureToPoints()


		local xSpace = 7
		local ySpace = 7
		
		
		for i=1, #points do
			points[i].Life:Kill()
		end 

		---[[
		for x=0, selectedPixelTexture.width-1 do
			for y=0, selectedPixelTexture.height-1 do

				local r,g,b,a = selectedPixelTexture.image:getPixel(x,y)
				
				local p = Point:New
				{
					pos =
					{
						x = 200 + x + (xSpace * x),
						y = 200 + y + (ySpace * y), 
					},
					color = Color:New{r=r, g=g, b=b, a=a},
					colorType = "new",
					size = 8,
					life = 100,
					drain = false
				}

				points[#points+1] = p
			end 
		end 
		--]]

	end 

	print(selectedPixelTexture.width)



	local testTexture = Button:New
	{
		text = "Test Texture",
		func = function()

			--ObjectUpdater:Destroy(selectedPalette)

			local pal = Palette:New
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

			pal:PrintSelf()

			pal:SortByFunc("Luminance")

			MakePixels()
			--pix:TestTextureIndexing()
			--pix:XSymmetry()
			--pix:YSymmetry()

			pix:CreateTexture()
		end 
	}

	local createPix = Button:New
	{
		text = "Create PixTex",
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
			print(pix.image:getPixel(0,0))
		end 
	}




	local valueTest = Button:New(Button.valueTest)
	local convertPixels = Button:New
	{
		text = "Convert Pixels",
		func = function()
			MakePixels()
			ConvertPixelTextureToPoints()
		end 
	}
	
	local createPoint = Button:New(Button.createPoint)
	local savePixels = Button:New
	{
		text = "Save Pixels",
		func = function()
			pix:SaveToFileByIndex()
		end
	}


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

-- old draw shit

--[[
	pix:Box
	{
		x = 0,
		y = 0,
		width = 32,
		height = 32,
		color = "red"
	}

	for i=1, 100 do
		pix:Brush
		{
			x = love.math.random(0,128),
			y = love.math.random(0,128),
			brush = PixelBrush.happyFace,
		}	
	end 


	for i=1, 40 do
		pix:Slice
		{
			x = {love.math.random(0,128)}, 
			y = {love.math.random(0,128)}, 
			color="black"
		}		
	end 

	pix:Brush
	{
		x = 10,
		y = 10,
		brush = PixelBrush.smallCircle,
	}

	pix:Slice
	{
		y={0, 10, 20, 30},
		color="red"
	}

	pix:XSymmetry()
	pix:YSymmetry()
	
	for i=1, 50 do
		pix:Brush
		{
			x = love.math.random(0, pix.width),
			y = love.math.random(0, pix.height),
			brush = PixelBrush.x8
		}
	end 

	pix:Slice
	{
		x = {0,5,10,15, 20},
		color = "orange"
	}

	pix:Pixel
	{
		x = 0,
		y = 0,
		color = "blue"
	}

	pix:Pixel
	{
		x = pix.width-1,
		y = pix.height-1,
		color = "blue"
	}



	-- checking pixels before and after they are drawn to	
	local pixel = {r,g,b,a}

	pixel.r, pixel.g, pixel.b, pixel.a = pix.image:getPixel(10,0)
	print("Pixel[" .. pixel.r .. "," .. pixel.g .. "," .. pixel.b .. "," .. pixel.a .. "]")

	
	--]]




-- more pixel drawing stuff


	--[[
	for i = 1, 80, 2 do
		pix:Cluster
		{
			x = 64 + love.math.random(-32, 32),
			y = 20 + i, 
			xRange = love.math.random(0,30),
			yRange = 3,
			color = pal2.colors,
			brush = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4},
			count = 200,
		}
	end 


	pix:XSymmetry()
	pix:YSymmetry()
--]]

--[[
	pix:LerpStroke
	{
		a = {x=20,y=20},
		b = {x=100, y=100},
		color = pal2.colors,
		brush = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4},
		xCurve = 0.5,
		yCurve = -0.5
	}
--]]

--[[
	pix:DirectionalStroke
	{
		x = Value:Value(64),
		y = Value:Value(32),
		length = Value:Value(800),
		angle = Value:Value(0),
		rot = Value:Value(1.5),
		rotVelocity = Value:Value(44),
		speed = Value:Value(1),
		color = Value:Value("random"),
		brush = Value:Random{values = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4}},
		fade = Value:Value(0.99)
	}
	--]]











