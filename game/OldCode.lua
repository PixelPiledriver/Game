-- OldCode.lua
-- place to drop off commented out code that might be useful at a later time



-- Create some basic objects
---------------------------------

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


-- some draw shit
---------------------------------------
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





-- Unsorted
------------------------------------------

-- checking pixels before and after they are drawn to	
local pixel = {r,g,b,a}

pixel.r, pixel.g, pixel.b, pixel.a = pix.image:getPixel(10,0)
print("Pixel[" .. pixel.r .. "," .. pixel.g .. "," .. pixel.b .. "," .. pixel.a .. "]")




-- palette
-------------------------------------------
local pal = Palette:NewRandom{size = 4}



--[[
local pal2 = Palette:New
{
	Pos = palPos,
	draw = true
}


pal2:PrintSelf()


pal2:Linear
{
	a = "black",
	b = "green",
	size = 4
}


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


































