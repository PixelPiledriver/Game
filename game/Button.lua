-- Button
-- click on it and it does stuff

local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")
local Collision = require("Collision")
local Color = require("Color")
local Point = require("Point")
local Value = require("Value")
local Shader = require("Shader")

local Button = {}

-- Static Vars
-----------------

Button.name = "Button"
Button.oType = "Static"
Button.dataType = "Hud Constructor" 

Button.totalCreated = 0
Button.defaultCreated = {x = 16, y = 500, width = 0, height = 0}
Button.lastCreated = Button.defaultCreated
Button.xSpace = 8
Button.ySpace = 8

Button.maxColumns = 7

Button.repeatFunction = 1

Button.buttonBeingDragged = false



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
	----------------
	-- Variables
	----------------

	-- info
	o.name = data.name or "..."
	o.oType = "Button"
	o.dataType = "HUD"

	-- pos

	local x = 0
	local y = 0
	if(Button.totalCreated == Button.maxColumns) then
		Button.lastCreated.x = Button.defaultCreated.x
		Button.lastCreated.y = Button.defaultCreated.y + Button.lastCreated.height + Button.ySpace
	end 

	o.x = data.x or Button.lastCreated.x + Button.lastCreated.width + Button.xSpace
	o.y = data.y or Button.lastCreated.y

	-- size
	o.width = data.width or 100
	o.height = data.height or 50

	-- rect
	o.useBox = data.useBox or false

	-- repeat
	o.repeatable = data.repeatable or false

	-- function
	o.func = data.func

	-- objects to use in the function run when button is pressed
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

	o.toggle = data.toggle or false     -- click once to set
	o.toggleState = false
	o.toggleName = data.toggleName or data.text

	--[[
	o.box =  Box:New
	{
		x = o.x,
		y = o.y,
		width = o.width,
		height = o.height
	}
	--]]


	-- collision --> this uses collision os
	-- need to also have a mouse based version
	o.collision = Collision:New
	{
		x = o.x,
		y = o.y,
		width = o.width,
		height = o.height,
		shape = "rect",
		name = o.name,
		collisionList = {"Mouse"},
		parent = o
	}

	-- text
	o.text = data.text or "Button"
	o.textColor = data.textColor and Color:Get("data.textColor") or Color:Get("black")

	-- graphics
	o.sprite = data.sprite or nil

	-- button
	o.hover = false

	-- clicked
	o.clicked = false
	o.lastClicked = false

	----------------
	-- Functions
	----------------
	function o:Update()

		-- move --> right click lets you move buttons
		-- intended to make testing easier
		self:ClickToMove()
		self:UpdateMove()


		-- click --> do button funcition
		self:ClickButton()
		self.hover = false
		self.lastClicked = self.clicked
		self.clicked = false

	end

	function o:Draw()
		love.graphics.setColor(Color:AsTable(self.textColor))
		love.graphics.printf(self.text, self.x, self.y + self.height/2 - self.height/6, self.width, "center")
	end

	function o:OnCollision(data)
		self.hover = true
	end 

	-- runs the functions for the button -----> b.func()
	function o:ClickButton()

		if(self.hover == true)then
			if(love.mouse.isDown("l")) then

				self.clicked = true

				if(self.lastClicked == false) then

					if(self.func) then

						-- button repeats more than once
						if(self.repeatable) then

							for i=1, Button.repeatFunction do
								if(self.funcObjectIndex == nil) then 
									self.func()
								else
									self.func(self.funcObjects) -- arguments go here
								end
							end

						-- button function runs only once
						else

							if(self.funcObjectIndex == nil) then 
								self.func()
							else
								self.func(self.funcObjects) -- arguments go here
							end

						end 

					-- toggle button
					elseif(self.toggle) then
			
						if(self.toggleState == false) then
							self.toggleState = true
						else 
							self.toggleState = false 			
						end 

						-- diplay state
						print(self.toggleState)

					-- no fucntion or toggle defined --> this button is useless
					else
						print("this button has no function")
					end 

				end

			end 
		end 

	end 

	function o:UpdateMove()
		if(self.move == false) then
			return 
		end 

		self.x = love.mouse.getX()
		self.y = love.mouse.getY()
		self.collision.x = math.abs(love.mouse.getX() - self.lastX)
		self.collision.y = math.abs(love.mouse.getY() - self.lastY)

	end 

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
			self.lastX = love.mouse.getX() - self.x
			self.lastY = love.mouse.getY() - self.y
		end 


		-- drop
		if(self.move == true and love.mouse.isDown("r") == false) then
			self.move = false
			Button.buttonBeingDragged = false
		end 

	end 

	function o:PrintDebugText()


		local parent = self.parent and self.parent.name or "no parent"		

		DebugText:TextTable
		{
			{text = "", obj = "Button"},
			{text = "Button"},
			{text = "-----------"},
			{text = "Width: " .. self.width},
			{text = "Height: " .. self.height},
			{text = "Function: " .. self.text},
			{text = "Pos: {" .. self.x .. ", " .. self.y .. "}"},
		}

	end 

	ObjectUpdater:Add{o}
	Button.totalCreated = Button.totalCreated + 1



	if(data.saveAsLast == nil) then
		Button.lastCreated = o
	end 

	return o
end 



-------------------------------------
-- Useful Buttons
-------------------------------------





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
		data.pix:CreateTexture()
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
		data.pix:SaveToFileByIndex()
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



---------------------
-- Static Functions
---------------------
function Button:PrintDebugText()	
	DebugText:TextTable
	{
		{text = "", obj = "ButtonStatic"},
		{text = "Button Static"},
		{text = "-------------------------"},
		{text = "RepeatFunction: " .. Button.repeatFunction},
	}
end 

ObjectUpdater:AddStatic(Button)


-----------------------------
-- Button Library
-----------------------------
-- premade buttons go here that can be deployed into any scene
-- buttons need and extra variable that lets you pass in an object for them to work on
-- assuming they need one
-- objects needed for buttons to works will be genericized into a table maybe?


return Button



-- Notes
-----------------------------
-- need to add toggle buttons
	-- for tools
	-- buttons you can click once and have them be selected until you click another button
	-- they could be part of a "Toggle Group" so that when one is clicked the last selected pops up
	-- and only one can be selected at a time