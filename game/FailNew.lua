-- FailNew.lua

-- call inside of Type:New to check for
-- data members that are required



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