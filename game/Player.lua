-- basic object with sprite, input, etc


local Animation = require("Animation")

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
	object.frame = data.frame or nil
	object.sheet = data.sheet or nil
	object.animation = data.animation or nil
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

		-- what type of graphic does the object have
		if(self.frame) then
			self.frame:Draw(self)
		elseif(self.animation) then
			self.animation:Draw(self)
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