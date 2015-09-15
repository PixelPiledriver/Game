-- Button.lua
-->CLEAN

-- Purpose
----------------------------
-- Clickable object that can run a function or act as a toggle

------------------
-- Requires
------------------
local Box = require("Box")
local Collision = require("Collision")
local Color = require("Color")
local Point = require("Point")
local Value = require("Value")
local Shader = require("Shader")
local Pos = require("Pos")
local Size = require("Size")
local MouseHover = require("MouseHover")
local MouseDrag = require("MouseDrag")
local Draw = require("Draw")
local Text = require("Text")
local Link = require("Link")



---------------------------------------------------------------------------

local Button = {}

------------------
-- Static Info
------------------
Button.Info = Info:New
{
	objectType = "Button",
	dataType = "User Interface",
	structureType = "Static"
}

------------------
-- Static Vars
------------------
Button.totalCreated = 0

Button.defaultCreated = {Pos = {x = 16, y = 500}, Size = {width = 0, height = 0}}
Button.lastCreated = Button.defaultCreated
Button.saveAsLast = true
Button.xSpace = 8
Button.ySpace = 8

Button.repeatFunction = 1

Button.buttonBeingDragged = false

-- if a sprite is defined text will not draw
-- not sure which is better so this default can be changed
Button.textOnSpriteDefault = false


---------------------------
-- Static Functions
---------------------------

function Button:DefaultLast()
	self.lastCreated = self.defaultCreated
end 

-- {table, table}
function Button:ActionButton(data, funcObjects)
	local b = Button:New(data)

	for i=1, #b.funcObjectIndex do
		b.funcObjects[b.funcObjectIndex[i]] = funcObjects[b.funcObjectIndex[i]]
	end

end 


