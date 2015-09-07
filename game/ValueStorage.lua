-- ValueStorage.lua

-- Purpose
-----------------------------------------
-- an empty object that holds any type of named variable


local ValueStorage = {}

ValueStorage.Info = Info:New
{
	objectType = "ValueStorage",
	dataType = "",
	structureType = "Static"
}

-------------------
-- Object
-------------------

-- {values = {a, b, c, ...}, index = {name, name, name, ...} }
function ValueStorage:New(data)

	local o = {}

	------------
	-- Info
	------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "ValueStorage",
		dataType = "Storage",
		structureType = "Object"
	}

	---------
	-- Vars
	---------

	-- add all vars of data to storage

	for i=1, #data.index do
		o[data.index[i]] = data.values[i]
	end 




	----------
	-- End
	----------

	ObjectUpdater:Add{o}

	return o

end 

----------------
-- Static End
----------------
ObjectUpdater:AddStatic(ValueStorage)

return ValueStorage