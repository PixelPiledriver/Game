-- Draw.lua

-- Draw component
-- handles small draw things
-- but uses the Draw function you give it



local Draw = {}

Draw.name = "Draw"
Draw.oType = "Static"
Draw.dataType = "Graphics Constructor"



function Draw:New(data)

	local o = {}

	o.name = data.name or "..."
	o.oType = "Draw"
	o.dataType = "Graphics"

	o.parent = data.parent
	o.drawCall = data.parent.DrawCall or data.drawFunc
	o.useExternalDrawCall = data.useExternalDrawCall or false

	-- other
	o.first = data.first or false
	o.last = data.last or false
	o.inGroup = false
	o.isGroup = false

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

	-- might need to do this manually
	-- but lets let ObjectUpdater take care of it for now
	-- seems to work ok I guess :D
	function o:Update()

		self:CalculateCurrentDepth()
		self:SubmitToDrawList()

	end 

	function o:CalculateCurrentDepth()

		local currentDepth = 0

		if(self.parent.GetDepth) then
			currentDepth = self.parent.GetDepth(self.parent)
		end 

		self.depth = currentDepth

	end 

	function o:SubmitToDrawList()

		if(self.inGroup) then
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
			DrawList:Submit(drawData)
		end 

	end

	-- for use by other objects that take control of this component --> DrawGroup
	-- this function is pointless but will leave for now
	-- used to be used by draw group but is not needed
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


	ObjectUpdater:Add{o}

	return o

end


----------------------
-- Static 
----------------------

Draw.defaultDraw =
{
	parent = o,
	layer = "Objects",
	layer = "Objects",
}



-- calls love.graphics.draw()
-- with a table --> use any order or optional
-- {drawable, x, y, r, sx, sy, ox, oy, kx, ky} -- love names
-- {object, x, y, rot, xScale, yScale, xOffset, yOffset, xShear, yShear} -- actual names
function Draw:Draw(data)

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


ObjectUpdater:AddStatic(Draw)

return Draw




-- Notes
-----------------

-- DONE
-- gonna turn this into a proper draw component
-- draw function is not defined as part of component
-- pass the draw function of an object to this and it will run it for it
-- the reason we need this is to handle shit like DrawList:Submit and stuff
-- so it doesnt need to be typed in all over the place