-- {x, y, width, height, useBox = bool, repeatable = bool, actionObjects = table}
function Button:New(data)

	local o = {}

	------------------
	-- Object Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Button",
		dataType = "User Interface",
		structureType = "Object"
	}

	---------------
	-- Components
	---------------

	local x = data.x or Button.lastCreated.Pos.x + Button.lastCreated.Size.width + Button.xSpace
	local y = data.y or Button.lastCreated.Pos.y

	-- Pos
	o.Pos = Pos:New
	{
		x = x,
		y = y
	}

	-- Size
	o.Size = Size:New
	{
		width = data.width or 100,
		height = data.height or 50
	}

	o.Draw = Draw:New
	{
		parent = o,
		layer = "Hud"
	}

	-------------
	-- Vars
	-------------

	-- this should not be here
	-- needs to be a feature of PrintDebugText
	-- needs to create a sup components for objects just like everything else
	o.printDebugTextActive = data.printDebugTextActive or false

	-- rect
	o.useBox = data.useBox or false

	-- repeat
	o.repeatable = data.repeatable or false

	-- function
	o.func = data.func or nil

	-- function objects --> objects to use in data.func
	if(data.funcObjects) then

		o.funcObjectIndex = data.funcObjects or nil
		o.funcObjects = {}

		for i=1, #o.funcObjectIndex do
			o.funcObjects[o.funcObjectIndex[i]] = nil
		end 

	end
	
	-- flags
	o.moveable = true    								-- can be moved
	o.move = false       								-- currently being moved
	o.draw = true

	-- toggle
	o.toggle = data.toggle or false     -- click once to set --> this is the button type not state
	o.toggleState = false
	o.toggleName = data.toggleName or data.text

	-- functions for toggle type buttons
	o.toggleOnFunc = data.toggleOnFunc or nil
	o.toggleOffFunc = data.toggleOffFunc or nil

	-----------
	-- Text
	-----------

	o.text = Text:New
	{
		text = data.text or "Button",
		color = data.textColor and Color:Get("data.textColor") or Color:Get("black"),
		alignment = "center",
		displayWidth = o.Size.width,
		displayHeight = o.Size.height
	}

	Link:Simple
	{
		a = {o.text, "Pos", "x"},
		b = {o, "Pos", "x"},
	}

	Link:Simple
	{
		a = {o.text, "Pos", "y"},
		b = {o, "Pos", "y"},
	}

	o.text.active = data.drawText or true

	--------------
	-- Graphics
	--------------
	
	-- sprite
	o.sprite = data.sprite or nil

	-- size to sprite
	-- fit button to the sprite size
	if(o.sprite) then
		o.sizeToSprite = data.sizeToSprite or true
	else
		o.sizeToSprite = false
	end

	-- change vars to fit sprite
	if(o.sizeToSprite) then
		o.Size.width = o.sprite.Size.width
		o.Size.height = o.sprite.Size.height
		o.text.displayWidth = o.Size.width
	end 

	-- link sprite to button
	if(o.sprite) then

		Link:Simple
		{
			a = {o.sprite, "Pos", "x"},
			b = {o, "Pos", "x"}
		}

		Link:Simple
		{
			a = {o.sprite, "Pos", "y"},
			b = {o, "Pos", "y"}
		}

	end

	-- hide text if sprite is used --> not always wanted so use default for now
	if(o.sprite) then
		o.text.Draw.active = Button.textOnSpriteDefault
	end 

	-- color --> colorizes the sprite of button in differnt states
	o.color = Color:Get("white")
	o.colors = 
	{
		idle = Color:Get("white"),
		hover = Color:Get("orange"),
		click = Color:Get("green"),
		toggleFalse = Color:Get("white"),
		toggleTrue = Color:Get("red")
	}


	---------------
	-- Collision
	---------------
	-- this uses collision obejcts
	-- a mouse based version with no collision might be good at some point :O
	o.collision = Collision:New
	{
		x = o.Pos.x,
		y = o.Pos.y,
		width = o.Size.width,
		height = o.Size.height,
		shape = "rect",
		name = o.name,
		collisionList = {"Mouse"},
		parent = o
	}

	Link:Simple
	{
		a = {o.collision, "Pos", "x"},
		b = {o, "Pos", "x"}
	}

	Link:Simple
	{
		a = {o.collision, "Pos", "y"},
		b = {o, "Pos", "y"}
	}


	-----------------------------
	-- Mouse Interaction
	-----------------------------

	-- idle, hover, click
	o.state = "idle"

	-- clicked
	o.clicked = false
	o.lastClicked = false

	-- mouse drag --> being coverted to a component
	o.offsetFromMouseX = 0
	o.offsetFromMouseY = 0


	-- mouse over button
	o.hover = MouseHover:New
	{
		parent = o,
	}

	-- right click to move buttons
	o.drag = MouseDrag:New
	{
		parent = o,
		mouseButton = "r"
	}

	----------------------
	-- Object Functions
	----------------------
	function o:Update()

		self:OnNoCollision()
		self:ColorUpdate()
		self:ClickButton()

		-- clear vars from last frame
		self.hover.isHovering = false
		--self.state = "idle"
		self.lastClicked = self.clicked
		self.clicked = false

	end

	function o:ToggleDraw()
		self.collision.Draw:ToggleDraw()
		self.text:ToggleActive()
		self.sprite.Draw:ToggleDraw()
	end 

	function o:DrawCall()
	end

	function o:OnCollision(data)
		self.hover.isHovering = true
		self.state = "hover"
	end 

	function o:OnNoCollision()
		if(self.collision.collidedLastFrame == true) then
			return
		end

		self.state = "idle"
	end 

	function o:ColorUpdate()

		self.color = self.colors[self.state]

		if(self.sprite) then
			self.sprite.color = self.color
			if(self.toggleState) then
				self.sprite.color = self.colors["toggleTrue"]
			end
		end 

	end 

	-- runs the functions for the button -----> b.func()
	function o:ClickButton()

		local wasClicked = false

		if(self.hover.isHovering == true)then
			if(Mouse:SingleClick("l")) then --> single click fixed
			--if(love.mouse.isDown("l")) then

				self.clicked = true

				if(self.lastClicked == false) then

					if(self.func) then

						-- button type = function repeats more than once
						if(self.repeatable) then

							for i=1, Button.repeatFunction do
								if(self.funcObjectIndex == nil) then 
									self.func()
								else
									self.func(self.funcObjects) -- arguments go here
								end
							end

							wasClicked = true

						-- button type = function runs only once
						else

							if(self.funcObjectIndex == nil) then 
								self.func()
							else
								self.func(self.funcObjects) -- arguments go here
							end

							wasClicked = true

						end 

					-- toggle button
					elseif(self.toggle) then
			
						if(self.toggleState == false) then
							self.toggleState = true

							-- run toggle on function
							if(self.toggleOnFunc) then
								self:toggleOnFunc()
							end

						else 
							self.toggleState = false 			

							-- run toggle off function
							if(self.toggleOffFunc) then
								self:toggleOffFunc()
							end 

						end 

						wasClicked = true

					-- no fucntion or toggle defined --> this button is useless --> but can change in appearance
					else
						print("this button has no function")

						wasClicked = true
					end 

				end

			end 
		end 

		if(wasClicked) then
			self.state = "clicked"
		end 

	end 



	function o:PrintDebugText()

		if(self.printDebugTextActive == false) then
			return
		end 

		local parent = self.parent and self.parent.name or "no parent"

		local toggleInfo = nil
		if(self.toggle) then
			toggleInfo = Bool:ToString(self.toggleState) 
		else
			toggleInfo = "none"
		end 

		DebugText:TextTable
		{
			{text = "", obj = "Button"},
			{text = "Button"},
			{text = "-----------"},
			{text = "Name: " .. self.Info.name},
			{text = "Width: " .. self.Size.width},
			{text = "Height: " .. self.Size.height},
			{text = "Function: " .. self.text.text},
			{text = "Pos: {" .. self.Pos.x .. ", " .. self.Pos.y .. "}"},
			{text = "Toggle: " .. toggleInfo},
			{text = "State: " ..self.state}
		}

	end 


	----------
	-- End
	----------

	-- add object to list
	ObjectUpdater:Add{o}
	Button.totalCreated = Button.totalCreated + 1

	-- store as most recent button created
	if(Button.saveAsLast == true) then
		Button.lastCreated = o
	end 

	-- new Button created
	return o

