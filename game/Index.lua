-- Index.lua

-- Purpose
-----------------------
-- index value used for stepping thru tables

--------------------------------------------
-- global
Index = {}

------------
-- Object
------------

function Index:New(table)

	-----------
	-- Fails
	-----------
	if(table == nil) then
		print("table required!")
		return
	end 

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = "...",
		objectType = "Index",
		dataType = "Data",
		structureType = "Object"
	}

	----------
	-- Vars
	----------
	o.index = 1

	o.min = 1
	o.table = table
	o.maxOffset = 0

	----------------
	-- Functions
	----------------

	-- .index++
	function o:Plus()
		self.index = self.index + 1

		if(self.index > #self.table + self.maxOffset) then
			self.index = #self.table + self.maxOffset
		end 

	end 

	-- .index--
	function o:Minus()
		self.index = self.index - 1

		if(self.index < 1) then
			self.index = 1
		end 

	end 

	-- shortcut to .Plus
	function o:P()
		self:Plus()
	end 

	-- shortcut to .Minus
	function o:M()
		self:Minus()
	end

	-- check if index is at max length of table
	function o:IsMax()
		if(self.index == #self.table + self.maxOffset) then
			return true
		end 

		return false
	end 


	-- find out if index is within range of the given tables length
	function o:IsIndexInTable(tableToCheck)

		-- nothing in table
		if(#tableToCheck == 0) then
			return false
		end 

		-- yes
		if(#tableToCheck >= self.index) then
			return true
		end 

		-- no
		return false

	end 

	function o:Set(table)
	end 

	--------
	-- End
	--------

	return o
end 

---------------
-- Static End
---------------

ObjectManager:AddStatic(Index)

return Index







-- Notes
---------------------------------------------------------
-- this object is useful when paired with a table
-- acts as an outside variable to hold the place of an index to access the table

