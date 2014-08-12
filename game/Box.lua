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

	object.x = data.x or 100
	object.y = data.y or 100
	object.width = data.width or 32
	object.height = data.height or 32
	object.color = data.color or {255,255,255,255}
	object.speed = data.speed or 5
	object.move = false
	object.fill = data.fill or false
	object.draw = data.draw or true

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

		if(self.draw == false) then
			return
		end

		if(self.fill == false) then
			love.graphics.setWireframe(true)
		end 

		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill", self.x, self.y - (self.z or 0), self.width, self.height)

		if(self.fill == false) then
			love.graphics.setWireframe(false)
		end 

	end 

	-- only used for press and release
	function object:Input(key)

	end 

	-- only used for down
	function object:RepeatedInput()

		if(self.move == false) then
			return
		end

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

	ObjectUpdater:Add{object}

	return object

end 








return Box