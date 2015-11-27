-- Size.lua

-- Purpose
--------------------
-- changes the size of an object over time
-- ONLY FOR POINTS

-----------------------------------------------------------------
local Size = {}

----------------
-- Static Info
----------------
Size.Info = Info:New
{
	objectType = "Size",
	dataType = "Transform",
	structureType = "Static"
}

-------------
-- Object
-------------

function Size:New(data)

	local o = {}

	-----------
	-- Info
	-----------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Size",
		dataType = "Component",
		structureType = "Object"
	}


	----------
	-- Vars
	----------

	o.width = data.width or 0
	o.height = data.height or 0
	o.depth = data.depth or 0

	o.speed = data.speed or 0

	o.parent = data.parent or nil

	o.heightOffset = 0
	o.widthOffset = 0
	o.linkWidth = nil
	o.linkHeight = nil

	--------------------
	-- Functions
	--------------------

	function o:Set(width, height)
		self.width = width
		self.height = height
	end

	function o:GetWidth()
		return self.width
	end 

	function o:GetHeight()
		return self.height
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

		local w = 0
		local h = 0


		if(self.linkWidth) then
			self.width = self.linkWidth.width + self.widthOffset
		end 

		if(self.linkHeight) then
			self.height = self.linkHeight.height + self.heightOffset
		end 

	end 

	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
	end 
	
	-----------
	-- End 
	-----------

	ObjectUpdater:Add{o}

	return o
end 

ObjectUpdater:AddStatic(Size)

return Size


-- Notes
-------------------------------------------------
-- gonna repurpose this into a component for formatting dimensions of objects

-- need to prove that assigning a get function to a link is a way to get up to date values