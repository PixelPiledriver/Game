-- Random
-- get common random numbers



Math = {}


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


function Math:AngleToVector(angle)


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

function Math:VectorToAngle(vector)

	local v = {}
	v.x = 1
	v.y = 0

	local angle = math.atan2(vector.y,vector.x) - math.atan2(v.y,v.x)

	return angle

end 


-- linear interpolation
--{a, b, t}
function Math:Lerp(data)
	return data.a + ((data.b - data.a) * data.t)
end 

function Math:InverseLerp(data)
	return  data.t/(data.a + (data.b-data.a))
end








