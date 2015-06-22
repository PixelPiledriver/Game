-- OldCode.lua


-- Purpose
----------------------------
-- place to drop off commented out code that might be useful at a later time
-- WARNING: eventually all of this code will be deleted
-- so be careful what you put in this file



-- Create some basic objects
----------------------------------------------------------------------------------------------------------------

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


-- Various graphics stuff
----------------------------------------------------------------------------------------------------------------
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



-- Palette
----------------------------------------------------------------------------------------------------------------

local pal = Palette:NewRandom{size = 4}






-- App
----------------------------------------------------------------------------------------------------------------
-- App.lua
-- do game application stuff
-- control the window, blah blah blah

local Input = require("Input")

local App = {}

---------------------------
-- Vars
------------------------
-- object
App.name = "App"
App.oType = "Static"
App.dataType = "Manager"

----------------------
-- Components
----------------------
App.Input = Input:New()


---------------------
-- Functions
---------------------

function App:QuitGameInput(key)
	-- exit game
	if(key == "escape") then
		love.event.quit()
	end 

end 

function App:Input(key)
	self:QuitGameInput(key)
end 


ObjectUpdater:AddStatic(App)

return App







-- Camera
-------------------------------------------------------------


-- manually control the camera
-- test stuff
function Camera:RepeatedInput()

	-- move
	if(love.keyboard.isDown(self.keys.left)) then
		self.pos.x = self.pos.x + self.moveSpeed
	end 

	if(love.keyboard.isDown(self.keys.right)) then
		self.pos.x = self.pos.x - self.moveSpeed
	end 

	if(love.keyboard.isDown(self.keys.up)) then
		self.pos.y = self.pos.y + self.moveSpeed
	end 
	
	if(love.keyboard.isDown(self.keys.down)) then
		self.pos.y = self.pos.y - self.moveSpeed
	end 

	-- zoom
	if(love.keyboard.isDown(self.keys.zoomIn)) then
		self.zoom.x = self.zoom.x + self.zoomSpeed
		self.zoom.y = self.zoom.y + self.zoomSpeed
	end 

	if(love.keyboard.isDown(self.keys.zoomOut)) then
		self.zoom.x = self.zoom.x - self.zoomSpeed
		self.zoom.y = self.zoom.y - self.zoomSpeed
	end 

	-- rotate
	if(love.keyboard.isDown(self.keys.rotLeft)) then
		self.rot = self.rot + self.rotSpeed
	end 

	if(love.keyboard.isDown(self.keys.rotRight)) then
		self.rot = self.rot - self.rotSpeed
	end 

	-- shake
	if(love.keyboard.isDown(self.keys.shake1)) then
		self:Shake{xMax = 10, yMax= 10}
	end
	-- node 

end






-- Collision Manager
-------------------------------------------------------------------------

local obj = objList[a]

repeat

	if(obj.collisionList == nil) then
		break
	end 

	-- for each in collision list of a
	for c=1, #obj.collisionList do
	

		for b=1, #objList[obj.collisionList[c]] do
		
			local B = objList[obj.collisionList[c]][b]
			local A = obj

			if(self:RectToRect(A, B)) then
				A:CollisionWith{other = B}
				B:CollisionWith{other = A}

				printDebug{A.name .. " +collision+ " .. B.name, "Collision"}
			end 

		end

	end

until true

end

end 




-- Levels
-----------------------------------------------------------------------------------------------------
local TestLevel = require("levels/TestLevel")
local SnapGridTestLevel = require("levels/SnapGridTestLevel")
local LerpLevel = require("levels/LerpLevel")
local BoxTestLevel = require("levels/BoxTestLevel")
local SnapGridTestLevel = require("levels/SnapGridTestLevel")
local TextWriteLevel = require("levels/TextWriteLevel")
local BoxLevel = require("levels/BoxLevel")


LerpLevel:Load()
BoxTestLevel:Load()
TextWriteLevel:Load()
BoxLevel:Load()
SnapGridTestLevel:Load() 



--ObjectUpdater
------------------------------------------------------------------------------------------
-- this is def no longer needed ->DELETE
-- out for now
-- hooking up DrawList
ObjectUpdater:Draw()




-- Animation
--------------------------------------------------------------------------------------------------
-- original draw call before Draw component was implemented
function o:Draw(oData)

	if(self.colors) then
		love.graphics.setColor(self.colors[self.currentFrame])
	else
		love.graphics.setColor({255,255,255,255})
	end 

	love.graphics.draw(self.sheet, self.frames[self.currentFrame].frame, oData.x, oData.y, oData.angle, oData.xScale, oData.yScale)

	self:UpdateFrameTime()	
