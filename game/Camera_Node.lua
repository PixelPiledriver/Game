-- Camera_Node.lua

-- Purpose
------------------------
-- controls movement of camera with list of positions to go to
-- not gonna use this file until I have to 


-------------------------------------------

-- sub component
Camera.Node = {}



---------------
-- Functions
---------------

function Camera.Node:SetupCamera(index)
	Camera.cameras[index].moveNodes = {}
	Camera.cameras[index].moveIndex = 1


	function o:UpdateMoveNodes()

		-- node control doesnt exist?
		if(self.moveNodes == nil) then
			return
		end 

		-- no nodes in list?
		if(#self.moveNodes == 0) then
			return 
		end 


		local tempVector = 
		{
			x = self.moveNodes[self.moveIndex].x - self.Pos.x,
			y = self.moveNodes[self.moveIndex].y - self.Pos.y
		}

		local tempUnitVector = Math:UnitVector(tempVector)

		tempUnitVector.x = tempUnitVector.x * self.moveSpeed
		tempUnitVector.y = tempUnitVector.y * self.moveSpeed

		print(tempUnitVector.x .. ", " .. tempUnitVector.y)

	end

end












