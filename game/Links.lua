-- Links.lua


-- Purpose
-----------------------
-- Component of an object to manage its links


---------------------------------------------------
local Links = {}

----------------
-- Static Info
----------------

Links.Info = Info:New
{
	objectType = "Links",
	dataType = "Interaction",
	structureType = "Static"
}





-------------
-- Object
-------------

function Links:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Links",
		dataType = "Interaction",
		structureType = "Object"
	}

	----------
	-- Vars
	----------
	o.links = {}

	--------------
	--Functions
	--------------
	function o:Add(link)
		o.links[#o.links+1] = link
	end 

	function o:DestroyAll()
		for i=1, #o.links do
			ObjectUpdater:Destroy(o.links[i])
		end 

		printDebug{"All links destroyed", "Links"}
	end 


	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
	end

	-------------
	-- End
	-------------

	return o
end 



return Links


-- Notes
--------------------
-- this object should be simplified into something that
-- can clean up any object type