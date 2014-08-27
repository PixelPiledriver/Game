-- Random
-- get common random numbers



Math = {}
Random = {}


function Random:MultipleOf(number, scale)
	return number + love.math.random(scale) * number
end 

function Math:UnitVector(vector)

	local a = vector.x * vector.x
	local b = vector.y * vector.y
	local c = a + b
	c = math.sqrt( c )

	local unitVec = 
	{
		x = vector.x / c, 
		y	= vector.y / c
	}

	return unitVec

end 


function Math:VectorFromAngle(angle)


	local sin = math.sin(math.rad(angle))
	local cos = math.cos(math.rad(angle))

	local v = 
	{
		x = cos,
		y = sin
	}

	v = self:UnitVector(v)

	return v 

end 



-- linear interpolation
--{a, b, t}
function Math:Lerp(data)
	return data.a + ((data.b - data.a) * data.t)
end 

function Math:InverseLerp(data)
	return  data.t/(data.a + (data.b-data.a))
end