end 












-- Link
------------------------------------------------------------------------------

-- old structure
-- re writing all this stuff :P
--------------------------------------



-- Link.lua

-- object that links two objects values together




local Link = {}


function Link:New(data) 

	local o = {}

	-- objects
	o.a = data.a
	o.b = data.b


	-- component
	o.aComp = data.

	-- variable 
	o.aVar = data.aVar
	o.bVar = data.bVar

	o.linkType = data.linkType

	function o:Update()

		-- this does nothing because the value is passed as a value
		if(self.linkType == "value") then
			self.a[self.av] = self.b[self.bv]
		end 

		if(self.linkType == "func") then
			self.a[self.av] = self.b[self.bv](self.b)
		end 

	end 


	function o:PrintDebugText()
		--print(self.a)
		DebugText:TextTable
		{
			{text = "", obj = "Link"},
			{text = "Link"},
			{text = "-------------------------"},
			--{text = "A:" .. self.a},
			--{text = "B:" .. self.b},
		}
	end 



	ObjectUpdater:Add{o}

	return o

end



ObjectUpdater:AddStatic(Link)

return Link


-- notes
-------------------------------------
-- b gets applied to a
-- a should always be a 

-- try passing objects and then what you want from them seperatelys





-- DebugText
----------------------------------------------------------------------

function DebugText:ScrollMessagesControl()

	-- scroll object message index
	if(Mouse.wheelUp) then
		self.messageIndex = self.messageIndex - 1
	end 

	if(Mouse.wheelDown) then
		self.messageIndex = self.messageIndex + 1
	end

	-- set index within bounds of given min and max
	self.messageIndex = Math:Bind
											{
												value = self.messageIndex,
												min = 1,
												max = #self.texts
											}

  -- scroll each line of the first object message
  if(Keyboard:Key("2")) then
  	self.lineIndex = self.lineIndex + 1
  end 

  if(Keyboard:Key("1")) then
  	self.lineIndex = self.lineIndex - 1
  end

  if(#self.texts > 0) then
	  self.lineIndex = Math:Bind
	  								 {
	  								   value = self.lineIndex,
	  								   min = 1,
	  								   max = #self.texts[self.messageIndex]
	  								 }
	end 

end 


--DebugText
------------------------------------------------------------------

-- generic object print
-- this function isnt really needed anymore
-- DEPRICATED 11-17-2014!!
function DebugText:PrintObject(data)
	self:Text("")
	self:Text("Name: " .. data.name)
	self:Text("X: " .. data.x)
	self:Text("Y: " .. data.y)
end


-- DragWithMouse
---------------------------------------------------------------------------
	-- right click to drag a button
	function o:ClickToMove()

		if(self.hover == true and Button.buttonBeingDragged == false) then
			if(love.mouse.isDown("r")) then
				self.move = true
				Button.buttonBeingDragged = true
			end 
		end 

		if(self.move == true) then
			self.move = true
			self.lastX = love.mouse.getX() - self.Pos.x
			self.lastY = love.mouse.getY() - self.Pos.y
		end 


		-- drop
		if(self.move == true and love.mouse.isDown("r") == false) then
			self.move = false
			Button.buttonBeingDragged = false
		end 

	end 



-- Mouse Drag Example
------------------------------------------------------------------------

	-- right click to drag a button
	function o:ClickToMove()

		if(self.hover == true and Button.buttonBeingDragged == false) then
			if(love.mouse.isDown("r")) then
				self.move = true
				Button.buttonBeingDragged = true
			end 
		end 

		if(self.move == true) then
			self.move = true
			self.lastX = love.mouse.getX() - self.Pos.x
			self.lastY = love.mouse.getY() - self.Pos.y
		end 


		-- drop
		if(self.move == true and love.mouse.isDown("r") == false) then
			self.move = false
			Button.buttonBeingDragged = false
		end 

	end 





-- Unsorted
----------------------------------------------------------------------------------------------------------------

-- checking pixels before and after they are drawn to	
local pixel = {r,g,b,a}

pixel.r, pixel.g, pixel.b, pixel.a = pix.image:getPixel(10,0)
print("Pixel[" .. pixel.r .. "," .. pixel.g .. "," .. pixel.b .. "," .. pixel.a .. "]")




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

	pix:LerpStroke
	{
		a = {x=20,y=20},
		b = {x=100, y=100},
		color = pal2.colors,
		brush = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4},
		xCurve = 0.5,
		yCurve = -0.5
	}



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






























