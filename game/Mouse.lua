-- Mouse.lua

-- Purpose
------------------------------
-- Handles mouse input and features

-------------
-- Requires
-------------
local Line = require("Line")
local Collision = require("Collision")
local Camera = require("Camera")
local Link = require("Link")
local Pos = require("Pos")
----------------------------------------------------------
-- global
Mouse = {}

-----------------
-- Static Info
-----------------
Mouse.Info = Info:New
{
	objectType = "Mouse",
	dataType = "Input",
	structureType = "Static"	
}

---------------------
-- Static Vars
---------------------

-- buttons
Mouse.lastClickButton =
{
	l = false,
	r = false,
	m = false,
	wu = false,
	wd = false
}

Mouse.clickButton =
{
	l = false,	-- left click
	r = false,	-- right click
	m =	false,	-- middle click
	wu = false, -- wheel up
	wd = false, -- wheel down
}



-- wheel
Mouse.lastWheelUp = false
Mouse.lastWheelDown = false
Mouse.wheelUpSkip = false
Mouse.wheelDownSkip = false
Mouse.wheelUp = false
Mouse.wheelDown = false

---------------------
-- Static Functions
---------------------

function Mouse:Update()
	self:TrackClicks()
end 

-- from love call back
-- used to get mouse wheel input
-- only is called back when a button is pressed
function Mouse:MousePressed(x,y,button)

	-- reset wheel
	self.wheelUp = false
	self.wheelDown = false

	-- clicks
	if(button == "l") then
		printDebug{"Mouse: Left Click", "Mouse"}
	end
	
	if(button == "r") then
		printDebug{"Mouse: Right Click", "Mouse"}
	end 

	if(button == "m") then
		printDebug{"Mouse: Middle Click", "Mouse"}
	end 

	-- mouse wheel
	if(button == "wu") then
		self.wheelUp = true
 		printDebug{"Mouse: Wheel Up", "Mouse"}
	end 

	if(button == "wd") then
		self.wheelDown = true
 		printDebug{"Mouse: Wheel Down", "Mouse"}
	end


end 


function Mouse:TrackClicks()

	self.lastClickButton.l = self.clickButton.l
	self.lastClickButton.r = self.clickButton.r
	self.lastClickButton.m = self.clickButton.m

	-- buttons
	self.clickButton.l = false
	self.clickButton.r = false
	self.clickButton.m = false

	-- wheel
	if(self.wheelUp and self.wheelUpSkip == false) then
		self.wheelUpSkip = true
	else
		self.wheelUp = false
		self.wheelUpSkip = false
	end 

	self.lastWheelUp = self.wheelUp

	if(self.wheelDown and self.wheelDownSkip == false) then
		self.wheelDownSkip = true
	else 
		self.wheelDown = false
		self.wheelDownSkip = false
	end 

	self.lastWheelDown = self.wheelDown





	
	if(love.mouse.isDown("l")) then
		self.clickButton.l = true
	end

	if(love.mouse.isDown("r")) then
		self.clickButton.r = true
	end 

	if(love.mouse.isDown("m")) then
		self.clickButton.m = true
		--print("middle click")
	end

end 

-- reads the mouse only once
-- this can be removed for the MousePressed callback I think
function Mouse:SingleClick(mouseButton)

	if(self.clickButton[mouseButton] and self.lastClickButton[mouseButton] == false) then
		return true
	else
		return false
	end

