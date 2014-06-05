-- Health.lua
-- health component for objects that need to take damage



local Health = {}



function Health:New(data)

	-------------
	-- Create
	--------------
	local object = {}

	object.max = data.max or 100
	object.min = data.min or 0
	object.start = data.start or 100
	object.hp = object.start

	---------------
	-- Functions
	---------------
	function object:Damage(attack)
		object.hp = object.hp = attack.damage
		object:UpdateCheck()

		printDebug{object.hp, "Health"}

	end

	function object:UpdateCheck()
		if(object.hp < object.min) then 
			object.hp = object.min
		end

		if(object.hp > object.max) then 
			object.hp = object.max
		end 

	end 

	function object:Death()
		printDebug{"fucking dead!", "Health"}
	end 

	return object

end 







return Health