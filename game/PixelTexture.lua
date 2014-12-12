-- PixelTexture.lua
-----------------------------------------------
-- PIXEL ROBOT
-- creates a pixel image
-- call Draw functions generate pixels
-- use with Brush.lua, Shape.lua, Palette.lua
-- then Save to a PNG

----------------
-- Requires
----------------
local ObjectUpdater = require("ObjectUpdater")
local Pos = require("Pos")
local Scale = require("Scale")
local Color = require("Color")
local Value = require("Value")
local Random = require("Random")



local PixelTexture = {}

----------------
-- Static Vars
----------------

PixelTexture.name = "PixelTexture"
PixelTexture.oType  = "Static"
PixelTexture.dataType = "Graphics Construtor"

PixelTexture.mask = nil

PixelTexture.selectedPalette = nil

-------------------------------
-- Static Functions
-------------------------------

-- wtf is this shit?
-- doesnt seem like I need this?
-- if anything this should be moved over to PixelTexture.lua
-- and be made a static function
-- untested, not sure if this actually works --> :P
function ConvertPixelTextureToPoints(pix)
	local xSpace = 7
	local ySpace = 7
	
	local points = {}
	
	for i=1, #points do
		points[i].Life:Kill()
	end 

	for x=0, pix.width-1 do
		for y=0, pix.height-1 do

			local r,g,b,a = pix.image:getPixel(x,y)
			
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

end 

