-- DataPass
-- use to build structures that pass data from one table to another


-- the idea is that the construct a table or members 
-- that b should be looking for in a
-- if they are there, what to assign, and if they arent what to default to

-- this helps keep related but optional table members together in a streamlined
-- stack of code

-- it will basically be like a custom switch

local Random = require("Random")



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

		local key = t.options[i][1]

		if(t.data[key]) then

			-- set value based on type
			if(t.options[i][2] == "value") then
				return t.data[key]
			elseif(t.options[i][2] == "range") then
				return love.math.random(t.data[key].min, t.data[key].max)

			elseif(t.options[i][2] == "multiple") then
				return Random:MultipleOf(t.data[key].start, t.data[key].range)

			elseif(t.options[i][2] == "angleToVector") then
				return Math:AngleToVector(data.direction)

			elseif(t.options[i][2] == "angleRangeToVector") then
				return Math:VectorFromAngle(love.math.random(t.data[key].min, t.data[key].max))

			elseif(t.options[i][2] == "randomVector") then
				local a = Random:ChooseRandomlyFrom(t.data[key])
				local dir = Math:AngleToVector(a)
				return dir
			
			else
				return nil
			end 

			valueSet = true

		end 

	end 

	if(valueSet == false) then
		return t.default
	end 

end 
	









return DataPass








-- Notes
---------------------------------

-- original version
-- with names for key and type in the table
-- removing them for now just to make it easier to type
-- even tho it is a bit more vauge

--[[


function DataPass:Options(t)

	local valueSet = false

	for i=1, #t.options do

		local key = t.options[i].key

		if(t.data[key]) then

			-- set value based on type
			if(t.options[i].type == "value") then
				return t.data[key]
			elseif(t.options[i].type == "range") then
				return love.math.random(t.data[key].min, t.data[key].max)
			elseif(t.options[i].type == "multiple")
			end 

			valueSet = true

		end 

	end 

	if(valueSet == false) then
		return t.default
	end 

end 

--]]

