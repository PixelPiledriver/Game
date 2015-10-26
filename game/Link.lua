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
			-->EMPTY
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

	-- find var slot in table
	-- component->variable or just variable?
	local varPositionA = nil
	local varPositionB = nil

	if(data.a[3] == nil) then
		varPositionA = 2
	else 
		varPositionA = 3
	end

	if(data.b[3] == nil) then
		varPositionB = 2
	else 
		varPositionB = 3
	end

	-- create A and B
	local a = {}
	local b = {}
	
	-- set object
	a.o = data.a[1]
	b.o = data.b[1]

	-- set component if exists
	if(varPositionA == 3) then
		a.comp = data.a[2]
	end 

	if(varPositionB == 3) then
		b.comp = data.b[2]
	end 
	
	-- find number of loops to be done
	local loopCount = 1

	if(type(data.a[varPositionA]) == "table") then
		loopCount = #data.a[varPositionA]
	end 

	for i=1, loopCount do

		if(loopCount > 1) then
			a.var = data.a[varPositionA][i]
			b.var = data.b[varPositionB][i]
		else 
			a.var = data.a[varPositionA]
			b.var = data.b[varPositionB]
		end

		-- create the link
		local linkTable =
		{
			a = a,
			b = b,  
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
						math = data.offsets[i].value[2] or nil
					}
				elseif(data.offsets[i].varOf) then
					linkTable.offsets[#linkTable.offsets + 1] =
					{
						o = data.offsets[i].varOf[1],
						var = data.offsets[i].varOf[2][data.offsets[i].varOf[3]],
						math = data.offsets[i].varOf[4] or nil 
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


	-- is there another variable of the EXACT same A and B to link?
	-- then run this funciton again but with the extra variable
end 


ObjectUpdater:AddStatic(Link)

return Link



-- Notes
-------------------------------------

-- NEED
-- way to create multiple var links from a single call to Link:Simple

-->TODO
-- need offset value from link
-- only works for number values


-->TODO
-- they need to be in their own list in Object Updater
-- this means that Object Updater needs a way of sorting objects by update priority


-- TO DO
-- implement "function" link type
-- right now only vars are supported
-- not sure exactly what a function link would be used for
-- but could perhpas be useful

-- this stuff works now
-- use this to fix problems I was having with building panels and stuff -> :D

-- b gets applied to a
-- a should always be a 

-- try passing objects and then what you want from them seperately




------------
-- DONE
------------

-- DONE
-- add in ability to set an offset from the linked to variable

-- DONE
-- Links should be updated after all objects
-- but before drawing


-----------------------------skjldfsjkhdfkjshdfkjhsdkfh-----------------------------

--[[

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
			-->EMPTY
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

	-- create A
	local a = {}
	
	a.o = data.a[1]
	
	if(data.a[3] == nil) then
		a.var = data.a[2]
	else 
		a.comp = data.a[2]
		a.var = data.a[3]
	end

	-- create B
	local b = {}
	
	b.o = data.b[1]

	-- component->variable link or just variable?
	if(data.b[3] == nil) then
		b.var = data.b[2]
	else 
		b.comp = data.b[2]
		b.var = data.b[3]
	end

	-- create the link
	local linkTable =
	{
		a = a,
		b = b,  
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
					math = data.offsets[i].value[2] or nil
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


	-- is there another variable of the EXACT same A and B to link?
	-- then run this funciton again but with the extra variable
end 


ObjectUpdater:AddStatic(Link)

return Link



-- Notes
-------------------------------------

-- NEED
-- way to create multiple var links from a single call to Link:Simple

-->TODO
-- need offset value from link
-- only works for number values


-->TODO
-- they need to be in their own list in Object Updater
-- this means that Object Updater needs a way of sorting objects by update priority


-- TO DO
-- implement "function" link type
-- right now only vars are supported
-- not sure exactly what a function link would be used for
-- but could perhpas be useful

-- this stuff works now
-- use this to fix problems I was having with building panels and stuff -> :D

-- b gets applied to a
-- a should always be a 

-- try passing objects and then what you want from them seperately




------------
-- DONE
------------

-- DONE
-- add in ability to set an offset from the linked to variable

-- DONE
-- Links should be updated after all objects
-- but before drawing


--]]