-- Kirk Barnett
-- Key.lua

-- keys for use with keyboard component


local Key = {}


function Key:New(key)
	return self:NewT{key = key}
end 

function Key:NewT(data)

	local o = {}

	o.key = data.key or nil
	o.pressed = false
	o.active = true

	return o

end



return Key