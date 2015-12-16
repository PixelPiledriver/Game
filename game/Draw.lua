-- Draw.lua


-- Purpose
----------------------------
-- Component
-- handles rendering its parent object



-------------------------------------------------------------------

local Draw = {}


------------------
-- Static Info
------------------
Draw.Info = Info:New
{
	objectType = "Draw",
	dataType = "Graphics",
	structureType = "Static"
}


----------------------
-- Static Vars
----------------------

Draw.defaultDraw =
{
	parent = o,
	layer = "Objects",
	layer = "Objects",
}



---------------------
-- Static Functions
---------------------

-- creat component
-- data = {parent, layer, *drawFunc, *first, *last}
function Draw:New(data)

	local o = {}


	------------------
	-- Object Info
	------------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Draw",
		dataType = "Graphics",
		structureType = "Component"
	}


	----------------
	-- Vars
	----------------

	o.parent = data.parent
	o.drawCall = data.parent.DrawCall or data.drawFunc
	o.useExternalDrawCall = data.useExternalDrawCall or false

	-- other
	o.first = data.first or false
	o.last = data.last or false
	o.inGroup = false
	o.isGroup = false
	o.drawList = data.drawList or nil

	local byName = data.byName or true

	if(byName) then
		o.layer = data.layer and DrawList:GetLayer(data.layer)
	
		if(o.layer == nil) then
			o.layer = 3
		end 

	else
		o.layer = data.layer or 1
	end 

	o.active = data.active or true

	-- get depth function
	-- defined per object
	-- so that they can control their depth
	o.depth = 0


	---------------
	-- Functions
	---------------

	
	-- currently ObjectManager takes care of this like any other object
	-- but actually this needs to update after all other objects
	function o:Update()
		self:CalculateCurrentDepth()
		self:SubmitToDrawList()
	end 

	-- get depth from parent
	function o:CalculateCurrentDepth()

		local currentDepth = 0

		if(self.parent.GetDepth) then
			currentDepth = self.parent.GetDepth(self.parent)
		end 

		self.depth = currentDepth

	end 

	-- send draw data to be drawn
	function o:SubmitToDrawList()

		if(self.inGroup) then
			return
		end

		if(self.active == false)then
			return
		end 

		local drawData =
		{
			o = self.parent,
			layer = self.layer,
			depth = self.depth
		}

		if(self.first) then
			DrawList:SubmitFirst(drawData)
		elseif(self.last) then
			DrawList:SubmitLast(drawData)
		else
			if(self.drawList == "static") then
				DrawList:SubmitStatic(drawData)
			else
				DrawList:Submit(drawData)
			end 
		end 

	end

	function o:GetDrawData()

		local drawData =
		{
			o = self.parent,
			layer = self.layer,
			depth = self.depth
		}

		return
		
	end 

	-- for use by other objects that take control of this component --> DrawGroup
	-- this function is pointless but will leave for now
	-- used to be used by draw group but is not needed
	-->DEPRICATED 6-22-2015
	function o:SubmitToDrawListManual()

		local drawData =
		{
			o = self.parent,
			layer = self.layer,
			depth = self.depth
		}

		if(self.first) then
			DrawList:SubmitFirst(drawData)
		elseif(self.last) then
			DrawList:SubmitLast(drawData)
		else
			DrawList:Submit(drawData)
		end 

	end 

	-- calls DrawCall function of the parent
	-- this allows Draw to do simple management
	-- but the parent defines a custom draw call :D
	function o:Draw()

		if(self.active == false) then
			return
		end 

		self.parent.DrawCall(self.parent)

	end 

	-- turn on/off drawing for this object
	function o:ToggleDraw()

		if(self.active) then
			self.active = false
		else
			self.active = true
		end 

	end 

	function o:Destroy()
		ObjectManager:Destroy(self.Info)
	end 


	----------
	-- End
	----------

	ObjectManager:Add{o}

	return o

end


-- love.graphics.draw() wrapper
-- calls love.graphics.draw()
-- with a table --> use any order or optional
-- {drawable, x, y, r, sx, sy, ox, oy, kx, ky} -- love names
-- {object, x, y, rot, xScale, yScale, xOffset, yOffset, xShear, yShear} -- actual names
-- this might not be the best place for this anymore 
-->MOVE
function Draw:LoveDraw(data)

	-- defaults
	--> add a "missing texture/graphics" image to project
	local drawable = data.object -- or "missing graphics"
	local x = data.x or 0
	local y = data.y or 0
	local r = data.rot or 0
	local sx = data.xScale or 1
	local sy = data.yScale or 1
	local ox = xOffset or 0
	local oy = yOffset or 0
	local kx = xShear or 0
	local ky = yShear or 0

	love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end



---------------
-- Static End
---------------

ObjectManager:AddStatic(Draw)

return Draw




-- Notes
-----------------
-- Draw does not have a defined DrawCall
-- uses the DrawCall function you give it
-- so that it may be customised for each type of object

-- DONE
-- gonna turn this into a proper draw component
-- draw function is not defined as part of component
-- pass the draw function of an object to this and it will run it for it
-- the reason we need this is to handle stuff like DrawList:Submit and stuff
-- so it doesnt need to be typed in all over the place
