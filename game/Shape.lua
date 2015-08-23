-- Shape
-- Group of other objects with multiple boxes inside of it


-- Rruqi
local Box = require("Box")
local Color = require("Color")

--------------------------------------------
local Shape = {}

----------------
-- Static Info
----------------

Shape.Info = Info:New
{
	objectType = "Shape",
	dataType = "Group",
	structureType = "Static"
}

---------------
-- Object
---------------

function Shape:New(data)

	local o = {}

	------------
	-- Info
	------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Shape",
		dataType = "Group",
		structureType = "Object"
	}

	o.x = data.x or 0
	o.y = data.y or 0
	o.boxes = {}

	for i=1, #data.boxes do
		data.boxes[i].x = o.x + data.boxes[i].x
		data.boxes[i].y = o.y + data.boxes[i].y
		o.boxes[#o.boxes+1] = Box:New(data.boxes[i])
	end 


	-------------------
	-- Functions
	-------------------

	--{x, y}
	function o:SetPos()

		for i=1, #self.boxes do
			self.boxes[i].x = self.x + self.boxes[i].xStart
			self.boxes[i].y = self.y + self.boxes[i].yStart
		end 

	end 

	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Shape" },
			{text = "Shape"},
			{text = "--------------------"},
			{text = "X: " .. self.x},
			{text = "Y: " .. self.y}
		}
	end 

	function o:Update()
		self:SetPos()
	end 


	function o:Destroy()
		for i=1, #self.boxes do
			ObjectUpdater:Destroy(self.boxes[i])
		end 
		
	end 

	ObjectUpdater:Add{o}

	return o
end 



-----------------------
-- Static Functions
-----------------------

function Shape:Get(data)
	self[data.shapeName].x = data.x or 0
	self[data.shapeName].y = data.y or 0
	return self:New(self[data.shapeName])
end 

-----------------------
-- Shapes
------------------------

Shape.cross = 
{
	name = "cross",
	boxes =
	{
		{
			name = "cross1",
			x = 9.5,
			y = 0,
			width = 1,
			height = 20,
			color = Color:Get("blue"),

			rotatable = true,
			fill = true,
			draw = true,
			spin = 3
		},

		{
			name = "cross2",
			x = 0,
			y = 9.5,
			width = 20,
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

-- Notes
-----------
-- This object is badly named, limited, and not so great
-- most likely dont need this
-- and will repurpose the name
-->DEPRICATE