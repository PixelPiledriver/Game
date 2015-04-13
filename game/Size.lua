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

	o.heightOffset = 0
	o.widthOffset = 0
	o.linkWidth = nil
	o.linkHeight = nil

	function o:Set(width, height)
		self.width = width
		self.height = height
	end

	function o:LinkSizeTo(data)
		self.linkWidth = data.link
		self.linkHeight = data.link
		self.widthOffset = data.widthOffset or 0
		self.heightOffset = data.heightOffset or 0
	end 

	function o:LinkWidthTo(data)
		self.linkWidth = data.link or nil
		self.widthOffset = data.offset or 0
	end 

	function o:LinkHeightTo(data)
		self.linkHeight = data.link or nil
		self.heightOffset = data.offset or 0
	end 



	function o:Update(data)
		self:LinkUpdate()
	end

	function o:LinkUpdate()
		if(self.linkWidth) then
			self.width = self.linkWidth.width + self.widthOffset
		end 

		if(self.linkHeight ~= nil) then
			self.height = self.linkHeight.height + self.heightOffset
		end 

		

	end 



	ObjectUpdater:Add{o}

	return o
end 

ObjectUpdater:AddStatic(Size)

return Size


-- Notes
-------------------------------------------------
-- gonna repurpose this into a component for formatting dimensions of objects