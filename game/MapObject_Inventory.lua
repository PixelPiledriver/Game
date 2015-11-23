-- MapObject.Inventory.lua

-- Purpose
-------------------------------------
-- MapObjects can hold items

--------------
-- Requires
--------------
local MapObject = require("MapObject")

-------------------------------------------------
-- Sub-Component
MapObject.Inventory = {}


--------------
-- Object
--------------

function MapObject.Inventory:New(data)

	local o = {}

	o.items = {nil}

	o.selectedIndex = 1

	o.maxItems = 10


	------------------------
	-- Functions
	------------------------
	function o:Add(data)
		-- add object to .items -->DO
		-- if first item set selected -->DO
	end 

	-- remove from inventory and place on floor
	function o:Drop(data)
		
		self.items[self.selectedIndex] = nil
		-- create item as MapObject on map -->DO
	end 

	function o:Next()
		self.selectedIndex = self.selectedIndex + 1

		if(self.selectedIndex > self.maxItems) then
			self.selectedIndex = self.maxItems
		end

	end

	function o:UseSelectedItem()
		self.items[self.selectedIndex]:Use()
	end 


end 









-- need MapObjects_Item.lua

