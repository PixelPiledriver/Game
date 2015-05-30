-- DragWithMouse.lua
-- Component
-- makes object drag and droppable


local DragWithMouse = {}

DragWithMouse.name = "DragWithMouse"
DragWithMouse.oType = "Static"
DragWithMouse.dataType = "Object Constructor"

function DragWithMouse:New(data)

	local o = {}

	o.parent = data.parent
	o.drag = false
	o.mouseButton = data.mouseButton or "r"

	-----------------------
	-- Functions
	-----------------------

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