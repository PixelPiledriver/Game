-- MouseHover.lua

-- Purpose
--------------
-- component that handles mouse interaction for objects

-----------------------------------------------------------------------

local MouseHover = {}

-------------------
-- Static Info
-------------------
MouseHover.Info = Info:New
{
	objectType = "MouseHover",
	dataType = "Input",
	structureType = "Static"
}

function MouseHover:New(data)

	local o = {}

	----------------
	-- Object Info
	----------------
	o.Info = Info:New
	{
		objectType = "MouseHover",
		dataType = "Input",
		structureType = "Component"
	}

	o.hoverType = data.hoverType or "parentCollision"
	o.parent = data.parent or nil
	o.collision = data.collision or data.parent.collision or nil
	o.isHovering = false

	o.PrintDebugTextActive = true




	function o:Update()
		self:CheckForHover()
	end 

	function o:CheckForHover()

		-- use collision component? or use object size
		if(self.hoverType == "parentCollision") then

			-- this component has a parent and collides with mouse?
			if(self.parent and o.collision and o.collision:DoesCollideWith("Mouse")) then
				if(o.collision.collidedLastFrame) then
					self.isHovering= true
				else
					self.isHovering= false
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
			{text = "", obj = "MouseHover"},
			{text = "Hover:" .. Bool:ToString(self.isHovering)}
		}

		--[[
		DebugText:TextTableSimple
		{
			objectType = "MouseHover",
			text =
			{
				{"Hover"},
				{"+-----------+"},
				{Bool:ToString(self.isHovering)}
			}
		}
		--]]

	end

	ObjectUpdater:Add{o}

	return o

end 



return MouseHover