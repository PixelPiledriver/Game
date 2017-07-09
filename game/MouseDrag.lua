-- MouseDrag.lua
-- Component
-- makes object drag and droppable


----------------------------------------------------------------

local MouseDrag = {}

-----------------
-- Static Info
-----------------
MouseDrag.Info = Info:New
{
	objectType = "MouseDrag",
	dataType = "Input",
	structureType = "Static"
}



MouseDrag.draggingObjects = 0
MouseDrag.maxDraggables = 1



-- Create
function MouseDrag:New(data)

	local o = {}

	----------------
	-- Object Info
	----------------
	o.Info = Info:New
	{
		objectType = "MouseDrag",
		dataType = "Input",
		structureType = "Component"
	}

	--------------
	-- Vars
	--------------

	o.parent = data.parent or nil
	o.drag = false
	o.mouseButton = data.mouseButton or 1

	o.offsetFromMouseX = 0
	o.offsetFromMouseY = 0

	o.xActive = Bool:DataOrDefault(data.xActive, true)
	o.yActive = Bool:DataOrDefault(data.yActive, true)




	-----------------------
	-- Functions
	-----------------------

	function o:MoveObjectToMouse()
		if(self.drag == false) then
			return 
		end 

		if(self.xActive) then
			self.parent.Pos.x = love.mouse.getX() - self.offsetFromMouseX
		end 

		if(self.yActive) then
			self.parent.Pos.y = love.mouse.getY() - self.offsetFromMouseY
		end 

	end 

	function o:Drag()
		
		if(self.parent == nil) then
			return
		end 

		if(self.parent.hover.isHovering == true and self.drag == false and MouseDrag.draggingObjects == 0) then
			if(love.mouse.isDown(self.mouseButton)) then
				self.drag = true
				self.offsetFromMouseX = love.mouse.getX() - self.parent.Pos.x
				self.offsetFromMouseY = love.mouse.getY() - self.parent.Pos.y

				-- drag limit
				MouseDrag.draggingObjects = 1
			end 
		end 

		-- let go of button? drop
		if(self.drag == true and love.mouse.isDown(o.mouseButton) == false) then

			self.drag = false

			-- reset offset
			self.offsetFromMouseX = 0
			self.offsetFromMouseY = 0

			-- drag limit
			MouseDrag.draggingObjects = 0
		end 

	end

	function o:Update()
		self:Drag()
		self:MoveObjectToMouse()
	end 

	function o:Destroy()
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.map)
		ObjectManager:Destroy(self.Draw)
	end 


	----------------
	-- End
	----------------

	ObjectManager:Add{o}

	return o

end


return MouseDrag


-- Notes
-----------------------------



