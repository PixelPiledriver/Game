-- DataPass
-- use to build structures that pass data from one table to another


-- the idea is that the construct a table or members 
-- that b should be looking for in a
-- if they are there, what to assign, and if they arent what to default to

-- this helps keep related but optional table members together in a streamlined
-- stack of code

-- it will basically be like a custom switch





local DataPass = {}


-- pass in 
--[[
{
	varName,
	data,
	options = 
	{
		{key, value},
		{key, value},
		{key, value},
		{key, value},
	}
	default = value
}
--]]

function DataPass:Options(t)

	local valueSet = false

	for i=1, #t.options do

		local key = t.options[i].key

		if(t.data[key]) then

			-- set value based on type
			if(t.options[i].value == "value") then
				return t.options[i].value
			elseif(t.options[i].value == "range") then
				return love.math.random(t.data[key].min, t.data[key].max)
			end 

			valueSet = true

		end 

	end 

	if(valueSet == false) then
		return t.default
	end 

end 
	









return DataPass