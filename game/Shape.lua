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

	object.boxes = {}

	print("stuff")

	for i=1, #data.boxes do
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
		Box:New
		{
		  x = 100,
		  y = 100,
			height = 100,
			width = 10,
			color = Color:Get("white"),

			rotatable = true,
			
			draw = true
		},

		Box:New
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