-- DrawGroup.lua

-- Add objects to a DrawGroup that all need to be drawn together in the same layer

-- When an object is part of a DrawGroup it's Draw component does not submit itself to DrawList
-- A DrawGroup submits itself to DrawList
-- DrawList sorts the group by .depth witin a .layer just like any other object
-- But draws all of the objects within the group as if it were its own layer

-- Useful for windows and characters with parts and shit like that


local DrawGroup = {}


-- indexed table
-- {o1, o2, ...}
function DrawGroup:New(data)

	local o = {}

	o.drawables = {}
	o.isGroup = true -- flag to DrawList that this is a group of objects to be drawn not just a single draw

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

		--  this is wrongly implemented
		-- maybe I can pass the depth of the group to the object
		-- but no actually I NEED to pass the group to grouplist
		-- so it can carrt the list of objects

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


	ObjectUpdater:Add{o}

	return o

end 


ObjectUpdater:AddStatic(DrawGroup)

return DrawGroup


-- Notes
------------
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