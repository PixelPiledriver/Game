-- Bool.lua

-- Global 
-- functions for bools
-- does cool stuff that I dont feel like programming over and over --> :D



Bool = {}


---------------------------
-- Static Functions
---------------------------

-- converts a bool into a string
-- main use is for printing bools to screen
function Bool:ToString(b)

	if(b) then
		return "true"
	else 
		return "false"
	end

end 

-- toggle given bool based on current state
-- assign the return value of give bool to bool --> weird I know but thats how it works :P
function Bool:Toggle(b)
	if(b) then
		return false
	else
		return true
	end 

end 


