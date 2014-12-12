-- Mouse.lua
-- stuff about the mouse and shit


local ObjectUpdater = require("ObjectUpdater")
local Line = require("Line")
local Collision = require("Collision")

local Mouse = {}

 
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

	-- collision
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

	function o:HasMouseMoved()

		return Math:TestEqualityPoints
		{
			a = {x = self.x, y = self.y},
			b = {x = self.lastX, y = self.lastY}
		}

	end 

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


	function o:PrintDebugText()
		
		DebugText:TextTable
		{
			{text = "", obj = "Mouse" },
			{text = "Name: " .. self.name},
			{text = "X: " .. self.x},
			{text = "Y: " .. self.y},
			{text = "SpeedX: " .. self.speed.x},
			{text = "SpeedY: " .. self.speed.y},

		}
		
	end



	----------
	-- Done!
	----------
	ObjectUpdater:Add{o}

end









return Mouse