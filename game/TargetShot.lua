-- TargetShot.lua


local TargetShot = {}

TargetShot.Info = Info:New
{
	objectType = "TargetShot",
	dataType = "Movement",
	structureType = "Static"
}


function TargetShot:New(data)
	
	local o = {}

	o.parent = data.parent

	o.xVelocity = data.xVelocity or 0
	o.yVelocity = data.yVelocity or 0
	o.t = data.t
	

	return o

end 





return TargetShot