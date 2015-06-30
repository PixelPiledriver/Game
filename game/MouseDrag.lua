-- MouseDrag.lua
-- Component
-- makes object drag and droppable


----------------------------------------------------------------

local MouseDrag = {}

-----------------
-- Static Info
-----------------

MouseDrag.name = "MouseDrag"
MouseDrag.objectType = "Static"
MouseDrag.dataType = "Object Constructor"

MouseDrag.draggingObjects = 0
MouseDrag.maxDraggables = 1



-- Create
function MouseDrag:New(data)

	local o = {}

	o.parent = data.parent or nil
	o.drag = false
	o.mouseButton = data.mouseButton or "l"

	self.offsetFromMouseX = 0
	self.offsetFromMouseY = 0

	-----------------------
	-- Functions
	-----------------------

	function o:MoveObjectToMouse()
		if(self.drag == false) then
			return 
		end 

		self.parent.Pos.x = love.mouse.getX() - self.offsetFromMouseX
		self.parent.Pos.y = love.mouse.getY() - self.offsetFromMouseY
	end 

	function o:Drag()
		
		if(self.parent == nil) then
			return
		end 

		if(self.parent.hover.hover == true and self.drag == false and MouseDrag.draggingObjects == 0) then
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

	ObjectUpdater:Add{o}

	return o

end


return MouseDrag


-- Notes
-----------------------------



