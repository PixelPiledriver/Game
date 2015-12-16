-- SinCounter.lua

-- Purpose
----------------------------
-- number generator
-- this should be part of a much larger class
-- will just do this for now

local SinCounter = {}

-----------------
-- Static InfoObjectManager:Destroy(self.Info)
-----------------

SinCounter.Info = Info:New
{
	objectType = "SinCounter",
	dataType = "Generation",
	structureType = "Static"
}


function SinCounter:New(data)

	local o = {}

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "SinCounter",
		dataType = "Generation",
		structureType = "Object"
	}

	-----------
	-- Vars
	-----------

	o.value = 0
	o.speed = data.speed or 0.1
	o.sin = 0
	o.damp = data.damp or 1

	if(o.speed == 0) then
		o.value = 1
	end
	

	-----------------
	-- Functions
	-----------------

	function o:Calculate()
		self.value = self.value + self.speed
		--self.sin = math.sin(self.value)
	end 

	function o:Damp()
		self.speed = self.speed * self.damp
	end


	function o:Get()
		self.sin = math.sin(self.value)
		return self.sin
	end 

	function o:Update()
		self:Calculate()
		self:Damp()
	end 

	function o:PrintDebugText()
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

	function o:Destroy()
		ObjectManager:Destroy(self.Info)
	end 

	----------
	-- End
	----------

	ObjectManager:Add{object}

	return object
end 


----------------
-- Static End
----------------

return SinCounter