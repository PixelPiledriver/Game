-- FileTemplate.lua
 
-- Purpose
----------------------------
-- ???

------------------
-- Requires
------------------

---------------------------------------------------------------------------

local ??? = {}


-------------------
-- Static Info
-------------------
???.Info = Info:New
{
	objectType = "???",
	dataType = "???",
	structureType = "Static"
}


function ???:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = ???,
		dataType = ???,
		structureType = "Object"
	}

	----------------
	-- Vars
	----------------
	???

	------------------
	-- Components
	------------------
	???

	------------------
	-- Functions
	------------------
	function o:Update()
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

ObjectManager:AddStatic(???)

return ???






-- Notes
---------------------------------------



--[==[ 
--Test Code
------------------

--]==]