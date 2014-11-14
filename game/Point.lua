-- Point.lua
-- basic point graphic object

local ObjectUpdater = require("ObjectUpdater")
local Color = require("Color")
local Fade = require("Fade")
local Life = require("Life")
local Size = require("Size")

love.graphics.setPointStyle("rough")

local Point = {}


function Point:New(data)

	local o = {}

	---------------	
	-- Create
	---------------

	-- object
	o.name = data.name or "..."
	o.type = "Point"


	-- vars
	o.x = data.x or 100
	o.y = data.y or 100
	o.size = data. size or 10
	o.color = data.color and Color:Get(data.color) or  Color:Get("red")



	------------------------
	-- Components
	------------------------
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

	if(data.sizeSpeed) then
		o.Size = Size:New
		{
			speed = data.sizeSpeed,
			parent = o,
			size = data.size
		}
	end 


	---------------
	-- Functions
	---------------

	function o:Update()
	end 

	function o:Draw()
		love.graphics.setColor(Color:AsTable(self.color))
		love.graphics.setPointSize(self.size)
		love.graphics.point(self.x, self.y)
	end 


	function o:Destroy()
		ObjectUpdater:Destroy(self.Fade)
		ObjectUpdater:Destroy(self.Size)
	end 


	ObjectUpdater:Add{o}

	return o

end 











return Point