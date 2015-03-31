

local ObjectUpdater = require("ObjectUpdater")


local HoverWithMouse = {}

function HoverWithMouse:New(data)

	local o = {}


	o.hoverType = data.hoverType or "parentCollision"
	o.parent = data.parent or nil
	o.hover = false

	o.PrintDebugTextActive = true

	


	function o:Update()
		self:CheckForHover()
	end 

	function o:CheckForHover()

		-- use collision component? or use object size
		if(self.hoverType == "parentCollision") then

			-- this component has a parent and collides with mouse?
			if(self.parent and self.parent.collision and self.parent.collision:DoesCollideWith("Mouse")) then
				if(self.parent.collision.collidedLastFrame) then
					self.hover = true
				else
					self.hover = false
				end 

			end 

		-- add other collision types here
		-- objectCollision --> size
		-- direct link to a collision component

		end 

	end

	function o:PrintDebugText()

		if(self.PrintDebugTextActive == false) then
			return
		end 

		DebugText:TextTable
		{
			{text = "", obj = "HoverWithMouse"},
			{text = "Hover:" .. Bool:ToString(self.hover)}
		}

		--[[
		DebugText:TextTableSimple
		{
			objectType = "HoverWithMouse",
			text =
			{
				{"Hover"},
				{"+-----------+"},
				{Bool:ToString(self.hover)}
			}
		}
		--]]

	end

	ObjectUpdater:Add{o}

	return o

end 



return HoverWithMouse