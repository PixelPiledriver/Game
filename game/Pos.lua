-- Pos.lua
--------------------------------------
-- component
-- control position of object

local ObjectUpdater = require("ObjectUpdater")


local Pos =  {}

-----------------
-- Static Vars
-----------------
Pos.name = "Pos"
Pos.oType = "Static"
Pos.dataType = "Component Constructor"

Pos.defaultPos = 
{
	x = 0, 
	y = 0,
	z = 0,
	speed = {x=0,y=0}
}


-- is this even needed? :P
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

	-- default pos to parent
	if(o.x == nil and o.y == nil and o.z == nil and o.parent) then
		o.x = o.parent.Pos.x
		o.y = o.parent.Pos.y
		o.z = o.parent.Pos.z
	end 

	o.lastX = 0
	o.lastY = 0
	o.lastZ = 0

	o.speed = {}
	o.speed.x = data.speed and data.speed.x or 0
	o.speed.y = data.speed and data.speed.y or 0
	o.speed.z = data.speed and data.speed.z or 0


	-- link this pos component to another pos component
	o.followPos = data.followPos or nil
	o.followOffsetX = 0
	o.followOffsetY = 0
	o.followOffsetZ = 0

	-----------------
	-- Functions
	-----------------

	-- set an exact pos
	-- {x, y, z}
	function o:SetPos(data)
		self.x = data.x or self.x
		self.y = data.y or self.y
		self.z = data.z or self.z
	end 

	function o:LinkPosTo(data)
		o.followPos = data.link or nil
		o.followOffsetX = data.x or 0
		o.followOffsetY = data.y or 0
		o.followOffsetZ = data.z or 0
	end 

	-- set the rate of moving --> will probly be moved to its own component
	function o:SetSpeed(data)
		self.speed.x = self.speed.x
	end 

	-- move the object from its current pos
	-- {x, y, z}
	function o:Move(data)
		self.x = (data.x and (self.x + data.x)) or self.x
		self.y = (data.y and (self.y + data.y)) or self.y
		self.z = (data.z and (self.z + data.z)) or self.z
	end 

	--------------------------
	-- Update
	--------------------------

	function o:Update()
		self:PosSpeedUpdate()
		self:LastPosUpdate()
		self:FollowPosUpdate()
	end 

	function o:LastPosUpdate()
		self.lastX = self.x
		self.lastY = self.y
		self.lastZ = self.z
	end 

	function o:PosSpeedUpdate()
		self.x = self.x + self.speed.x
		self.y = self.y + self.speed.y
		self.z = self.z + self.speed.z
	end 

	function o:FollowPosUpdate()
		if(self.followPos == nil) then
			return
		end 

		self:SetPos
		{
			x = self.followPos.x + self.followOffsetX,
			y = self.followPos.y + self.followOffsetY,
			z = self.followPos.z + self.followOffsetZ,
		}
	end

	-------------
	-- Debug
	-------------
	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Pos" },
			{text = "{" .. self.x .. ", " .. self.y .. ", " .. self.z .. "}"},
		}
	end 

	
	ObjectUpdater:Add{o}

	-- done!	
	return o


end 



return Pos




-- notes
-----------------------
-- add a realativePoisition feature
-- allows position of object to be updated based on an object that it "anchors to"
-- can be called relativeObject I geuss --> because it is not necessarily relative to the parent
-- altho in most cases it will be --> should probly default to the parent if nothing else is given

-- need to be able to link a Pos compoenent to another Pos component
-- just pass it in
-- do this next!
-- this makes it so Pos components dont have to be updated.
-- they just have a pos and an offset from a linked position
	