-- Link.lua

-- object that links two objects values together


local ObjectUpdater = require("ObjectUpdater")

local Link = {}

Link.name = "Link"
Link.oType = "Static"
Link.dataType = "Data Constructor"


function Link:New(data) 

	local o = {}

	o.name = data.name or "..."
	o.oType = "Link"
	o.dataType = "Data"

	-- objects
	o.a = data.a.o
	o.b = data.b.o

	-- component
	o.aComp = data.a.comp or nil
	o.bComp = data.b.comp or nil

	-- variable 
	o.aVar = data.a.var
	o.bVar = data.b.var

	

	o.linkType = data.type

	function o:Update()

		if(self.linkType == "value") then

			-- this is poorly written
			-- re write this shit please :P
			if(self.aComp and self.bComp == nil) then
				self.a[self.aComp][self.aVar] = self.b[self.bVar]
			elseif(self.aComp and self.bComp) then 
				self.a[self.aComp][self.aVar] = self.b[self.bComp][self.bVar]
			else
				self.a[self.aVar] = self.b[self.bVar]
			end 

		end 

		if(self.linkType == "func") then
			
		end 

	end 


	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Link"},
			{text = "Link"},
			{text = "-------------------------"},
			{text = "A:" .. self.a[self.aComp][self.aVar]},
			{text = "B:" .. self.b[self.bVar]},
		}
	end 



	ObjectUpdater:Add{o}

	return o

end



ObjectUpdater:AddStatic(Link)

return Link


-- notes
-------------------------------------

-- Links should be updated after all objects
-- they need to be in their own list in Object Updater
-- this means that Object Updater needs a way of sorting objects by update priority

-- TO DO
-- add in ability to set an offset from the linked to variable


-- this shit works now
-- use this to fix problems I was having with building panels and stuff

-- b gets applied to a
-- a should always be a 

-- try passing objects and then what you want from them seperately





-- old structure
-- re writing all this shit :P
--------------------------------------

--[[

-- Link.lua

-- object that links two objects values together


local ObjectUpdater = require("ObjectUpdater")

local Link = {}


function Link:New(data) 

	local o = {}

	-- objects
	o.a = data.a
	o.b = data.b


	-- component
	o.aComp = data.

	-- variable 
	o.aVar = data.aVar
	o.bVar = data.bVar

	o.linkType = data.linkType

	function o:Update()

		-- this does nothing because the value is passed as a value
		if(self.linkType == "value") then
			self.a[self.av] = self.b[self.bv]
		end 

		if(self.linkType == "func") then
			self.a[self.av] = self.b[self.bv](self.b)
		end 

	end 


	function o:PrintDebugText()
		--print(self.a)
		DebugText:TextTable
		{
			{text = "", obj = "Link"},
			{text = "Link"},
			{text = "-------------------------"},
			--{text = "A:" .. self.a},
			--{text = "B:" .. self.b},
		}
	end 



	ObjectUpdater:Add{o}

	return o

end



ObjectUpdater:AddStatic(Link)

return Link


-- notes
-------------------------------------
-- b gets applied to a
-- a should always be a 

-- try passing objects and then what you want from them seperatelys
















--]]