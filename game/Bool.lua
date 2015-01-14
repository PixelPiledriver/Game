-- Bool.lua

-- Global 
-- functions for bools
-- does cool stuff that I dont feel like programming over and over --> :D



Bool = {}


---------------------------
-- Static Functions
---------------------------

function Bool:ToString(b)

	if(b) then
		return "true"
	else
		return "false"
	end 

end 


function Bool:Toggle(b)
	if(b) then
		b = false
	else
		b = true
	end 
end 


