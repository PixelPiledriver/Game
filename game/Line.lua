-- Line.lua

local ObjectUpdater = require("ObjectUpdater")
local Color = require("Color")
local Life = require("Life")
local Fade = require("Fade")



local Line = {}

-----------------------------------------------------
-- New o
-----------------------------------------------------

-- {a = {x,y}, b = {x,y}, width, color}
function Line:New(data)

	local o = {}

	--------------------------
	-- Create
	--------------------------

	-- object
	o.name = data.name or "..."
	o.type = "Line"


	-- start
	o.a = {}
	o.a.x = data.a and data.a.x or 0
	o.a.y = data.a and data.a.y or 0

	-- end
	o.b = {}
	o.b.x = data.b and data.b.x or 100
	o.b.y = data.b and data.b.y or 100

	-- graphics
	o.color = data.color and Color:Get(data.color) or Color:Get("black")
	o.width = data.width or 1




	------------------------
	-- Components
	------------------------
	if(data.life) then
		o.Life = Life:New
		{
			life = data.life,
			maxLife = data.maxLife,
			drain = data.drain,
			parent = o
		}
	end 

	if(data.fade) then	
		o.Fade = Fade:New
		{
			parent = o,
			fadeWithLife = data.fadeWithLife or false
		}
	end 

	-----------------
	-- Functions
	-----------------

	function o:Update()
	end 

	function o:Draw()
		love.graphics.setLineWidth(self.width)
		love.graphics.setColor(Color:AsTable(self.color))
		love.graphics.line(self.a.x, self.a.y, self.b.x, self.b.y)
		love.graphics.setLineWidth(1)
	end

	function o:PrintDebugText()

		local life = self.Life and self.Life.life or 0

		DebugText:TextTable
		{
			{text = "", obj = "Line" },
			{text = "Name: " .. self.name},
			{text = "A: {" .. self.a.x .. "," .. self.a.y .. "}"},
			{text = "B: {" .. self.b.x .. "," .. self.b.y .. "}"},
			{text = "LifeCompValue: " .. life}
		}

	end 


	function o:Destroy()
		ObjectUpdater:Destroy(self.Fade)
	end 


	ObjectUpdater:Add{o}

	return o

end 



--




return Line