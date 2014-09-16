-- Shape
-- object with multiple boxes inside of it


local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")
local Color = require("Color")
local Shape = {}


---------------
-- Create
---------------


function Shape:New(data)

	local object = {}

	object.name = data.name or "???"
	object.type = "shape"

	object.x = data.x or 0
	object.y = data.y or 0
	object.boxes = {}


	for i=1, #data.boxes do
		data.boxes[i].x = object.x + data.boxes[i].x
		data.boxes[i].y = object.y + data.boxes[i].y
		object.boxes[#object.boxes+1] = Box:New(data.boxes[i])
	end 


	-------------------
	-- Functions
	-------------------

	--{x, y}
	function object:SetPos()

		for i=1, #self.boxes do
			self.boxes[i].x = self.x + self.boxes[i].xStart
			self.boxes[i].y = self.y + self.boxes[i].yStart
		end 

	end 

	function object:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Shape" },
			{text = "Shape"},
			{text = "--------------------"},
			{text = "X: " .. self.x},
			{text = "Y: " .. self.y}
		}
	end 

	function object:Update()
		self:SetPos()
	end 


	function object:Destroy()
		for i=1, #self.boxes do
			ObjectUpdater:Destroy(self.boxes[i])
		end 
		
	end 

	ObjectUpdater:Add{object}

	return object
end 



-----------------------
-- Static Functions
-----------------------

function Shape:Get(shapeName)
	return self:New(self[shapeName])
end 

-----------------------
-- Shapes
------------------------

Shape.cross = 
{
	boxes =
	{
		{
			x = 4.5,
			y = 0,
			width = 1,
			height = 10,
			color = Color:Get("blue"),

			rotatable = true,
			fill = true,
			draw = true,
			spin = 3
		},

		{
			x = 0,
			y = 4.5,
			width = 10,
			height = 1,
			color = Color:Get("darkBlue"),
			spin = 3, 
			rotatable = true,
			fill = true,
			draw = true
		}

	}
}







return Shape 