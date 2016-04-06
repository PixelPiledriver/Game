-- BulletShot.lua

----------------------------------------------------
local BulletShot = {}


-------------------
-- Static Info
-------------------
BulletShot.Info = Info:New
{
	objectType = "BulletShot",
	dataType = "GameObject",
	structureType = "Static"
}


function BulletShot:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "BulletShot",
		dataType = "GameObject",
		structureType = "Object"
	}

	o.bullet = data.bullet

	o.bullet.Pos.x = data.x or 0
	o.bullet.Pos.y = data.y or 0

	--------------
	-- Vars
	--------------
	o.moveSpeed = data.speed or 1
	
	o.life = 0

	function o:Update()
		self.bullet.Pos.x = self.bullet.Pos.x + self.moveSpeed

		o.life = o.life + 1
		
		if(o.life >= 20) then
			ObjectManager:Destroy(o)
		end 

	end 

	function o:Destroy()
		ObjectManager:Destroy(self.bullet)
	end 

	--------------
	-- End
	--------------

	ObjectManager:Add{o}

	return o 

end 







ObjectManager:AddStatic(BulletShot)

return BulletShot