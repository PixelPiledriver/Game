-- Health.lua
-->OLD

-- Purpose
-----------------------------------------
-- health component for objects that need to take damage

----------------------------------------------------------------------------------

local Health = {}

------------------
-- Static Info
------------------
Health.Info = Info:New
{
	objectType = "Health",
	dataType = "Game",
	structureType = "Static"
}

function Health:New(data)

	local o = {}

	------------------
	-- Object Info
	------------------
	o.Info = Info:New
	{ 
		name = data.name or "???",
		objectType = "Health",
		dataType = "Game",
		structureType = "Component"
	}

	o.max = data.max or 100
	o.min = data.min or 0
	o.start = data.start or 100
	o.hp = 100

	---------------
	-- Functions
	---------------
	function o:Damage(attack)
		self.hp = self.hp - attack.damage
		self:UpdateCheck()

		printDebug{self.hp, "Health"}

	end

	function o:UpdateCheck()
		if(self.hp < self.min) then 
			self.hp = self.min
		end

		if(self.hp > self.max) then 
			self.hp = self.max
		end 

	end 

	function o:Death()
		printDebug{"Dead!", "Health"}
	end 

	function o:GetHealth()
		return self.hp
	end 

	----------
	-- End 
	----------
	
	return o

end 


----------------
-- Static End
----------------

ObjectUpdater:AddStatic(Health)

return Health