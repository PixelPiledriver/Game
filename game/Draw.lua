-- Draw.lua

-- Draw component
-- handles small draw things
-- but uses the Draw function you give it



local Draw = {}


function Draw:New(data)

	local o = {}

	o.parent = data.parent
	o.drawCall = data.parent.DrawCall or data.drawFunc
	--o.layer = data.layer or 1
	o.depth = data.depth or 1


	---------------
	-- Functions
	---------------

	-- might need to do this manually
	-- but lets let ObjectUpdater take care of it for now
	function o:Update()
		DrawList:Submit
		{
			o = self.parent,
			depth = self.depth
		}
	end 

	function o:Draw()
		self.drawCall(self.parent)
	end 


	ObjectUpdater:Add{o}

	return o

end


-- add this as a feature
--[[
	function o:ToggleDraw()
		self.draw = Bool:Toggle(self.draw)

		for i=1, #self.objects do
			if(self.objects[i].ToggleDraw) then
				self.objects[i]:ToggleDraw()
			else
				self.objects[i].draw = self.draw
			end 

		end 		
	end
--]]




----------------------
-- Static Functions
----------------------


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

-- gonna turn this into a proper draw component
-- draw function is not defined as part of component
-- pass the draw function of an object to this and it will run it for it
-- the reason we need this is to handle shit like DrawList:Submit and stuff
-- so it doesnt need to be typed in all over the place
