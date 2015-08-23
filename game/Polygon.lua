-- Polygon.lua

-- Purpose
---------------
-- oooooooooooooooooo
-- triiiiiiiiiiiiiiiiiiiiiiiangles
-- we need triiiiiiiiiiiiiiiiiiiiiiiangles

---------------
-- Requires
---------------

local Color = require("Color")

-----------------------------------------------------------------

local Polygon = {}

-----------------
-- Static Info
-----------------
Polygon.Info = Info:New
{
	objectType = "Polygon",
	dataType = "Graphics",
	structureType = "Static"
}

-----------
-- Object
-----------

--{x, y, verts{ {}, {}, {} } }
function Polygon:New(data)

	local object = {}

	-----------
	-- Info
	-----------
	Info:ObjectOf
	{
		static = self,
		o = o,
		data = data
	}

	object.verts = data.verts or 0

	object.color = data.color or Color:Get("white")
	object.fill = data.fill or false

	-----------------------
	-- Functions
	-----------------------

	function object:Draw()

		if(self.fill == false) then
			love.graphics.setWireframe(true)
		end 

		
		love.graphics.setColor(self.color)
		love.graphics.polygon("fill", self:GetAllVerts())

	end


	function object:Move()		
	end


	-- returns all the verts in a single table
	function object:GetAllVerts()
	
		local v =  {}

		for i=1, #self.verts do
			v[#v + 1] = self.verts[i].x
			v[#v + 1] = self.verts[i].y
		end

		return v

	end

	function object:Mouse()
		self.verts[1].x = love.mouse.getX()
		self.verts[1].y = love.mouse.getY()
	end


	function object:Update()
		self:Mouse()
	end 


	ObjectUpdater:Add{object}

	return object
end



return Polygon