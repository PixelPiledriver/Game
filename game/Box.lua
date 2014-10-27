-- Box.lua
-- box/cube/square graphic object

local ObjectUpdater = require("ObjectUpdater")
local SinCounter = require("SinCounter")


local Box = {}



-- create instance
function Box:New(data)

	----------
	-- Create
	----------
	local object = {}

	-- other
	object.name = data.name or "???"
	object.type = "box"

	-- position
	object.x = data.x or 0
	object.y = data.y or 0
	object.xStart = object.x
	object.yStart = object.y
	object.speed = data.speed or 5
	object.move = false

	-- size
	object.width = data.width or 32
	object.height = data.height or 32

	-- color
	object.color = data.color or {255,255,255,255}
	
	-- draw
	object.fill = data.fill or false
	object.draw = data.draw or true

	-- rotation
	object.angle = data.angle or 0
	object.pivot = data.pivot or {x = 0.5, y = 0.5} -- 0 to 1 range
	object.spin = data.spin or 0

	if(data.spin) then
		object.rotatable = true
	else
		object.rotatable = false
	end 

	-- scale
	object.xScale = data.xScale or 1
	object.yScale = data.yScale or 1
	object.xScaleStatic = object.xScale
	object.yScaleStatic = object.yScale
	object.xScaleSpeed = data.xScaleSpeed or 0
	object.yScaleSpeed = data.yScaleSpeed or 0

	if(data.xScale or data.yScale) then
		object.scaleable = true
	else
		object.scaleable = false
	end 

	-- flip

	object.xFlip = SinCounter:New
	{
		speed = data.xFlip or 0,
		damp = 0.95
	}

	object.yFlip = SinCounter:New
	{
		speed = data.yFlip or 0,
		damp = 0.95
	}



	-- controls
	object.keys =
	{
		left = data.keys and data.keys.left or "a",
		right = data.keys and data.keys.right or "d",
		up = data.keys and data.keys.up or "w",
		down = data.keys and data.keys.down or "s",
		rotLeft = data.rotatable and data.keys and data.keys.rotLeft or "q",
		rotRight = data.rotatable and data.keys and data.keys.rotLeft or "e",
	}




	-------------
	-- Functions
	-------------

	function object:Draw()

		if(self.draw == false) then
			return
		end

		if(self.fill == false) then
			love.graphics.setWireframe(true)
		end 

		love.graphics.setColor(self.color)

		if(self.rotatable) then
			love.graphics.push()
			love.graphics.translate(self.x + (self.pivot.x * self.width), self.y + (self.pivot.y * self.height))
			love.graphics.scale(self.xScale, self.yScale)
			love.graphics.rotate(self.angle)
			love.graphics.translate(-self.x - (self.pivot.x * self.width), -self.y - (self.pivot.y * self.height))
			love.graphics.rectangle("fill", self.x, self.y - (self.z or 0), self.width, self.height)
			love.graphics.pop()
		else 
			love.graphics.rectangle("fill", self.x, self.y - (self.z or 0), self.width, self.height)
		end 

		if(self.fill == false) then
			love.graphics.setWireframe(false)
		end 

	end 

	-- only used for press and release
	function object:Input(key)

	end 

	function object:Move()

		if(self.move == false) then
			return
		end

		if(love.keyboard.isDown(self.keys.left)) then
			self.x = self.x - self.speed
		end 

		if(love.keyboard.isDown(self.keys.right)) then
			self.x = self.x + self.speed
		end 

		if(love.keyboard.isDown(self.keys.up)) then
			self.y = self.y - self.speed
		end 

		if(love.keyboard.isDown(self.keys.down)) then
			self.y = self.y + self.speed
		end

		

	end


	-- spin controls
	function object:Rotate()

		if(love.keyboard.isDown(self.keys.rotLeft)) then
			self.spin = self.spin - 0.01
		end 

		if(love.keyboard.isDown(self.keys.rotRight)) then
			self.spin = self.spin + 0.01 
		end 

	end 

	-- only used for down
	function object:RepeatedInput()

		self:Rotate()
		self:Move()

	end 


	-- rotation velocity
	function object:Spin()
		self.angle = self.angle + self.spin * 0.01
	end 

	-- flip like paper
	function object:Flip()

		--self.xScale = self.xScaleStatic * self.xFlip:Get()
		

		if(self.xFlip) then
			self.xScale = self.xFlip:Get()
		end

		if(self.yFlip) then
			self.yScale = self.yFlip:Get()
		end
		--print(self.xScale)


		--[[
		self.xScale = Math:Lerp
		{
			a = -self.xScaleStatic,
			b = self.xScaleStatic,
			t = self.xFlip:Get()
		}

		print(self.xScale)
		--]]

		--self.yScale = self.yFlip:Get()
	end

	function object:Scale()
		self.xScale = self.xScale + (self.xScaleSpeed * 0.01)
		self.yScale = self.yScale + (self.yScaleSpeed * 0.01)
		self.xScaleStatic = self.xScale
		self.yScaleStatic = self.yScale
	end 

	function object:Update()
		self:Spin() 
		self:Scale()
		self:Flip()
	end 

	
	function object:Destroy()
		if(self.xFlip) then
			ObjectUpdater:Destroy(self.xFlip)
		end 

		if(self.yFlip) then
			ObjectUpdater:Destroy(self.yFlip)
		end 

	end 

	ObjectUpdater:Add{object}

	return object

end 








return Box