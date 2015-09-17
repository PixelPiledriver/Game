-- DrawGroup.lua

-- Purpose
----------------------------
-- Add objects to a DrawGroup that all need to be drawn together 
-- in the same layer, sequentially

-- When an object is part of a DrawGroup it's Draw component does not submit to DrawList
-- Instead the DrawGroup submits itself to DrawList
-- DrawList sorts the group by .depth witin a .layer just like any other object
-- But draws all of the objects within the group in order 
-- effectively, as if the group were its own layer

-- Useful for panels and characters with parts that need to be in a specific order


-----------------------------------------------------------------------------
local DrawGroup = {}


------------------
-- Static Info
------------------
DrawGroup.Info = Info:New
{
	objectType = "DrawGroup",
	dataType = "Graphics",
	structureType = "Static"
}


---------------------
-- Static Functions
---------------------

-- indexed table
-- {o1, o2, ...}
function DrawGroup:New(data)

	local o = {}

	------------------
	-- Object Info
	------------------
	o.Info = Info:New
	{
		name = "...",
		objectType = "DrawGroup",
		dataType = "Graphics",
		structureType = "Component"
	}

	----------------
	-- Vars
	----------------
	o.drawables = {}

	o.layer = data.layer or 3
	o.depth = 0

	-- flag for DrawList to recongnize that this is a DrawGroup 
	-- not just a single Draw object
	o.isGroup = true


	------------------
	-- Functions
	------------------

	function o:Update()
		o:SubmitToDrawList()
	end 

	function o:SubmitToDrawList()
		DrawList:Submit(self)
	end 

	-- add object on top of group
	-- {o, layer}
	function o:Add(object)
		self.drawables[#self.drawables + 1] = object
		object.inGroup = true
	end

	-- remove the top object from group
	function o:Pop()
		self.drawables[#self.drawables].inGroup = false
		self.drawables[#self.drawables] = nil
	end 

	-- DrawGroup must be submitted in PostUpdate
	-- otherwise the DrawGroup may submit an object 
	-- before its depth can be calculated for the current frame
	function o:PostUpdate()

		-- this is wrongly implemented
		-- maybe I can pass the depth of the group to the object
		-- but no actually I NEED to pass the group to grouplist
		-- so it can carry the list of objects

		--[[
		for i=1, #self.drawables do
			self.drawables[i]:SubmitToDrawListManual()
		end 
		--]]

	end 


	-- Add objects passed into New this group
	if(#data > 0) then
		for i=1, #data do
			o:Add(data[i].Draw)
		end 
	end 



	----------
	-- End
	----------


	ObjectUpdater:Add{o}

	return o

end 


---------------
-- Static End
---------------

ObjectUpdater:AddStatic(DrawGroup)

return DrawGroup


-- Notes
------------
-- seems to be broken :|
-->BROKEN

-- holds refs to objects
-- set their stacking order
-- submit to Drawlist and it handles giving it its own spot in a unique depth

-- need to look at other solutions but this sounds ok for right now

-- draw groups need to define their OWN layer and depth that overides the drawbles
-- own layer and depth setting

-- DrawGroup needs to submit itself to DrawList
-- with a new flag: .isGroup
-- DrawList needs to be updated to be able to handle groups 
-- draw each object within the group starting with the depth of the group