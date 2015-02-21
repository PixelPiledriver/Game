-- DragWithMouse.lua
-- Component
-- makes object drag and droppable



local DragWithMouse = {}

DragWithMouse.name = "DrawWithMose"
DragWithMouse.oType = "Static"
DragWithMouse.dataType = "Object Constructor"











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