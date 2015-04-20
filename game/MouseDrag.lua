-- MouseDrag.lua
-- Component
-- makes object drag and droppable

local ObjectUpdater = require("ObjectUpdater")

local MouseDrag = {}

-- Static Vars
----------------------------

MouseDrag.name = "MouseDrag"
MouseDrag.oType = "Static"
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

	function o:MoveObjecToMouse()
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
		self:MoveObjecToMouse()
	end 

	ObjectUpdater:Add{o}

	return o

end


return MouseDrag


-- Notes
-----------------------------
--[[
	-- right click to drag a button
	function o:ClickToMove()

		if(self.hover == true and Button.buttonBeingDragged == false) then
			if(love.mouse.isDown("r")) then
				self.move = true
				Button.buttonBeingDragged = true
			end 
		end 

		if(self.move == true) then
			self.move = true
			self.lastX = love.mouse.getX() - self.Pos.x
			self.lastY = love.mouse.getY() - self.Pos.y
		end 


		-- drop
		if(self.move == true and love.mouse.isDown("r") == false) then
			self.move = false
			Button.buttonBeingDragged = false
		end 

	end 

	--]]