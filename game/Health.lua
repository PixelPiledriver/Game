-- Health.lua
-- health component for objects that need to take damage

local ObjectUpdater = require("ObjectUpdater")

local Health = {}

------------------
-- Static Vars
------------------

Health.name = "Health"
Health.oType = "Static"
Health.dataType = "Component Constructor"

function Health:New(data)

	-------------
	-- Create
	--------------
	local o = {}

	o.name = data.name or "???"
	o.type = "Health"
	o.dataType = "Component"

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
		printDebug{"fucking dead!", "Health"}
	end 

	function o:GetHealth()
		return self.hp
	end 

	return o

end 





ObjectUpdater:AddStatic(Health)

return Health