-- Random
-- get common random numbers



Random = {}




function Random:MultipleOf(number, scale)
	return number + love.math.random(scale) * number
end 


