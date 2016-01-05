-- Polygon.lua

-- Purpose
---------------
-- vert based convex shape
-- use to make triangles

---------------
-- Requires
---------------

local Draw = require("Draw")
local Color = require("Color")
local Pos =require("Pos")

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

	local o = {}

	printDebug{"Polygon:New", "Polygon"}
	-----------
	-- Info
	-----------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Polygon",
		dataType = "Graphics",
		structureType = "Object"
	}

	------------
	-- Vars
	------------
	o.verts = data.verts or 0

	o.color = data.color or Color:Get("white")
	o.fill = data.fill or false


	local defaultDraw =
	{
		parent = o,
		layer = data.layer or "Objects",
		GetDepth = o.GetDepth,
		first = data.first or false,
		last = data.last or false,
	}

	o.Draw = Draw:New(data.Draw or defaultDraw)

	---------------------------------------
	-- Pos - control pos for all verts
	---------------------------------------

	o.Pos = nil

	if(data.x or data.y) then
		o.Pos = Pos:New
		{
			x = data.x or 0,
			y = data.y or 0
		}
	end 

	if(o.Pos) then
		o.usePos = true
	end 


	-----------------------
	-- Functions
	-----------------------

	function o:DrawCall()

		if(self.fill == false) then
			--love.graphics.setWireframe(true)
		end 
		
		love.graphics.setColor(Color:AsTable(self.color))
		love.graphics.polygon("fill", o:GetVertList())

	end


	function o:Move()		
	end


	-- returns all the verts in a single table
	function o:GetVertList()
	
		local tempVerts =  {}

		local xAdd = 0
		local yAdd = 0

		if(self.usePos) then
			xAdd = self.Pos.x
			yAdd = self.Pos.y
		end 

		for i=1, #self.verts do
			tempVerts[#tempVerts+1] = self.verts[i].x + xAdd
			tempVerts[#tempVerts+1] = self.verts[i].y + yAdd
		end

		return tempVerts

	end

	function o:Mouse()
		self.verts[1].x = love.mouse.getX()
		self.verts[1].y = love.mouse.getY()
	end


	function o:Update()
		--self:Mouse()
	end 

	function o:Destroy()
		ObjectManager:Destroy(o.Info)
		ObjectManager:Destroy(o.Pos)
		ObjectManager:Destroy(o.Draw)
	end 

	ObjectManager:Add{o}

	return o
end



return Polygon