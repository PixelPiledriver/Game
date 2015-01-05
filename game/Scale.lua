-- Scale.lua
-- Component
-- control size of stuff

---------------
-- Requires
---------------
local ObjectUpdater = require("ObjectUpdater")


local Scale = {}

--------------------
-- Static Vars
--------------------

Scale.name = "Scale"
Scale.oType = "Static"
Scale.dataType = "Component Constructor"

Scale.defaultScale =
{
	x = 1,
	y = 1
}


function Scale:New(data)




	----------------
	-- Create
	----------------
	local o = {}

	o.name = data.name or "..."
	o.oType = "Scale"
	o.dataType =  "Graphics Component"

	o.parent = data.parent or nil

	o.x = data.x or 1
	o.y = data.y or 1


	o.speed = 
	{
		x = data.speed and data.speed.x or 0,
		y = data.speed and data.speed.y or 0
	}


	---------------
	-- Functions
	---------------

	function o:Update()
		self:Speed()
	end 

	function o:Speed()
		self.x = self.x + self.speed.x
		self.y = self.y + self.speed.y
	end 


	-- {x,y,xSpeed, ySpeed}
	function o:Set(data)
		self.x = data.x or self.x
		self.y = data.y or self.y
		self.speed.x = data.xSpeed or self.speed.x
		self.speed.y = data.ySpeed or self.speed.y
	end 
	-- add to runtime
	ObjectUpdater:Add{o}

	return o

end 

	

return Scale