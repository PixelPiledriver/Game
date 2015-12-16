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
App.objectType = "Static"
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


ObjectManager:AddStatic(App)

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



--ObjectManager
------------------------------------------------------------------------------------------
-- this is def no longer needed ->DELETE
-- out for now
-- hooking up DrawList
ObjectManager:Draw()




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



	ObjectManager:Add{o}

	return o

end



ObjectManager:AddStatic(Link)

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


-- Input
-------------------------------------------------------------------------------

			-- run thru all keys
			if(inputType == "press") then
				print("press")
				if(self.pressKeys[key]) then
					print("press this stuff")
					self.pressKeys[key].func()
				end 

			end

			if(inputType == "release") then
				
				if(self.releaseKeys[key]) then
					print("release this stuff")
					self.releaseKeys[key].func()
				end 
			end

			if(inputType == "hold") then
				if(self.holdKeys[key]) then
					print("hold this stuff")
					self.holdKeys[key].func()
				end 
			end 




			if(data.type == "press") then
				self.pressKeys[data.key] =
				{
					key = data.key,
					func = data.func,
					state = false
				}

			elseif(data.type == "release") then
				self.releaseKeys[data.key] =
				{
					key = data.key,
					func = data.func,
					state = false
				}

			elseif(data.type == "hold") then
				self.holdKeys[data.key] =
				{
					key = data.key,
					func = data.func,
					state = false
				}

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




-- MapObject
------------------------------------------------

