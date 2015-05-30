-- Point.lua
-- basic point graphic object

local Color = require("Color")

-- components
local Fade = require("Fade")
local Life = require("Life")
local Size = require("Size")
local Pos = require("Pos")

love.graphics.setPointStyle("rough")

local Point = {}

function Point:New(data)

	local o = {}

	---------------	
	-- Create
	---------------

	-- object
	o.name = data.name or "..."
	o.oType = "Point"
	o.dataType = "Graphics"

	-- vars
	o.size = data. size or 10


	local colorType = data.colorType or "name"

	if(colorType == "name") then
		o.color = data.color and Color:Get(data.color) or Color:Get("red")
	elseif(colorType == "new") then
		o.color = data.color
	end 

	------------------------
	-- Components
	------------------------
	o.Pos = Pos:New(data.pos or Pos.defaultPos)

	if(data.fade) then	
		o.Fade = Fade:New
		{
			parent = o,
			fadeWithLife = data.fadeWithLife or false
		}
	end 

	if(data.life) then
		o.Life = Life:New
		{
			life = data.life,
			maxLife = data.maxLife,
			drain = data.drain,
			parent = o
		}
	end 


	o.components = {"Pos", "Fade", "Size", "Life"}

	---------------
	-- Functions
	---------------

	function o:PrintDebugText()

		local life = self.Life and self.Life.life or 0

		DebugText:TextTable
		{
			{text = "", obj = "Point" },
			{text = "Name: " .. self.name},
			{text = "Type: " .. self.oType},
			{text = "Pos: {" .. self.Pos.x .. ", " .. self.Pos.y .. "}"},
		}

	end 


	function o:Update()
	end 


	function o:Draw()
		love.graphics.setColor(Color:AsTable(self.color))
		love.graphics.setPointSize(self.size)
		love.graphics.point(self.Pos.x, self.Pos.y)
	end 


	function o:Destroy()

		for i=1, #self.components do
			if(self[self.components[i]]) then
				ObjectUpdater:Destroy(self[self.components[i]])
			end 
		end 
	
	end 


	ObjectUpdater:Add{o}

	return o

end 




return Point