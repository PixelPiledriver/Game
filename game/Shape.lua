-- Shape
-- object with multiple boxes inside of it


local Box = require("Box")
local Color = require("Color")
local Shape = {}


---------------
-- Create
---------------

function Shape:New(data)

	local object = {}

	object.x = data.x or 100
	object.y = data.y or 100
	object.boxes = {}

	print("stuff")


	for i=1, #data.boxes do
		data.boxes[i].x = object.x + data.boxes[i].x
		data.boxes[i].y = object.y + data.boxes[i].y
		object.boxes[#object.boxes+1] = Box:New(data.boxes[i])
	end 

	return object
end 


-----------------------
-- Shapes
------------------------

Shape.cross = Shape:New
{
	boxes =
	{
		{
		  x = 100,
		  y = 100,
			height = 100,
			width = 10,
			color = Color:Get("white"),

			rotatable = true,
			
			draw = true
		},

		{
			x = 100,
		  y = 100,
			width = 100,
			height = 10,
			color = Color:Get("white"),

			rotatable = true,
			
			draw = true
		}

	}
}





return Shape 