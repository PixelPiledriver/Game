-- FailNew.lua
-->REFACTOR

-- Purpose
----------------------------
-- call inside of Type:New to check for
-- data members that are required


-------------------------------------------------------------------------

-- stops an object from being created
-- if the given members are not present
function FailNew(data)

	for i=1, #data.members do

		if(data.table[data.members[i]] == nil) then
			print("Data did not contain: " .. data.members[i])
			print("Failed to create new object")
			return true
		end 

	end 

	return false

end

----------
-- End
----------


-- Notes
---------------------------------------
-- this file only contains a single function
-- needs to be converted into a component that can be used for testing objects

-- not sure what to do with it at the moment






