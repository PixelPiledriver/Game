-- Link.lua
-->CLEAN

-- Purpose
----------------------------
-- object that links two objects values together
-- like a constraint



-----------------------------------------------------------------

local Link = {}

-----------------
-- Static Info
-----------------

Link.Info = Info:New
{
	objectType = "Link",
	dataType = "Data",
	structureType = "Static"
}

--------------
-- Object
--------------

function Link:New(data) 

	local o = {}

	----------------
	-- Object Info
	----------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Link",
		dataType = "Data",
		structureType = "Component"
	}

	----------
	-- Vars
	----------

	-- objects
	o.a = data.a.o
	o.b = data.b.o

	-- component
	o.aComp = data.a.comp or nil
	o.bComp = data.b.comp or nil

	-- variable 
	o.aVar = data.a.var
	o.bVar = data.b.var

	-- offsets --> created as a table of more links
	o.offsets = data.offsets or {}
	o.linkType = data.type or "value"

	-----------------
	-- Functions
	-----------------

	function o:Update()

		if(self.linkType == "value") then

			-- find a
			local a = nil

			if(self.aComp) then
				a = self.a[self.aComp]
			else
				s = self.a
			end 

			-- find b
			local b = nil

			if(self.bComp) then
				b = self.b[self.bComp]
			else
				b = self.b
			end 	

			-- calculate offset
			-- very verbose but works for now
			local offset = 0
			if(self.offsets) then

				for i=1, #self.offsets do

					if(self.offsets[i].o) then

						if(self.offsets[i].math == nil) then
							offset = offset + self.offsets[i].o[self.offsets[i].var]

						elseif(self.offsets[i].math == "Add") then
							offset = offset + self.offsets[i].o[self.offsets[i].var]

						elseif(self.offsets[i].math == "Sub") then
							offset = offset - self.offsets[i].o[self.offsets[i].var]

						elseif(self.offsets[i].math == "Mul") then
							offset = offset * self.offsets[i].o[self.offsets[i].var]

						end

					elseif(self.offsets[i].value) then
						
						if(self.offsets[i].math == nil) then
							offset = offset + self.offsets[i].value

						elseif(self.offsets[i].math == "Add") then
							offset = offset + self.offsets[i].value

						elseif(self.offsets[i].math == "Sub") then
							offset = offset - self.offsets[i].value

						elseif(self.offsets[i].math == "Mul") then
							offset = offset * self.offsets[i].value

						end 

					end

				end 

			end 

			-- ready to set value
			a[self.aVar] = b[self.bVar] + offset

		end 

		-- no implementation for this type yet
		-->FIX
		if(self.linkType == "func") then			
		end 

	end 


	function o:PrintDebugText()

		local a = nil
		if(self.aComp) then
			a = self.a[self.aComp][self.aVar]
		else
			a = self.a[self.aVar]
		end 

		local b = nil
		if(self.bComp) then
			b = self.b[self.bComp][self.bVar]
		else 
			b = self.b[self.bVar]
		end 


		DebugText:TextTable
		{
			{text = "", obj = "Link"},
			{text = "Link"},
			{text = "-------------------------"},
			{text = "A:" .. a},
			{text = "B:" .. b},
		}

	end 

	ObjectUpdater:AddLink(o)

	return o

end

---------------------
-- Static Functions
---------------------

function Link:Simple(data)

	-- creat the link
	local linkTable =
	{
		a = 
		{
			o = data.a[1],
			comp = data.a[2],
			var =  data.a[3]
		},

		b = 
		{
			o = data.b[1],
			comp = data.b[2],
			var = data.b[3] 
		},

		offsets = {}
	}

	-- add offsets to table
	if(data.offsets) then
		for i=1, #data.offsets do
			--linkTable.offsets[#linkTable.offsets + 1] = data.offsets[i]

			if(data.offsets[i].object) then
				linkTable.offsets[#linkTable.offsets + 1] =
				{
					o = data.offsets[i].object[1],
					var = data.offsets[i].object[2],
					math = data.offsets[i].object[3] or nil
				}
			elseif(data.offsets[i].value) then
				linkTable.offsets[#linkTable.offsets + 1] =
				{
					value = data.offsets[i].value[1],
					math = data.offsets[i].value[3] or nil
				}
			end 

		end 
	end

	-- call new
	if(data.a.links == nil) then
		data.a.links = {}
	end 

	-- create link and have object A keep track of it
	-- so it can be changed or deleted later
	data.a.links[#data.a.links + 1] = Link:New(linkTable)
end 


ObjectUpdater:AddStatic(Link)

return Link


-- notes
-------------------------------------
-->TODO
-- need offset value from link
-- only works for number values

-- Links should be updated after all objects -->FIX
-- but before drawing
-- they need to be in their own list in Object Updater
-- this means that Object Updater needs a way of sorting objects by update priority

-- TO DO
-- add in ability to set an offset from the linked to variable


-- this stuff works now
-- use this to fix problems I was having with building panels and stuff

-- b gets applied to a
-- a should always be a 

-- try passing objects and then what you want from them seperately





