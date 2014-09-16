-- Health.lua
-- health component for objects that need to take damage



local Health = {}



function Health:New(data)

	-------------
	-- Create
	--------------
	local object = {}

	object.name = data.name or "???"
	object.type = "health"

	object.max = data.max or 100
	object.min = data.min or 0
	object.start = data.start or 100
	object.hp = 100

	---------------
	-- Functions
	---------------
	function object:Damage(attack)
		self.hp = self.hp - attack.damage
		self:UpdateCheck()

		printDebug{self.hp, "Health"}

	end

	function object:UpdateCheck()
		if(self.hp < self.min) then 
			self.hp = self.min
		end

		if(self.hp > self.max) then 
			self.hp = self.max
		end 

	end 

	function object:Death()
		printDebug{"fucking dead!", "Health"}
	end 

	function object:GetHealth()
		return self.hp
	end 

	return object

end 







return Health