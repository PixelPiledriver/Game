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


-----------------
-- Requires
-----------------
local Link = require("Link")

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

DrawGroup.objectsMade = {}
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
	
	-- depth value of group
	o.depth = 0

	-- object to get depth for this group
	o.depthObject = nil 

	-- flag for DrawList to recongnize that this is a DrawGroup 
	-- not just a single Draw object
	o.isGroup = true

	--{x, y, width, height}
	o.scissorActive = data.scissor and true or false

	o.scissor = {x=nil, y=nil, width=nil, height=nil}

	if(data.scissor) then

		Link:Simple
		{
			a = {o, "scissor", "x"},
			b = data.scissor.x
		}

		Link:Simple
		{
			a = {o, "scissor", "y"},
			b = data.scissor.y
		}

		Link:Simple
		{
			a = {o, "scissor", "width"},
			b = data.scissor.width
		}

		Link:Simple
		{
			a = {o, "scissor", "height"},
			b = data.scissor.height
		}
		
	end 




	------------------
	-- Functions
	------------------

	function o:Update()
		o:CalculateCurrentDepth()
		o:SubmitToDrawList()
	end 

	function o:SubmitToDrawList()
		DrawList:Submit(self)
	end 

	-- add object on top of group
	-- not sure why but Draw component must be added directly with this function
	-- might want to change that
	-- {Draw, layer}
	function o:Add(object)
		self.drawables[#self.drawables + 1] = object
		object.inGroup = true
	end

	function o:AddDrawablesOf(object)
		for i=1, #object.drawables do
			self.drawables[#self.drawables + 1] = object.drawables[i].Draw
			object.drawables[i].Draw.inGroup = true
		end 
	end 

	-- remove the top object from group
	function o:Pop()
		self.drawables[#self.drawables].inGroup = false
		self.drawables[#self.drawables] = nil
	end 

	function o:SetDepthObject(object)
		if(object.parent and object.GetDepth) then
			self.depthObject = object
		end 
	end 

	-- get depth from parent
	function o:CalculateCurrentDepth()

		local currentDepth = 0

		if(self.depthObject) then
			currentDepth = self.depthObject:GetDepth()
		elseif(self.drawables[1].parent.GetDepth) then
			currentDepth = self.drawables[1].parent:GetDepth()
		end
		--]]

		self.depth = currentDepth

	end 



	-- Add objects passed into New this group
	if(#data.objects > 0) then
		for i=1, #data.objects do
			o:Add(data.objects[i].Draw)
		end 
	end 


	function o:Destroy()
		ObjectManager:Destroy(self.Info)
	end 

	----------
	-- End
	----------


	ObjectManager:Add{o}

	return o

end 


---------------
-- Static End
---------------

ObjectManager:AddStatic(DrawGroup)

return DrawGroup


-- Notes
------------

-- Done --> needs some polish
-- need to add love.graphics.setScissor for panels

-- have a static feature that tracks on panels in use
-- if two panels are on the same y it bumps one of them forward
-- so that sorting is never flickering 
--> pretty smart need to add that to other stuff as well
-- maybe integrate something like that into DrawList

-- DONE
-- by default depth should be defined by the first object added
-- this is the easiest solution but not the most flexible
-- add support for other options

-- depth needs to be defined by one of the objects in the group
-- should add feature to set object to get depth from
-- or to calculate the depth based on objects at runtime

-- FIXED
-- seems to be broken :|

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








-- Trash
--------------------------------
--[=[


	-- DrawGroup must be submitted in PostUpdate
	-- otherwise the DrawGroup may submit an object 
	-- before its depth can be calculated for the current frame
	-- TRASH
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



	--[[
	o.scissor = 
	{
		x = data.scissor and data.scissor[1] or nil, 
		y = data.scissor and data.scissor[2] or nil, 
		width = data.scissor and data.scissor[3] or nil, 
		height = data.scissor and data.scissor[4] or nil
	}
	--]]

























--]=]