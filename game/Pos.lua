-- Pos.lua
--------------------------------------
-- component
-- control position of object

local ObjectUpdater = require("ObjectUpdater")


local Pos =  {}


Pos.defaultPos = 
{
	x = 0, 
	y = 0,
	z = 0,
	speed = {x=0,y=0}
}


-- is this even needed?
-- adds component to given parent using given data
--{parent, data}
function Pos:AddComponent(parent, posTable)
	parent.componentsIndex[#parent.componentsIndex+1] = "Pos"
	posTable.parent = parent
	local o = self:New(posTable)
	parent.Pos = o
end 

--{x,y,z}
function Pos:New(data)

	local o = {}

	---------------
	-- Create
	---------------

	-- object
	o.name = data.name or "..."
	o.oType = "Pos"
	o.dataType = "Component"

	o.parent = data.parent

	-- vars
	o.x = data.x or 0
	o.y = data.y or 0
	o.z = data.z or 0

	o.speed = {}
	o.speed.x = data.speed and data.speed.x or 0
	o.speed.y = data.speed and data.speed.y or 0
	o.speed.z = data.speed and data.speed.z or 0

	-----------------
	-- Functions
	-----------------

	-- {x, y, z}
	function o:SetPos(data)
		self.x = data.x or self.x
		self.y = data.x or self.y
		self.z = data.z or self.z
	end 

	function o:SetSpeed(data)
		self.speed.x = self.speed.x
	end 


	-- {x, y, z}
	function o:Move(data)
		self.x = (data.x and (self.x + data.x)) or self.x
		self.y = (data.y and (self.y + data.y)) or self.y
		self.z = (data.z and (self.z + data.z)) or self.z
	end 


	function o:Update()
		self:PosSpeedUpdate()
	end 

	function o:PosSpeedUpdate()
		self.x = self.x + self.speed.x
		self.y = self.y + self.speed.y
		self.z = self.z + self.speed.z
	end 


	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Pos" },
			{text = "{" .. self.x .. ", " .. self.y .. ", " .. self.z .. "}"},
		}
	end 


	-- done!
	------------
	ObjectUpdater:Add{o}

	return o


end 



return Pos



