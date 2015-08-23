-- Random.lua

-- Purpose
------------
-- get common random numbers

-----------------------------------------

local Random = {}

Random.Info = Info:New
{
	objectType = "Random",
	dataType = "Generation",
	structureType = "Static"
}


-----------------------
-- Functions
-----------------------

-- get a multiple of a number
function Random:MultipleOf(number, scale)
	return number + love.math.random(scale) * number
end 

-- get a single random value 
-- from the passed in table of values
-- {value, ...}
function Random:ChooseRandomlyFrom(data)
	local index = love.math.random(1, #data)
	return data[index]
end

------------
-- Seed
------------
love.math.setRandomSeed(os.time())

-- random seed must be instated by use of love.math.random
-- which is really weird but thats just the way it is
Random:ChooseRandomlyFrom{1,2,3}






return Random