-- basic object with sprite, input, etc

-- use to create more instances
local Player = {}


-- create instance
function Player:New(data)

	----------
	-- Create
	----------
	local object = {}

	object.sprite = data.sprite or nil
	object.x = data.x or 100
	object.y = data.y or 100
	object.width = data.width or 32
	object.height = data.height or 32
	object.color = data.color or {255,255,255,255}
	object.speed = data.speed or 5
	object.useFrame = data.useFrame or false
	object.frame = data.frame or nil
	object.sheet = data.sheet or nil
	object.angle = data.angle or 0
	object.xScale = data.xScale or 1
	object.yScale = data.yScale or 1

	-- controls
	object.keys =
	{
		left = data.keys and data.keys.left or "a",
		right = data.keys and data.keys.right or "d",
		up = data.keys and data.keys.up or "w",
		down = data.keys and data.keys.down or "s",
	}


	-------------
	-- Functions
	-------------
	function object:Draw()

		if(self.useFrame) then
			love.graphics.setColor(self.color)
			love.graphics.draw(self.sheet, self.frame, self.x, self.y, self.angle, self.xScale, self.yScale)
		else
			love.graphics.setColor(self.color)
			love.graphics.draw(self.sprite, self.x, self.y, self.angle, self.xScale, self.yScale)
		end 

	end 

	-- only used for press and release
	function object:Input(key)

	end 

	-- only used for down
	function object:RepeatedInput()

		-- simple controls
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


	return object

end 


return Player