end 



-----------------------------
-- Button Library
-----------------------------

-- useful buttons go here that can be deployed into any scene
-- pass these as a table to Button:New 
--> Button:New(Button.buttonName)

Button.createPoint = 
{
	repeatable = true,
	text = "Create Point",
	func = function()
		local point = Point:New
		{
			pos = Value:GetTable
			{
				x = Value:Range{min = 0, max = love.window.getWidth()},
				y = Value:Range{min = 0, max = love.window.getHeight()},
				z = Value:Value(0),
				index = {"x", "y", "z"},

				speed = Value:GetTable
				{
					x = Value:FloatRange{min = -4, max = 4},
					y = Value:FloatRange{min = -4, max = 4},
					index = {"x", "y"}
				},

			},

			life = (Value:Range{min = 10, max = 100}):Get(),
			color = "random"
		}
	end
}

-- increases the number of times
-- the next button press will be executed
-- if the button has Repeat enabled
Button.repeatFunctionUp = 
{
	text = "Repeat Func Up",
	func = function()
		Button.repeatFunction = Button.repeatFunction + 1
	end
}

-- decreases the number of times
-- the next button press will be executed
-- if the button has Repeat enabled
Button.repeatFunctionDown = 
{
	text = "Repeat Func Down",
	func = function()
		Button.repeatFunction = Button.repeatFunction - 1
	end
}

-- Ends the application
Button.quit =
{
  text = "Quit",
	func = function()	  
		love.event.quit()
	end
}


Button.valueTest = 
{
	text = "Value Test",
	func = function()
		print( (Value:Random{values ={1,4,5,44,223,00}}):Get() )
	end
}

Button.wash =
{
	text = "Wash",
	funcObjects = {"pix"},
	func = function(data)
		data.pix:Wash()
		data.pix:CreateTexture()
	end 
}

Button.randPixels =
{
	text = "Rand Pixels",
	funcObjects = {"pix"},
	func = function(data)
		--data.pix:Clear()
		data.pix:AllRandomFromPalette()
		data.pix:RefreshTexture()
	end 
}

Button.randPalette =
{
	text = "Rand Palette",
	funcObjects = {"pal"},
	func = function(data)
			data.pal:Interpolated
			{
				colors = {"random", "random", "random"},
				indexes = {1, 4, 7}
			}
	end 
}

Button.savePixels =
{
	text = "Save Pixels",
	funcObjects = {"pix"},
	func = function(data)
		data.pix:SaveToFile()
	end
}

-- {a}
Button.actionTest =
{
	text = "ActionObject",
	funcObjects = {"a"},
	func = function(data)
		data.a = data.a + 5
		print(data.a)
	end 
}

----------------------------------------------------------------
-- Broken Buttons
----------------------------------------------------------------
Button.britUp = 
{
	text = "Brit Up",
	func = function()
		Shader.brightness = Shader.brightness + 0.1
	end 
}

