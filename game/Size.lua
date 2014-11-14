-- Size.lua
-- changes the size of an object over time
-- ONLY FOR POINTS

local ObjectUpdater = require("ObjectUpdater")

local Size = {}


function Size:New(data)

	local o = {}

	----------------
	-- Create
	----------------

	-- object
	o.name = data.name or "..."
	o.type = "Size"

	-- vars
	o.speed = data.speed or 0
	o.size = data.size or 1
	o.parent = data.parent or nil

	function o:Update(data)

		if(self.parent.size) then
			self.parent.size = self.size
		end 

		self.size = self.size + self.speed

	end

	ObjectUpdater:Add{o}

	return o
end 




return Size
