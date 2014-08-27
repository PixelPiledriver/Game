-- Random
-- get common random numbers



local Random = {}


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

-- set seed
-- new everytime we start the game


love.math.setRandomSeed(os.time())
--love.math.setRandomSeed(10)


return Random