-- {name, width, height}
function PixelTexture:New(data)

	-------------------
	-- Create
	-------------------

	local o = {}

	o.name = data.name or "..."
	o.oType = "PixelTexture"
	o.datatype = "Graphics Object"


	o.filename = data.filename or "image"
	o.image = love.image.newImageData(data.width, data.height)
	o.texture = nil

	o.saveIndex = 0
	o.width = data.width
	o.height = data.height

	o.draw = data.draw or false


	------------------------
	-- Components
	------------------------
	local defaultPos = 
	{
		x = 0, 
		y = 0,
		z = 0,
		speed = {x=0,y=0}
	}

	o.Pos = Pos:New(data.pos or defaultPos)


	local defaultScale =
	{
		x = 1,
		y = 1
	}

	o.Scale = Scale:New(data.scale or defaultScale)


	---------------------
	-- Functions
	---------------------


	function o:Draw()
		if(self.draw == false or self.texture == nil) then
			return
		end 


		love.graphics.setColor(Color:AsTable(Color:Get("white")))
		Draw:Draw
		{
			object = self.texture,
			x = self.Pos.x,
			y = self.Pos.y,
			xScale = self.Scale.x,
			yScale = self.Scale.y
		}

		--love.graphics.draw(self.texture, self.Pos.x, self.Pos.y, self.Scale)
	end 

	-- do stuff
	function o:Update()

	end 

	-- creates the texture from this objects pixels
	-- set draw to true to make this a object on screen
	function o:CreateTexture()
		self.texture = nil
		self.texture = love.graphics.newImage(self.image)
		self.texture:setFilter("nearest", "nearest")
	end 

	----------------------------------------------------------------------------------------------
	-- Draw
	----------------------------------------------------------------------------------------------
	-- set a single pixel
	-- {x, y, color}
	function o:Pixel(data)

		if(data.x >= self.width or data.x < 0 or data.y >= self.height or data.y < 0) then
			return
		end 

		local color = data.color or Color:Get("red")

		self.image:setPixel(data.x, data.y, color.r, color.g, color.b, color.a)

	end 

	-- {x, y, color}
	function o:Box(data)

		for x=1, data.width do
			for y=1, data.height do

				repeat

					if(data.x + x > self.width or data.x + x < 1) then 
						return
					end 

					if(data.y + y > self.height or data.y + y < 1) then
						return
					end

					self:Pixel
					{
						x = data.x + x - 1,
						y = data.y + y - 1,
						color = data.color
					}

				until true

			end
		end 

	end


	-- draws line across texture
	-- can slice multiple times
	--{ x = {#,#,...}, y = {#,#,...}, xBorder, yBorder}
	function o:Slice(data)

		-- x
		if(data.x) then

			
			for ix = 1, #data.x do	
				for y = 0, self.height-1 do

					repeat

						if(y < data.yBorder or y > self.height - data.yBorder) then
							break
						end 

						self:Pixel
						{
							x = data.x[ix],
							y = y,
							color = data.color
						}

					until true

				end
			end 

			

		end 

		-- y
		if(data.y) then

			for iy = 1, #data.y do
				for x = 0, self.width-1 do

					repeat

						if(x < data.xBorder or x > self.width - data.xBorder) then
							break
						end

						self:Pixel
						{
							x = x,
							y = data.y[iy],
							color = data.color
						}
					until true

				end
			end

		end 
	
	end 



	-- {x, y, brush}
	function o:Brush(data)
		
		for x=1, data.brush.width do
			for y=1, data.brush.height do

				if(data.brush.pixels[y][x] == 1) then
				
					repeat

						if(data.x >= self.width or data.x + x > self.width or data.x + x < 0) then 
							break
						end 

						if(data.y >= self.height or data.y + y > self.height or data.y + y < 0) then
							break
						end

						local c = nil

						if(data.color) then
							c = data.color
						else
							c = data.brush.color
						end

						self:Pixel
						{ 
							x = data.x + x-1,
							y = data.y + y-1,
							color = c
						}

					until true
				
				end 
			end
		end 
	
	end


	-- {x, y, color, brush, xRange, yRange, count}
	function o:Cluster(data)
		
		for i = 1, data.count do

			local b = nil

			if(#data.brush > 1) then
				b = Random:ChooseRandomlyFrom(data.brush)
			else 
				b = data.brush
			end 

			local c = nil
			if(#data.color > 1) then
				c = Random:ChooseRandomlyFrom(data.color)
			else
				c = data.color
			end 

			self:Brush
			{
				x = data.x + (-data.xRange + love.math.random(0, data.xRange * 2)),
				y = data.y + (-data.yRange + love.math.random(0, data.yRange * 2)),
				brush = b,
				color = c
			}

		end 

	end 

	--{a={x,y}, b{x,y}, brush, color}
	function o:LerpStroke(data)
		local lerp = 0
		
		repeat

			local c = nil

			if(#data.color > 1) then
				c = Random:ChooseRandomlyFrom(data.color)
			else
				c = data.color
			end 

			local b = nil

			if(#data.brush > 1) then
				b = Random:ChooseRandomlyFrom(data.brush)
			else 
				b = data.brush
			end 

			local x = math.ceil(Math:Lerp{a = data.a.x, b = data.b.x, t = lerp})
			local y = math.ceil(Math:Lerp{a = data.a.y, b = data.b.y, t = lerp})

			self:Brush
			{
				x = x,
				y = y,
				color = c,
				brush = b
			}
			
			lerp = lerp + 0.01

			data.b.x = data.b.x + data.xCurve
			data.b.y = data.b.y + data.yCurve

		until	lerp > 1

	end 


	local rotVelocityScale = 0.0001
	local useRotVelocityScale = true

	-- {x, y, direction, speed, rot, rotVelocity, length, brush, color, fade}
	function o:DirectionalStroke(data)

		local x = data.x and data.x:Get() or 0
		local y = data.y and data.y:Get() or 0
		local angle = data.angle and data.angle:Get() or 0

		-- rotational direction
		local rot = data.rot and data.rot:Get() or 0
		local rotVelocity = data.rotVelocity and data.rotVelocity:Get() or 0

		if(useRotVelocityScale) then
			rotVelocity = rotVelocity * rotVelocityScale
		end 

		local speed = data.speed and data.speed:Get() or 1
		local length = data.length and data.length:Get() or 25
		--local brush = data.brush and data.brush:Get() or PixelBrush.x1
		--local color = data.color and Color:Get(data.color:Get()) or Color:Get("red")
		local fade = data.fade and data.fade:Get() or 1

		-- find direction
		local direction = nil

		for i=1, length do

			-- randomizable properties
			local color = data.color and Color:Get(data.color:Get()) or Color:Get("red")

			local brush = data.brush and data.brush:Get() or PixelBrush.x1



			direction = Math:AngleToVector(angle)
			direction = Math:UnitVector(direction)

			-- draw
			self:Brush
			{
				x = x,
				y = y,
				brush = brush,
				color = color
			}

			-- move
			x = x + (direction.x * speed)
			y = y + (direction.y * speed)

			-- rotational direction			
			angle = angle + rot
			rot = rot + rotVelocity

			-- alpha damp
			color[4] = color[4] - 0.1


		end 

	end 

	----------------------------------------------------------------------------
	-- Map Pixel Functions
	----------------------------------------------------------------------------
	function o.MapPixelTestFunction(x,y,r,g,b,a)
		return r,g,b,a
	end

	function o:MapPixelTest()
		self.image:mapPixel(self.MapPixelTestFunction)
	end


	function o.ClearFunction(x,y,r,g,b,a)
		return 0,0,0,0
	end 

	function o:Clear()
		self.image:mapPixel(self.ClearFunction)
	end

	o.washColor = Color:Get("red")
	function o.WashFunction(x,y,r,g,b,a)
		return o.washColor.r, o.washColor.g, o.washColor.b, o.washColor.a
	end 

	function o:Wash()
		self.image:mapPixel(self.WashFunction)
	end 


	function o.XGradientFunction(x,y,r,g,b,a)
		local l = Math:InverseLerp{a=0, b= o.width, t = x}
		local xp = l * 255

		return xp,xp,xp,255
	end 

	function o:XGradient()
		self.image:mapPixel(self.XGradientFunction)
	end 

	function o.TestTextureIndexingFunction(x,y,r,g,b,a)
			
	
		if(x == 0) then
			r = 255
			g = 0
			b = 0
		end 


		if(x == o.width-1) then
			r = 0
			g = 0
			b = 255
		end 


		return r,g,b,a
	end 

	function o:TestTextureIndexing()
		self.image:mapPixel(self.TestTextureIndexingFunction)
	end 

	function o.XScrollFunction(x,y,r,g,b,a)

		local xi = x + 1
		if(xi >= o.width) then
			xi = x
		end 
		return o.image:getPixel(xi,y)
	end 

	function o:XScroll()
		self.image:mapPixel(self.XScrollFunction)
	end 

	function o.YScrollFunction(x,y,r,g,b,a)
		local yi = y + 1
		if(yi >= o.height) then
			yi = y
		end

		return o.image:getPixel(x,yi)
	end 

	function o:YScroll()
		self.image:mapPixel(self.YScrollFunction)
	end 

	function o.XSymmetryFunction(x,y,r,g,b,a)

		local xp = x

		if(x > o.width/2-1) then
			xp = (o.width/2) - ((x - (o.width/2)) + 1) -- oh wait no thats right lol
		end 

		--return r,g,b,a--o.image:getPixel(xp, y)return r,g,b,a
		return o.image:getPixel(xp, y)

	end


	-- half black half white
	-- for testing masks right now
	function o.SplitFunction(x,y,r,g,b,a)

		local finalColor = nil


		if(x < o.width/2) then
			finalColor = {255,255,255,255}
		else
			finalColor = {0,0,0,255}
		end

		return finalColor[1], finalColor[2], finalColor[3], finalColor[4]

	end 

	function o:Split()
		self.image:mapPixel(self.SplitFunction)
	end

	
	function o:XSymmetry()
		self.image:mapPixel(self.XSymmetryFunction)
		--self:XScroll()
	end


	function o.YSymmetryFunction(x,y,r,g,b,a)
		local yp = y

		if(y > o.height/2-1) then
			yp = (o.height/2) - ((y - (o.height/2)) + 1)
		end 

		return o.image:getPixel(x,yp)
	end

	function o:YSymmetry()
		self.image:mapPixel(self.YSymmetryFunction)
	end 


	function o.AllRandomFunction(x,y,r,g,b,a)
		local color = Color:Get("random")
		return color.r, color.g, color.b, color.a
	end 

	function o:AllRandom()
		self.image:mapPixel(self.AllRandomFunction)
	end


	function o.AllRandomFromPaletteFunction(x,y,r,g,b,a)
		local color = PixelTexture.selectedPalette:GetRandom()
		return color.r, color.g, color.b, color.a
	end 

	function o:AllRandomFromPalette(p)
		PixelTexture.selectedPalette = p
		self.image:mapPixel(self.AllRandomFromPaletteFunction)
	end 




	function o.MaskFunction(x,y,r,g,b,a)

		local r,g,b,a = PixelTexture.mask.image:getPixel(x,y)

		local finalColor = nil

		if(Color:Equal( {r,g,b,a} , {0,0,0,255})) then
			finalColor = {0,0,0,255}
		else
			local rO, gO, bO, aO = o.image:getPixel(x,y)
			finalColor = {rO, gO, bO, aO}
		end

		return finalColor[1], finalColor[2], finalColor[3], finalColor[4]
	end 

	-- (PixelTexture)
	function o:Mask(pixTexMask)
		PixelTexture.mask = pixTexMask
		self.image:mapPixel(self.MaskFunction)
	end


	--------------------------------------------------------------
	-- Save
	--------------------------------------------------------------
	-- save image to file
	-- defaults to AppData/Love/Game
	function o:SaveToFile(data)
		self.image:encode(data.filename, png)
	end

	function o:SaveToFileByIndex()
		self.image:encode(self.filename .. self.saveIndex .. ".png", "png")
		self.saveIndex = self.saveIndex + 1
	end 

	ObjectUpdater:Add{o}

	return o

end 


-----------------------
-- Test Shit
----------------------

--[[
local p = PixelTexture:New
{
	width = 32,
	height = 32
}


p:SetPixel
{
	x = 8,
	y = 8,
	color = "random"
}


p:BoxPixels
{
	x = 8,
	y = 8,
	width = 8,
	height = 8,
	color = "random"
}

p:Encode
{
	filename = "image.png", 
	type = "png"
}

--]]


-- return static

return PixelTexture





-- Notes
------------------------------------------

-- default path where images are saved
-- C:\Users\PixelPiledriver\AppData\Roaming\LOVE\game


-- pixel brush
------------------------------------
-- o is a shape of pixels that can be stamped multiple times onto a pixel texture
-- should code as seperate o that can be created


-- vertex cluster
------------------------------
-- point where many brushes/pixels are drawn within a range from its position
-- set location, then range, and number of times to draw

-- Color Palette
--------------------
-- holds colors
-- has functions that do stuff to colors, like contrast, etc

-- Color Search
----------------------
-- add better functions for getting random colors from Color.index <-- contains all named colors
-- by temp, by hue, by contrast, by etc etc.

-- Brush Stroke
------------------------------
-- linear stamping of a pixel brush
-- from a to b
-- randomize values for curves <-- use bezier
-- use rotational direction to draw complex random lines

-- Draw functions as os
-----------------------------------------
-- at some point convert the drawing functions over to os.
-- That way they can all update together over time instead of locking into a loop until they are done.
-- This gives the potential for watching the strokes be created one at a time or all together.


-- mix colors on set pixel
---------------------------------------------
-- lower alpha overwrites pixels instead of blending with them, fix that shit


-- Pixel Robot
-------------------------------------
-- Random pixel generator
-- characters
-- Educational and useful
-- Composition theory
-- Creates a daily image that you get to rate and tweak
