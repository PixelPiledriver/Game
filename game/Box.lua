-- simple test object

-- static of object
-- use to create more instances
local Box = {}


-- create instance
function Box:New(data)

	----------
	-- Create
	----------
	local object = {}

	object.x = data.x or 100
	object.y = data.y or 100
	object.width = data.width or 32
	object.height = data.height or 32
	object.color = data.color or {255,255,255,255}
	object.speed = data.speed or 5

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
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
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








return Box