-- Arrow.lua

-- Purpose
----------------------
-- used for pointing at stuff
-- has arrow head styling
-- has cool features that make it much more useful than just a line

----------------
-- Requires
----------------
local Line = require("Line")
local Polygon = require("Polygon")
local Pos = require("Pos")
local Color = require("Color")

------------------------------------------------------------------

local Arrow = {}

-------------------
-- Static Info
-------------------
Arrow.Info = Info:New
{
	objectType = "Arrow",
	dataType = "Hud",
	structureType = "Static"
}

------------------
-- Static Vars
------------------

Arrow.visualStyle = {}
Arrow.visualStyle.options = {"line", "polygon", "pixelBox"}
Arrow.visualStyle.default = "line"


------------
-- Object
------------
function Arrow:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Arrow",
		dataType = "Hud",
		structureType = "Object"
	}

	-----------
	-- Vars
	-----------
	o.origin = data.origin or "end" -- "start" or "end"
	o.Pos = Pos:New
	{
		x = data.x or Window.width * 0.5,
		y = data.y or 100
	}

	---------------
	-- Graphics
	---------------

	o.visualStyle = data.visualStyle or self.visualStyle.default

	o.direction = {}
	o.direction.x = 0
	o.direction.y = 0

	o.angle = data.angle or 90

	o.length = data.length or 100
	o.headLength = data.headLength or 25
	
	o.headRelativeToLength = Bool:DataOrDefault(data.headRelativeToLength, true)

	-- scale head length to better match stem length?
	if(o.headRelativeToLength) then
		o.headLength = o.length * 0.25
	end 

	o.width = data.width or 1

	o.color = data.color or Color:Get("white")


	-- store all vectors used to make the lines
	-- will be useful for animation and other things
	o.vectors = {}

	-- create graphics objects based on visual style
	function o:CreateLineStyle()

		-- get vector for stem
		local vector = Math:AngleToVector(self.angle)

		-- scale to length
		vector.x = vector.x * self.length
		vector.y = vector.y * self.length

		-- create stem
		o.stem = Line:New
		{
			a = {x = self.Pos.x, y = self.Pos.y},
			b = {x = self.Pos.x + vector.x, y = self.Pos.y - vector.y},
			color = self.color,
			width = self.width,
			showNormal = false
		}

		-- get vector for arrow head
		vector = Math:AngleToVector(self.angle + 45)

		-- scale to head length 
		vector.x = vector.x * self.headLength
		vector.y = vector.y * self.headLength

		-- create head
		-- this only works if origin is head
		-- need to put in a coditional here
		-- but this is fine for now :P
		-->FIX
		o.headLeft = Line:New
		{
			a = {x = self.Pos.x, y = self.Pos.y},
			b = {x = self.Pos.x + vector.x, y = self.Pos.y - vector.y},
			color = self.color,
			width = self.width,
			showNormal = false
		}

		-- get vector for arrow head other side
		vector = Math:AngleToVector(self.angle - 45)

		-- scale to head length 
		vector.x = vector.x * self.headLength
		vector.y = vector.y * self.headLength

		o.headRight = Line:New
		{
			a = {x = self.Pos.x, y = self.Pos.y},
			b = {x = self.Pos.x + vector.x, y = self.Pos.y - vector.y},
			color = self.color,
			width = self.width,
			showNormal = false
		}

--]]

	end 

	function o:CreatePolygonStyle()
	end 

	function o:CreatePixelBoxStyle()
	end

	o.visualStyleFunctions = 
	{
		line = o.CreateLineStyle,
		polygon = o.CreatePolygonStyle,
		pixelBox = o.CreatePixelBoxStyle
	}

	o.visualStyleFunctions[o.visualStyle](o)




	---------
	-- End
	---------

	ObjectManager:Add{o}

	return o

end 



----------------
-- Static End
----------------

ObjectManager:AddStatic(Arrow)

return Arrow

