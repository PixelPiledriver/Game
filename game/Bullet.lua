-- simple bullet


local ObjectUpdater = require("ObjectUpdater")
local Collision = require("Collision")

local Bullet = {}


-- create

function Bullet:New(data)

	local object = {}

	--------------
	-- Variables
	--------------
	object.frame = data.frame or nil
	

	object.lifespan = data.lifespan or -1

	-- pos
	object.x = data.shooter.x + data.shooter.xShootPos
	object.y = data.shooter.y + data.shooter.yShootPos

	-- bullet stats
	object.speed = data.speed or 10
	object.damage = data.damage or 1

	object.type = "bullet"

	-- collision
	object.collision = Collision:New
	{
		name = data.shooter.playerColor .. "Bullet",
		parent = object,
		width = object.frame.width,
		height = object.frame.height,
		collisionList = data.collisionList or nil,
		oneCollision = true
	}



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
		end

		if(self.lifespan == 0) then
			ObjectUpdater:Destroy(self)
		end

	end 

	function object:Update()
		self:Move()
		self:Life()
	end

	function object:Draw()
		self.frame:Draw(self)
	end 

	---------------
	-- Collision
	---------------


	-- need to put in check for type and if it should collide or not
	function object:OnCollision(data)
		self.lifespan = 0
	end 

	-- add new object to updater
	ObjectUpdater:Add{object}

	-- done
	return object

end 













return Bullet