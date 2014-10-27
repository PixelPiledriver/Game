-- Palette.lua
-- color palette
-- store and do cool stuff with colors

local Color = require("Color")
local Random = require("Random")
local Value = require("Value")


local Palette = {}



--{colors, }
function Palette:New(data)

	local object = {}


	---------------
	-- Create
	---------------
	object.colors = data.colors or {}

	-- size = max, not just length of color table
	object.size = data.size or 0 


	-----------------
	-- Functions
	-----------------

	function object:Clear()
		self.colors = nil
		self.colors = {}

		self.index = nil
		self.index = {}
	end 

	function object:Get(index)
		return self.colors[index]
	end 


	-- {size}
	function object:Random(data)
		self:Clear()

		for i=1, data.size do
			self.colors[i], self.index[i] = Color:Get("random")
		end 
	end

	-- create linear palette from colorA -> size ->colorB lerp
	-- {a, b, size}
	function object:Linear(data)
		self:Clear()

		self.colors[1], self.index[1] = Color:Get(data.a)
		self.colors[data.size], self.index[data.size] = Color:Get(data.b)

		for i=2, data.size-1 do
			self.colors[i] = Color:Lerp
			{
				a = Color:Get(data.a),
				b = Color:Get(data.b),
				t = 1/data.size * i
			}
		end 


	end 



	return object

end 


-- create a new random palette
-- {size}
function Palette:NewRandom(data)

	local p = Palette:New{}
	p:Random{size = data.size}

	return p

end 










return Palette





-- add in palette types
-------------------------------------------
-- linear, bilinear, etc