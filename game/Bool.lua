-- Bool.lua


-- Purpose
----------------------------
-- functions for bools
-- makes them easier to work with

---------------------------------------------------------------------------

-- global
Bool = {}

------------------
-- Static Info
------------------
Bool.Info = Info:New
{
	objectType = "Bool",
	dataType = "Data",
	structureType = "Utility"
}

---------------------------
-- Static Functions
---------------------------

-- converts a bool into a string
-- main use is for printing bools to screen
-- b = bool
function Bool:ToString(b)

	if(b) then
		return "true"
	else 
		return "false"
	end

end 

-- toggle given bool based on current state
-- assign the return value of give bool to bool --> weird I know but thats how it works :P
-- b = bool
function Bool:Toggle(b)
	if(b) then
		return false
	else
		return true
	end 

end 

-- use to set vars of objects to false by New data
function Bool:DataOrDefault(b, default)

	if(b == nil) then
		return default
	elseif(b == false) then
		return false
	elseif(b == true) then
		return true
	end 

end 

---------------
-- Static End
---------------





-- Notes
---------------------------------------