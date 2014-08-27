-- Random
-- get common random numbers



local Random = {}


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




return Random