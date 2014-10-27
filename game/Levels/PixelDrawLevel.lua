-- PixelDrawLevel.lua
-- draw the pixels and stuff


local PixelTexture = require("PixelTexture")
local PixelBrush = require("PixelBrush")
local Color = require("Color")
local Palette = require("Palette")
local Value = require("Value")
local Button = require("Button")
local Collision = require("Collision")

local PixelDrawLevel = {}







function PixelDrawLevel:Load()


	-- palette
	-------------------------------------------

	local pal = Palette:NewRandom{size=4}

	local pal2 = Palette:New{}
	pal2:Linear
	{
		a = "black",
		b = "green",
		size = 4
	}


	-- pixel generation stuff
	-------------------------------------------
	local pix = PixelTexture:New
	{
		width = 256,
		height = 256,
		filename = "RandPixels"
	}

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


 
	for i=1, 15 do
		pix:DirectionalStroke
		{
			x = Value:Range{min = 0, max = 128},
			y = Value:Range{min = 0, max = 128},
			length = Value:Range{min = 5, max = 900},
			angle = Value:Range{min = 0, max = 360},
			rot = Value:Range{min = -1, max = 1},
			rotVelocity = Value:Range{min = -20, max = 20},
			speed = Value:Value(1),
			--color = Value:Value("random"),
			color = Value:Random{values = {"blue"}},
			brush = Value:Random{values = {PixelBrush.x1, PixelBrush.x2}},
			--fade = Value:Value(0.99)
		}

	end 
	--]]


	pix:XSymmetry()
	--pix:YSymmetry()

	
	--pix:SaveToFileByIndex()


	local button1 = Button:New
	{
		x = 100,
		y = 100,
		text = "Save Pixels",
		func = 
		function()
			pix:SaveToFileByIndex()

			print("YAY!")
		end 

	}

	-- collision
	local mouseCollision = Collision:New
	{
		x = 0,
		y = 0,
		width = 32,
		height = 32,
		shape = "rect",
		name = "MiniMouse",
		mouse = true,
		collisionList = {},
	}

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











