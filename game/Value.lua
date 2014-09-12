-- Value.lua
-- create values using useful functions pre wrapped by named

local Random = require("Random")

local Value = {}


-- (value)
function Value:Value(v)
	local t = {}

	t.value = v

	t.Get = function()
		return v
	end 

	t.valueType = "value" 

	return t
end 


-- {min, max}
function Value:Range(t)

	t.Get = function()
		return love.math.random(t.min, t.max)
	end 

	t.valueType = "range"

	return t
end

function Value:FloatRange(t)

	t.Get = function()
	
		local min = t.min * 100
		local max = t.max * 100
		local v = love.math.random(min, max)
		v = v * 0.01
		return v
	end

	t.valueType = "floatRange"

	return t

end 

-- {start, range}
function Value:Multiple(t)

	t.Get = function()
		return Random:MultipleOf(t.start, t.range)
	end
	
	t.valueType = "multiple"

	return t
end 

-- {values}
function Value:Random(t)
	
	t.Get = function()
		return Random:ChooseRandomlyFrom(t.values)
	end

	t.valueType = "random"

	return t
end


--{angle}
function Value:AngleToVector(t)

	t.Get = function()
		return Math:AngleToVector(t.direction)
	end 

	t.valueType = "angleToVector"

	return t 
end


function Value:RangeAngleToVector(t)

	t.Get = function()
		return Math:AngleToVector(love.math.random(t.min, t.max))
	end 

	t.valueType = "angleRangeToVector"

	return t
end

function Value:RandomAngleToVector(t)

	t.Get = function()
		local a = Random:ChooseRandomlyFrom(t.values)
		local dir = Math:AngleToVector(a) 
		return dir
	end

	t.valueType = "randomAngleToVector"

	return t
end



return Value











-- Notes
-------------------------------------
-- WTF is this file for?
-- pass a table into a function
-- it will append functions to the table that
-- allow the user to generically get a value from it
-- these act as mini objects to get data from
-- is nice cuz if they have a range they can continue to spit out
-- random numbers

-- every value type needs a get function

