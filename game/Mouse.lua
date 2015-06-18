-- Mouse.lua
-- stuff about the mouse and stuff



local Line = require("Line")
local Collision = require("Collision")

Mouse = {}


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

	----------------------------------
	-- Create
	----------------------------------

	-- object
	o.name = data.name or "..."
	o.oType = "Mouse"
	o.dataType = "Control Object"

	-- 
	o.totalDistanceTraveled = 0
	o.speed = {}
	o.speed.x = 0
	o.speed.y = 0


	o.x = love.mouse.getX()
	o.y = love.mouse.getY()

	o.lastX = o.x
	o.lastY = o.y


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
		name = o.oType,
		mouse = true,
		collisionList = {},
		parent = o
	}
	

	---------------------
	-- Get
	---------------------
	function o:GetX()
		--return love.mouse.getX()
		return self.x
	end

	function o:GetY()
		return self.y
	end 

	----------------------------------
	-- Functions
	----------------------------------
	function o:Update()
		self:UpdateMouseInfo()
		self:CalculateSpeed()
		self:LineTracer()
	end 

	-- draws fading line sections wherever the mouse goes
	-- this would be great to break off into its own component --> :D
	function o:LineTracer()

		--self.line.b.x = self.x
		--self.line.b.y = self.y

		-- test to see if mouse has moved from its last position
		local samePoint = self:HasMouseMoved()

		-- mouse in new pos?
		if(samePoint == false) then

			-- then create a tracer
			local l = Line:New
			{
				a = {x = self.lastX, y = self.lastY},
				b = {x = self.x, y = self.y},
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
			a = {x = self.x, y = self.y},
			b = {x = self.lastX, y = self.lastY}
		}

	end 

	-- how fast is the mouse moving?
	function o:CalculateSpeed()
		self.speed.x = math.abs(self.x - self.lastX) / 1
		self.speed.y = math.abs(self.y - self.lastY) / 1
	end


	-- update all information using love.mouse stuff
	function o:UpdateMouseInfo()
		if(self.updateMouseInfo == false) then
			return
		end 

		-- prev pos
		self.lastX = self.x
		self.lastY = self.y
		self.lastTime = love.timer.getTime()

		-- current pos
		self.x = love.mouse.getX()
		self.y = love.mouse.getY()
	end 


	-- debug info
	function o:PrintDebugText()
		
		DebugText:TextTable
		{
			{text = "", obj = "Mouse" },
			{text = "Name: " .. self.name},
			{text = "X: " .. self.x},
			{text = "Y: " .. self.y},
			{text = "SpeedX: " .. self.speed.x},
			{text = "SpeedY: " .. self.speed.y},
			{}

		}
		
	end


	----------
	-- Done!
	----------
	ObjectUpdater:Add{o}

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
		{text = "Wheel Down: " .. Bool:ToString(Mouse.wheelDown)}
	}

end 


ObjectUpdater:AddStatic(Mouse)







-- adding static vars for mouse
-- used to detect single clicks without the need for the love single click callback