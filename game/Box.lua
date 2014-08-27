-- simple test object

-- static of object
-- use to create more instances
local ObjectUpdater = require("ObjectUpdater")
local Box = {}


-- create instance
function Box:New(data)

	----------
	-- Create
	----------
	local object = {}

	-- position
	object.x = data.x or 100
	object.y = data.y or 100
	object.speed = data.speed or 5
	object.move = false

	-- look
	object.width = data.width or 32
	object.height = data.height or 32
	object.color = data.color or {255,255,255,255}
	
	
	object.fill = data.fill or false
	object.draw = data.draw or true

	-- rotation
	object.angle = data.angle or 0
	object.rotatable = data.rotatable or false
	object.pivot = data.pivot or {x = 0.5, y = 0.5} -- 0 to 1 range
	object.spin = data.spin or 0

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
			--self.angle = self.angle - 0.1
		end 

		if(love.keyboard.isDown(self.keys.rotRight)) then
			self.spin = self.spin + 0.01 
			--self.angle = self.angle + 0.1
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


	function object:Update()

		self:Spin() 

	end 

	ObjectUpdater:Add{object}

	return object

end 








return Box