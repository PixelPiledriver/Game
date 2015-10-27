-- Random.lua

-- Purpose
------------
-- get random numbers
-- for single uses

-- if you need to keep getting random values over and over
-- use Value.lua instead --> needs to be refactored

-----------------------------------------
-- Global
Random = {}

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

-- get random number from 0 to given number
-- this is the most simple random function
function Random:Number(number)
	return love.math.random(number)
end 

-- get a random number within the range given
function Random:Range(min, max)
	return love.math.random(min, max)
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