Button.britDown = 
{
	text = "Brit Down",
 	func = function()
 		Shader.brightness = Shader.brightness - 0.1
	end 
}

Button.debugTextOnOff =
{
	text = "DebugText",
	func = function()
		DebugText.active = false
	end 
}

function Button:PrintDebugText()	
	DebugText:TextTable
	{
		{text = "", obj = "ButtonStatic"},
		{text = "Button Static"},
		{text = "-------------------------"},
		{text = "RepeatFunction: " .. Button.repeatFunction},
	}
end 


---------------
-- Static End
---------------


ObjectUpdater:AddStatic(Button)

return Button



-- Notes
-----------------------------
-- need to add toggle buttons --> got this sort of working :D
	-- for tools
	-- buttons you can click once and have them be selected until you click another button
	-- they could be part of a "Toggle Group" so that when one is clicked the last selected pops up
	-- and only one can be selected at a time


	-- NOTE: make table of sprites for different states of button
	-- o.sprites = {idle, hover, click, toggleTrue, toggleFalse} --> something like that
	-- also change sprite color on states
	-- might do that as its own table so that it is flexible and not intertwined
	-- o.colors = {idle, hover, click, toggleTrue, toggleFalse}

	-- Table of states by name as well


	-- Toggle buttons need to have 2 functions
	-- one for toggling on and one for toggling off
	-- this way when they are clicked a second time they can reverse whatever it is that they did
	-- or do something entirely different


	-- buttons can be roll clicked --> hold down mouse button and then hover and click will instantly happen
	-- this is a good feature --> like visibility in photoshop, but needs to be controlled
	-- as of right now it is accidental
	-- need to add an option for it
	-- Single click added to mouse
	-- now just need to make it optional for buttons to require single click or be able to roll click


	-- this is worked on i think with action buttons <--- need to look into that
	-- buttons need and extra variable that lets you pass in an object for them to work on
	-- assuming they need one
	-- objects needed for buttons to works will be genericized into a table maybe?

	-->FIXED?
	-- draw text for button? --> if button has a sprite, defaults to not draw
	-- this should not always be the case, if button has a backdrop and text goes on top
	-- will need to fix this issue at a later time :P


-- Junk
-----------------------

	-- pos

	--local x = 0
	--local y = 0

	-- need to fix max columns
	-- it doesnt work correctly at all
	-- was just a quick fix
	--[[

	if(Button.totalCreated == Button.maxColumns) then
		Button.lastCreated.Pos.x = Button.defaultCreated.Pos.x
		Button.lastCreated.Pos.y = Button.defaultCreated.Pos.y + Button.lastCreated.height + Button.ySpace
	end 
	--]]

	-- old text

	-- need to convert to Text
	--[[
	if(self.drawText) then
		love.graphics.setColor(Color:AsTable(Color:Get(self.text.color)))
		--love.graphics.printf(self.text, self.Pos.x, self.Pos.y + self.Size.height/2 - self.Size.height/6, self.Size.width, "center")
		love.graphics.printf(self.text, self.Pos.x, self.Pos.y + self.Size.height/2, self.Size.width, "center")
	end
	--]]

	----------------------------------------
	-- old mouse drag
	-------------------------------------

--[[

	-- called in update
	self:UpdateMoveToMouse()
	self:ClickToDrag()

	function o:UpdateMoveToMouse()
		if(self.move == false) then
			return 
		end 

		self.Pos.x = love.mouse.getX() - self.offsetFromMouseX
		self.Pos.y = love.mouse.getY() - self.offsetFromMouseY
	end 

	-- right click to drag a button
	function o:ClickToDrag()

		-- right click on button? set button to move
		if(self.hover.isHovering == true and Button.buttonBeingDragged == false) then
			if(love.mouse.isDown("r")) then
				self.move = true
				Button.buttonBeingDragged = true

				-- set offset
				self.offsetFromMouseX = love.mouse.getX() - self.Pos.x
				self.offsetFromMouseY = love.mouse.getY() - self.Pos.y
			end 
		end 

		-- let go of button? drop
		if(self.move == true and love.mouse.isDown("r") == false) then
			self.move = false
			Button.buttonBeingDragged = false

			-- reset offset
			self.offsetFromMouseX = 0
			self.offsetFromMouseY = 0

		end 

	end 



	


]]