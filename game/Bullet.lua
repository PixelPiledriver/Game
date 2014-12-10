-- simple bullet


local ObjectUpdater = require("ObjectUpdater")
local Collision = require("Collision")

local Bullet = {}

----------------
-- Static Vars
----------------
Bullet.name = "Bullet"
Bullet.oType = "Static"
Bullet.dataType = "GameObject Constructor"

function Bullet:New(data)

	---------------------
	-- Create
	---------------------

	local object = {}

	-- object
	object.name = data.name or "???"
	object.oType = "Bullet"
	object.dataType = "GameObject"

	-- vars
	if(data.bulletType) then
		
		object.frame = data.frame
		object.bulletType = data.bulletType

		-- pos
		object.x = data.shooter.x + data.shooter.xShootPos
		object.y = data.shooter.y + data.shooter.yShootPos

		-- direction
		object.xSpeed = data.direction.x or 0
		object.ySpeed = data.direction.y or 0

		-- bullet stats
		object.speed = object.bulletType.speed
		object.damage = object.bulletType.damage
		object.lifespan = object.bulletType.lifespan

	else

		-- sprite
		object.frame = data.frame or nil
		
		-- pos
		object.x = data.shooter.x + data.shooter.xShootPos
		object.y = data.shooter.y + data.shooter.yShootPos

		-- direction
		object.xSpeed = data.xSpeed or 0
		object.ySpeed = data.ySpeed or 0

		-- bullet stats
		object.speed = data.speed or 10
		object.damage = data.damage or 1
		object.lifespan = data.lifespan or -1
	end



	--------------
	-- Collision
	---------------

	object.collision = Collision:New
	{
		name = data.shooter.playerColor .. "Bullet",
		parent = object,
		width = object.frame.width,
		height = object.frame.height,
		collisionList = data.collisionList or nil,
		oneCollision = true,
		visible = false
	}


	function object:OnCollision(data)
		self.lifespan = 0
	end 

	--------------
	-- Functions
	--------------

	function object:Move()
		self.x = self.x + (self.xSpeed * self.speed)
		self.y = self.y + (self.ySpeed * self.speed)
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

	function object:OutOfBounds()
		-- off screen

		-- right
		--if(self.x > )
		-- bottom
		-- left
		-- top
		

	end 

	function object:Update()
		self:Move()
		self:Life()
		self:OutOfBounds()
	end

	function object:Draw()
		self.frame:Draw(self)
	end 


	-- add new object to updater
	ObjectUpdater:Add{object}

	-- done
	return object

end 

ObjectUpdater:AddStatic(Bullet)

return Bullet