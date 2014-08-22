-- Random
-- get common random numbers



Random = {}




function Random:MultipleOf(number, scale)
	return number + love.random(scale) * number
end 


