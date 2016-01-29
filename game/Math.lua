-- Math.lua

-- Purpose
--------------------------------
-- useful math functions

-----------------------------------------------------------

-- global
Math = {}


function Math:NormalOfVector(vector)
	local line = 
	{
		a = {x = 0, y = 0},
		b = {x = vector.x, y = vector.y}
	}
end

-- get unit vector from given vector
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

function Math:LineToVector(line)
	local vector =
	{
		x = line.b.x - line.a.x,
		y = line.b.y - line.a.y	
	}

	vector = self:UnitVector(vector)

	return vector
end 

-- return vector from given angle
-- angle = #
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

-- get vector from given radian
-- radian = #
function Math:RadToVector(radian)
	local sin = math.sin(radian)
	local cos = math.cos(radian)

	local v = 
	{
		x = cos,
		y = sin
	}

	v = self:UnitVector(v)

	return v
end 

-- return angle from given vector
-- vector = {x, y}
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

-- {a, b, t}
function Math:InverseLerp(data)
	return  data.t/(data.a + (data.b-data.a))
end

-- see if the two given points share the same position
--{a={x,y}, b={x,y}}
function Math:TestEqualityPoints(data)

	if(data.a.x == data.b.x and data.a.y == data.b.y) then
		return true
	end 

	return false

end 


-- compares a value to a given range, if it falls outside it puts it within
-- works as a Floor and Ceiling at the same time
-- {value, min, max}
function Math:Bind(data)
	if(data.value < data.min) then
		return data.min
	elseif(data.value > data.max) then
		return data.max
	else
		return data.value
	end 


end 



