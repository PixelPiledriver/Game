-- Key.lua

-- Purpose
---------------------------------------------
-- keys for use with keyboard component




local Key = {}

------------------
-- Static Info
------------------
Key.Info = Info:New
{
	objectType = "Key",
	dataType = "Input",
	structureType = "Static",
}

---------------------
-- Static Functions
---------------------

function Key:New(key)
	return self:NewT{key = key}
end 

function Key:NewT(data)

	local o = {}

	----------------
	-- Object Info
	----------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Key",
		dataType = "Input",
		structureType = "Object",
	}

	o.key = data.key or nil
	o.pressed = false
	o.active = true


	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
	end 


	-----------
	-- End
	-----------

	return o

end


return Key

------------
-- Notes
------------
-- not sure if this is needed anymore, but maybe