end


 
function Mouse:New(data)
	
	local o =  {}

	----------------
	-- Object Info
	----------------
	
	-- object
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Mouse",
		dataType = "Input",
		structureType = "Object"
	}

	o.name = data.name or "..."
	o.objectType = "Mouse"
	o.dataType = "Control Object"

	o.totalDistanceTraveled = 0
	o.speed = {}
	o.speed.x = 0
	o.speed.y = 0


	o.Pos = Pos:New
	{
		x = love.mouse.getX(),
		y = love.mouse.getY()
	}
	--o.x = love.mouse.getX()
	--o.y = love.mouse.getY()

	o.lastX = o.Pos.x
	o.lastY = o.Pos.y

	-- pos based on current camera
	o.xView = nil
	o.yView = nil
	o.lastXView = nil
	o.lastYView = nil


	o.updateMouseInfo = true

	--o.line = Line:New{drain = false}

	o.width = data.width or 8
	o.height = data.height or 8

	-- collision for mouse cursor
	o.collision = Collision:New
	{
		x = -o.width/2,
		y = -o.height/2,
		width = o.width,
		height = o.height,
		shape = "rect",
		name = o.objectType,
		collisionList = {},
		parent = o
	}


	Link:Simple
	{
		a = {o.collision, "Pos", "x"},
		b = {o, "Pos", "x"},
		offsets =
		{
			{object = {Camera.selectedCamera.Pos, "x"}}
		}
	}

	Link:Simple
	{
		a = {o.collision, "Pos", "y"},
		b = {o, "Pos", "y"},
		offsets =
		{
			{object = {Camera.selectedCamera.Pos, "y"}}
		}
	}
	

	---------------------
	-- Get
	---------------------
	function o:GetX()
		return self.Pos.x
	end

	function o:GetY()
		return self.Pos.y
	end 

	----------------------------------
	-- Functions
	----------------------------------
	function o:Update()
		self:FollowCamera()
		self:UpdateMouseInfo()
		self:CalculateSpeed()
		self:LineTracer()
	end 

	function o:FollowCamera()
		self.xView = Camera.selectedCamera.Pos.x + self.Pos.x
		self.yView = Camera.selectedCamera.Pos.y + self.Pos.y
	end 

	-- update all information using love.mouse stuff
	function o:UpdateMouseInfo()
		if(self.updateMouseInfo == false) then
			return
		end 

		-- prev pos
		self.lastX = self.Pos.x
		self.lastY = self.Pos.y
		self.lastTime = love.timer.getTime()
		self.lastXView = self.xView
		self.lastYView = self.yView

		-- current pos
		self.Pos.x = love.mouse.getX()
		self.Pos.y = love.mouse.getY()

		self.xView = love.mouse.getX() + Camera.selectedCamera.Pos.x
		self.yView = love.mouse.getY() + Camera.selectedCamera.Pos.y
	end 

	-- how fast is the mouse moving?
	function o:CalculateSpeed()
		self.speed.x = math.abs(self.Pos.x - self.lastX) / 1
		self.speed.y = math.abs(self.Pos.y - self.lastY) / 1
	end

	-- draws fading line sections wherever the mouse goes
	-- this would be great to break off into its own component --> :D
	function o:LineTracer()

		--self.line.b.x = self.Pos.x
		--self.line.b.y = self.Pos.y

		-- test to see if mouse has moved from its last position
		local samePoint = self:HasMouseMoved()

		-- mouse in new pos?
		if(samePoint == false) then

			-- then create a tracer
			local l = Line:New
			{
				a = {x = self.lastXView, y = self.lastYView},
				b = {x = self.xView, y = self.yView},
				life = 20,
				fade = true,
				fadeWithLife = true
			}

		end


	end

	-- has the mouse moved since last frame?
	function o:HasMouseMoved()

		return Math:TestEqualityPoints
		{
			a = {x = self.Pos.x, y = self.Pos.y},
			b = {x = self.lastX, y = self.lastY}
		}

	end 


	-- debug info
	function o:PrintDebugText()
		
		DebugText:TextTable
		{
			{text = "", obj = "Mouse" },
			{text = "Name: " .. self.name},
			{text = "X: " .. self.Pos.x},
			{text = "Y: " .. self.Pos.y},
			{text = "SpeedX: " .. self.speed.x},
			{text = "SpeedY: " .. self.speed.y},
		}
		
	end

	function o:Destroy()
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.collision)
	end 


	----------
	-- End
	----------

	ObjectManager:Add{o}

	return o

end


function Mouse:PrintDebugText()

	DebugText:TextTable
	{
		{text = "", obj = "MouseStatic"},
		{text = "Mouse Static"},
		{text = "---------------"},
		{text = "Left Click: " .. Bool:ToString(Mouse.clickButton.l)},
		{text = "Right Click: " .. Bool:ToString(Mouse.clickButton.r)},
		{text = "Middle Click: " .. Bool:ToString(Mouse.clickButton.m)},
		{text = "Wheel Up: " .. Bool:ToString(Mouse.wheelUp)},
		{text = "Wheel Down: " .. Bool:ToString(Mouse.wheelDown)},
		{text = "X: " .. love.mouse.getX()},
		{text = "Y: " .. love.mouse.getY()},
	}

end 

-----------------
-- Static End
-----------------

ObjectManager:AddStatic(Mouse)




-- Notes
------------------------------------------

-- adding static vars for mouse
-- used to detect single clicks without the need for the love single click callback