-- test area
--[[

local Actions = {}
Actions.chat = 
{
-- has reaction
if(self:TargetHasReaction("chat") == false) then
	printDebug{"Cannot chat with " .. (self.actionTarget.name or "nothing"), "MapObject"}
	return false
end 

		if(self:TargetReactionAble("chat")) then
			print(self.actionTarget.reactions.chat.chat)
			return true
		end

		return false 

	end 

--]]

-- Notes
----------------------------
-- need to have a function that can create a shared space
-- by creating a link or table in the slot
-- that references the the objects in the space
-- but only creates such a table when necessary
-- otherwise all slots in the map must be dealt with as on table deep
-- and I dont think I really want to do that


-- Walk function is an example of how this should work
-- actions and accepts
-- objects have actions the use on other objects
-- objects have accepts that define if the action can be done to them
-- and how they should react

-- pattern --> action sub table of values to do over and over
-- path --> action sub table of values to complete and delete each step
-- pattern would be a very useful component for all object types
-- consider writing a more complete version of it

-- actions need to be refactored into their own file at some point
-- right now actions only work with MapObjects
-- but they should probly work for anything
-- anyway lets keep it simple and contained for now

-- Junk
--------------------------------
--[==[
self.map.map:Swap
{
	a = {x = self.x, y = self.y},
	b = {x = self.x + 1, y = self.y}
}

self.x = self.x + 1





	-- {actionName, b = object to use action on}
	function o:UseActionOn(data)
		o[data.actionName](data.b)
	end 


--self.actionTarget = self.map:Get(self.x + self.actions[actionName].x, self.y + self.actions[actionName].y)



		--[[
		self.actionTarget = self.map:Get(self.x + self.actions.walk.x, self.y + self.actions.walk.y)

		if(self.actionTarget == nil) then
			printDebug{"No target", "MapObject"}
			return false
		end 
		--]]


		--self.x = self.x + self.actions.walk.x
		--self.y = self.y + self.actions.walk.y

--self.actionTarget.x = self.actionTarget.x - self.actions.walk.x

--self.actionTarget.y = self.actionTarget.y - self.actions.walk.y


--b = {x = self.x + self.actions.walk.x, y = self.y + self.actions.walk.y}




	if(data.actions) then
		for i=1, #data.actions do	
			o.actions[data.actions[i]] = self.actions[data.actions[i]] or {}
		end 
	end 


	--local success = o[actionName](self)


	-- Old Action Functions
	--------------------------------

	-- walk action
	function o:walk()

		-- able to walk?
		if(self:TargetReactionAble("walk") == false) then
			
			printDebug{"Cannot walk on " .. (self.actionTarget.name or "nothing"), "MapObject"}

			-- change direction test
			-- this needs to be moved somewhere
			-- actions need to be a bit more complicated it seems
			-- and have changes that can be made upon failure
			self.direction.x = 0
			self.direction.y = 1

			return false

		end 		

		-- for now the objects swap places
		-- this is not the correct response in all cases
		-- but will fix later
		-- there needs to be 2 maps
		-- a terrain map and an object map
		-- or just a map that can hold 2 objects in a sigle slot --> yes :D
		self.mapWorld.map:Swap
		{
			a = {x = self.x, y = self.y},
			b = {x = self.x + self.direction.x, y = self.y + self.direction.y}
		}
	
		-- update pos values of self
		self.x = self.x + self.direction.x
		self.y = self.y + self.direction.y

		-- upate pos values of target
		-- to compensate for the swap
		if(self.actionTarget.x) then
			self.actionTarget.x = self.actionTarget.x - self.direction.x
		end 

		if(self.actionTarget.y) then
			self.actionTarget.y = self.actionTarget.y - self.direction.y
		end

		
		return true

	end 




	-- talk to target
	-- this is very basic at the moment
	-- in the future it will active a seperate Chat component
	function o:chat()

		-- cannot chat with target
		if(self:TargetHasReaction("chat") == false) then
			printDebug{"Cannot chat with " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end 

		if(self:TargetReactionAble("chat")) then
			print(self.actionTarget.reactions.chat.chat)
			return true
		end

		return false 

	end 

	-- move the target in the direction
	function o:push()
		if(self:TargetHasReaction("push") == false) then
			printDebug{"Cannot push " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end

		self.actionTarget.direction = self.direction
		self.actionTarget:UseAction("walk")

		return true
	end 


	function o:jumpOver()

		if(self:TargetReactionAble("jumpOver") == false) then
			printDebug{"Cannot jump over " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end

		local landTarget = self.mapWorld:Get(self.actionTarget.x + self.direction.x, self.actionTarget.y + self.direction.y)

		-- does landTarget exist? if not its probly outside the map
		if(landTarget == nil) then
			printDebug{"No landTarget for jump over", "MapObject"}
			print(self.actionTarget.x)
			return false
		end 

		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		self.mapWorld.map:Swap
		{
			a = {x = self.x, y = self.y},
			b = {x = self.actionTarget.x + self.direction.x, y = self.actionTarget.y + self.direction.y}
		}

		-- update pos values of self
		self.x = self.actionTarget.x + self.direction.x
		self.y = self.actionTarget.y + self.direction.y

	end 



	-- remove target from the map
	-- for now, fill space with default empty
	function o:kill()
		if(self:TargetReactionAble("kill") == false) then
			printDebug{"Cannot kill " .. (self.actionTarget.name or "nothing"), "MapObject"}
		end 		

		self.mapWorld.map:Remove{x = self.actionTarget.x, y = self.actionTarget.y}

		return true

	end 

	-- kills target and moves to the space it occupied
	function o:replace()

		if(self:TargetReactionAble("replace") == false) then
			printDebug{"Cannot replace " .. (self.actionTarget.name or "nothing"), "MapObject"}
		end 

		-- this funcition is unfinished
		-->FIX

	end 





	-- move this object to a specific pos in the map
	function o:jumpTo()

		-- dont think this is needed
		-- jumping doesnt use an action target
		--[[
		if(self:TargetReactionAble("jumpTo") == false) then
			printDebug{"Cannot jump to " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end
		--]]

		if(self.direction.x == self.x and self.direction.y == self.y) then
			printDebug{"Object in same position as jump to position", "MapObject"}
			return false			
		end

		-- is pos to jump to inside map?
		if(self.mapWorld.map:IsPosInBounds{x = self.direction.x, y = self.direction.y} == false) then
			printDebug{"Jump to positon is out of bounds", "MapObject"}
			return false	
		end 

		local landTarget = self.mapWorld:Get(self.direction.x, self.direction.y)

		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		local success = self.mapWorld.map:MoveTo
		{
			a = {x = self.x, y = self.y},
			b = {x = self.direction.x, y = self.direction.y}
		}

		if(success == false) then
			return false
		end

		return true
	end 


	-- move this object from its relative pos in the map to another pos
	function o:jumpFromHereTo()

		-- dont think this is needed
		-- jumping doesnt use an action target
		--[[
		if(self:TargetReactionAble("jumpTo") == false) then
			printDebug{"Cannot jump to " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end
		--]]

		local x = self.x + self.direction.x
		local y = self.y + self.direction.y

		-- already in same pos?
		if(self.x == x and self.y == y) then
			printDebug{"JumpFromHereTo pos is same as pos", "MapObject"}
			return false
		end 

		-- is pos to jump to inside map?
		if(self.mapWorld.map:IsPosInBounds{x = x, y = y} == false) then
			printDebug{"Jump to positon is out of bounds", "MapObject"}
			return false	
		end 

		local landTarget = self.mapWorld:Get(x, y)
		
		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		self.mapWorld.map:MoveTo
		{
			a = {x = self.x, y = self.y},
			b = {x = x, y = y}
		}

		return true

	end 






-- other
------------------------------

		-- target has reaction message?
		--[[
		if(self:TargetHasReaction(actionName)) then
			if(self.actionTarget.reactions[actionName].message) then
				printDebug{self.name .. self.actionTarget.reactions[actionName].message, "MapObject", 2}
			end 
		end
		--]]



		-- Test Actions with Simple AI
		-----------------------------------------
		-- this is one massive test area
		-- makes it so objects use actions on their own
		-- a full featured AI component will need
		-- to be developed at some point
		if(self.active.use) then

			self.active.waitCount = self.active.waitCount + 1

			if(self.active.waitCount > self.active.wait) then
				self.active.waitCount = 0
				
				-- Actions Test
				-------------------
				-- needs to be moved eventually
				--self:UseAction("chat")
				--self:UseAction("push")
				--self:UseAction("jumpOver")
				--self:UseAction("walk")
				--self:UseAction("kill")
				self.direction.x = 0
				self.direction.y = 0
				self:UseAction("jumpFromHereTo")


				self.active.use = false
				
				-- direaction pattern test
				-- needs to be moved eventually
				if(self.direction.pattern) then
					self.direction.pattern.index = self.direction.pattern.index + 1

					if(self.direction.pattern.index > #self.direction.pattern.steps) then
						self.direction.pattern.index = 1
					end

					local index = self.direction.pattern.index

					self.direction.x = self.direction.pattern.steps[index].x
					self.direction.y  = self.direction.pattern.steps[index].y

				end 

			end

		end 


--]]





-- DecrodedLerpLevel.lua

-- Description
----------------------------------------------------------
-- helped Decroded solve some lerp code stuff
-- No longer needed
-- nope this is complete fucking garbage
-->DELETE

---------------
-- Requires
---------------

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
local DrawToolsUI = require("DrawToolsUI")
local Panel = require("Panel")
local Box = require("Box")
local pawnGraphics = require("AnimationTest") -- animation test with new spriteStuff

-----------------------------------------


local Start = function()
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

return LerpLevel



-- Notes
------------------------------------------------------
































