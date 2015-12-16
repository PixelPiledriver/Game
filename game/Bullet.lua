-- Bullet.lua
-->OLD

-- Purpose
----------------------------
-- simple bullet


------------------
-- Requires
------------------
local Collision = require("Collision")


---------------------------------------------------------------------------

local Bullet = {}

----------------
-- Static Info
----------------
Bullet.Info = Info:New
{
	objectType = "Bullet",
	dataType = "Game",
	structureType = "Static"
}

function Bullet:New(data)

	---------------------
	-- Create
	---------------------

	local o = {}

	------------------
	-- Object Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Bullet",
		dataType = "Game",
		StructureType = "Object"
	}

	
	----------------
	-- Vars
	----------------

	if(data.bulletType) then
		
		o.frame = data.frame
		o.bulletType = data.bulletType

		-- pos
		o.x = data.shooter.x + data.shooter.xShootPos
		o.y = data.shooter.y + data.shooter.yShootPos

		-- direction
		o.xSpeed = data.direction.x or 0
		o.ySpeed = data.direction.y or 0

		-- bullet stats
		o.speed = o.bulletType.speed
		o.damage = o.bulletType.damage
		o.lifespan = o.bulletType.lifespan

	else

		-- sprite
		o.frame = data.frame or nil
		
		-- pos
		o.x = data.shooter.x + data.shooter.xShootPos
		o.y = data.shooter.y + data.shooter.yShootPos

		-- direction
		o.xSpeed = data.xSpeed or 0
		o.ySpeed = data.ySpeed or 0

		-- bullet stats
		o.speed = data.speed or 10
		o.damage = data.damage or 1
		o.lifespan = data.lifespan or -1
	end


	---------------
	-- Collision
	---------------

	o.collision = Collision:New
	{
		name = data.shooter.playerColor .. "Bullet",
		parent = o,
		width = o.frame.width,
		height = o.frame.height,
		collisionList = data.collisionList or nil,
		oneCollision = true,
		visible = false
	}


	function o:OnCollision(data)
		self.lifespan = 0
	end 

	--------------
	-- Functions
	--------------

	function o:Move()
		self.x = self.x + (self.xSpeed * self.speed)
		self.y = self.y + (self.ySpeed * self.speed)
	end 

	function o:Life()
		if(self.lifespan == -1) then
			return
		end 

		if(self.lifespan > 0) then
			self.lifespan = self.lifespan - 1
		end

		if(self.lifespan == 0) then
			ObjectManager:Destroy(self)
		end

	end 

	-->???
	function o:OutOfBounds()
	end 

	function o:Update()
		self:Move()
		self:Life()
		self:OutOfBounds()
	end

	function o:Draw()
		self.frame:Draw(self)
	end

	function o:Destroy()
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.collision)
	end 


	----------
	-- End
	----------
	
	ObjectManager:Add{o}

	return o

end 


---------------
-- Static End
---------------

ObjectManager:AddStatic(Bullet)

return Bullet



-- Notes
---------------------------------------
-- old game code that needs to be looked over