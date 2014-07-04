-- simple bullet


local ObjectUpdater = require("ObjectUpdater")

local Bullet = {}




-- create

function Bullet:New(data)

	local object = {}

	--------------
	-- Variables
	--------------
	object.frame = data.frame or nil
	object.speed = data.speed or 10

	object.lifespan = data.lifespan or -1

	-- pos
	object.x = data.shooter.x + data.shooter.xShootPos
	object.y = data.shooter.y + data.shooter.yShootPos



	--------------
	-- Functions
	--------------

	function object:Move()
		self.x = self.x + self.speed
	end 

	function object:Life()
		if(self.lifespan == -1) then
			return
		end 

		if(self.lifespan > 0) then
			self.lifespan = self.lifespan - 1

			if(self.lifespan == 0) then

				print("destroy")
				self.destroy = true
				ObjectUpdater.destroyObjects = true
			end

		end

	end 

	function object:Update()
		self:Move()
		self:Life()
	end

	function object:Draw()
		self.frame:Draw(self)
	end 

	-- add new object to updater
	ObjectUpdater:Add{object}

	-- done
	return object

end 













return Bullet