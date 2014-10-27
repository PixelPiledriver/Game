-- SinCounter.lua
-- number generator
-- this should be part of a much larger class
-- will just do this for now



local ObjectUpdater = require("ObjectUpdater")
local SinCounter = {}



function SinCounter:New(data)

	local object = {}


	object.value = 0
	object.speed = data.speed or 0.1
	object.sin = 0
	object.damp = data.damp or 1

	if(object.speed == 0) then
		object.value = 1
	end
	

	function object:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "SinCounter"},
			{text = "SinCounter"},
			{text = "------------------------"},
			{text = "Value: " .. self.value},
			{text = "Speed: " .. self.speed},
			{text = "Sin: " .. self.sin},
		}
	end 

	function object:Calculate()
		self.value = self.value + self.speed
		--self.sin = math.sin(self.value)
	end 

	function object:Damp()
		self.speed = self.speed * self.damp
	end


	function object:Get()
		self.sin = math.sin(self.value)
		return self.sin
	end 

	function object:Update()
		self:Calculate()
		self:Damp()
	end 

	ObjectUpdater:Add{object}

	return object
end 







return SinCounter