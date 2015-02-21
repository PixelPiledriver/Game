-- Size.lua
-- changes the size of an object over time
-- ONLY FOR POINTS

local ObjectUpdater = require("ObjectUpdater")

local Size = {}

----------------
-- Static Vars
----------------
Size.name = "Size"
Size.oType = "Static"
Size.dataType = "Component Constructor"


function Size:New(data)

	local o = {}

	----------------
	-- Create
	----------------

	-- object
	o.name = data.name or "..."
	o.oType = "Size"
	o.dataType = "Component"

	-- vars

	o.width = data.width or 0
	o.height = data.height or 0
	o.depth = data.depth or 0

	o.speed = data.speed or 0

	o.parent = data.parent or nil


	function o:Update(data)

	end

	ObjectUpdater:Add{o}

	return o
end 

ObjectUpdater:AddStatic(Size)

return Size




-- Notes
-------------------------------------------------
-- gonna repurpose this into a component for formatting dimensions of objects