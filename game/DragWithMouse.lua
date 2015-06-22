-- DragWithMouse.lua
-->DEPRICATED 6-22-2015

-- Purpose
----------------------------
-- Component
-- handles drag and drop with mouse interaction for parent



------------------------------------------------------------------------

local DragWithMouse = {}


------------------
-- Static Info
------------------

DragWithMouse.name = "DragWithMouse"
DragWithMouse.oType = "Static"
DragWithMouse.dataType = "Component Constructor"


----------------------
-- Static Functions
----------------------


function DragWithMouse:New(data)

	local o = {}

	------------------
	-- Object Info
	------------------
	o.name = "..."
	o.oType = "DragWithMouse"
	o.dataType = "Input Component"

	----------------
	-- Vars
	----------------
	o.parent = data.parent
	o.drag = false
	o.mouseButton = data.mouseButton or "r"

	-----------------------
	-- Functions
	-----------------------

	-- activate or deactivate the drag state
	function o:Drag()
		
		if(self.parent == nil) then
			return
		end 

		if(and self.drag == false) then
			if(love.mouse.isDown(self.mouseButton)) then
				self.drag = true
		end 

		if(self.drag = true) then
			--self.last

		end 

	end

	function o:Update()

	end 

	ObjectUpdater:Add{o}

	return o
end




return DragWithMouse


-- Notes
-------------------------------------
-- this file is not actually working
-- there isnt any code that makes it do its purpose
-->DEPRICATED 6-22-2015
-- MouseDrag.lua is a working version of the same functionality