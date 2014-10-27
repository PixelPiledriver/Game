-- PixelTexture

local Color = require("Color")
local Value = require("Value")
local Random = require("Random")

local PixelTexture = {}



-- {name, width, height}
function PixelTexture:New(data)

	-------------------
	-- Create
	-------------------

	local object = {}

	object.name = data.name or "???"
	object.objType = "PixelTexture"


	object.filename = data.filename or "image"
	object.image = love.image.newImageData(data.width, data.height)

	object.saveIndex = 0
	object.width = data.width
	object.height = data.height





	---------------------
	-- Functions
	---------------------

	----------------------------------------------------------------------------------------------
	-- Draw
	----------------------------------------------------------------------------------------------
	-- set a single pixel
	-- {x, y, color}
	function object:Pixel(data)

		if(data.x >= self.width or data.x < 0 or data.y >= self.height or data.y < 0) then
			return
		end 

		local color = nil
		if(data.color[1] == nil) then
			color = Color:Get(data.color)
		else
			color = data.color
		end 
		self.image:setPixel(data.x, data.y, color[1], color[2], color[3], color[4])

	end 

	-- {x, y, color}
	function object:Box(data)

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
	function object:Slice(data)

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
	function object:Brush(data)
		
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
	function object:Cluster(data)
		
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
	function object:LerpStroke(data)
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
	function object:DirectionalStroke(data)

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
	function object.MapPixelTestFunction(x,y,r,g,b,a)
		return r,g,b,a
	end

	function object:MapPixelTest()
		self.image:mapPixel(self.MapPixelTestFunction)
	end


	function object.XGradientFunction(x,y,r,g,b,a)
		local l = Math:InverseLerp{a=0, b= object.width, t = x}
		local xp = l * 255
		return xp,xp,xp,255
	end 

	function object:XGradient()
		self.image:mapPixel(self.XGradientFunction)
	end 


	function object.XSymmetryFunction(x,y,r,g,b,a)

		local xp = x

		if(x > object.width/2) then
			xp = object.width/2 - (x - (object.width/2)) + 1
		end 

		return object.image:getPixel(xp, y)

	end 
	
	function object:XSymmetry()
		self.image:mapPixel(self.XSymmetryFunction)
		self:XScroll()
	end

	function object.XScrollFunction(x,y,r,g,b,a)

		local xi = x + 1
		if(xi >= object.width) then
			xi = x
		end 
		return object.image:getPixel(xi,y)
	end 

	function object:XScroll()
		self.image:mapPixel(self.XScrollFunction)
	end 

	function object.YScrollFunction(x,y,r,g,b,a)
		local yi = y + 1
		if(yi >= object.height) then
			yi = y
		end

		return object.image:getPixel(x,yi)
	end 

	function object:YScroll()
		self.image:mapPixel(self.YScrollFunction)
	end 

	function object.YSymmetryFunction(x,y,r,g,b,a)
		local yp = y

		if(y > object.height/2) then
			yp = object.height/2 - (y - (object.height/2)) + 1
		end 

		return object.image:getPixel(x,yp)
	end

	function object:YSymmetry()
		self.image:mapPixel(self.YSymmetryFunction)
		self:YScroll()
	end 





	--------------------------------------------------------------
	-- Save
	--------------------------------------------------------------
	-- save image to file
	-- defaults to AppData/Love/Game
	function object:SaveToFile(data)
		self.image:encode(data.filename, png)
	end

	function object:SaveToFileByIndex()
		self.image:encode(self.filename .. self.saveIndex .. ".png", "png")
		self.saveIndex = self.saveIndex + 1
	end 



	return object

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
-- object is a shape of pixels that can be stamped multiple times onto a pixel texture
-- should code as seperate object that can be created


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

-- Draw functions as objects
-----------------------------------------
-- at some point convert the drawing functions over to objects.
-- That way they can all update together over time instead of locking into a loop until they are done.
-- This gives the potential for watching the strokes be created one at a time or all together.


-- mix colors on set pixel
---------------------------------------------
-- lowe alpha overwrites pixels instead of blending with them, fix that shit