-- Pattern.lua

-- Purpose
----------------------------------------------
-- table of values to step thru
-- the values are applied to an object that the pattern object is a part of
-- or you can define what object it should apply itself to
-- it does so by using an index of the variables it holds
-- and applies each to the object.variable of the same name

--------------------------------------------------------------------

local Pattern = {}

-------------------
-- Static Info
-------------------
Pattern.Info = Info:New
{
	objectType = "Pattern",
	dataType = "Data",
	structureType = "Static"
}

-------------
-- Object
-------------
function Pattern:New(data)
	
	local o = {}

	------------
	-- Info 
	------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "MapObject",
		dataType = "GameObject",
		structureType = "Object"
	}

	----------
	-- Vars
	----------
	-- the current step to use
	o.stepIndex = 1

	-- each step contains data to be used on that step
	o.steps = data.steps or {}

	-- names of all vars in a step
	-- for right now all steps are required to be uniform
	o.varIndex = data.varIndex or {}

	--------------
	-- Functions
	--------------

	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
	end 

	-------------
	-- End
	-------------
	ObjectUpdater:Add{o}

	return o
end 

------------------
-- Static End
------------------
ObjectUpdater:AddStatic(Pattern)

return Pattern