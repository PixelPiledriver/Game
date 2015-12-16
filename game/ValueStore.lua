-- ValueStorage.lua

-- Purpose
-----------------------------------------
-- an empty object that holds any type of named variable


local ValueStorage = {}

function ValueStorage:New()

	local o = {}

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "ValueStorage",
		dataType = "",
		structureType = "Object"
	}

	function o:Destroy()
		ObjectManager:Destroy(self.Info)		
	end 

	return o

end 


return ValueStore