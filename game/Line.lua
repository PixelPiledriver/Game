-- Line.lua

------------------
-- Requires
------------------
local Color = require("Color")
local Life = require("Life")
local Fade = require("Fade")
local Draw = require("Draw")

-------------------------------------------------------------------

local Line = {}

-----------------
-- Static Info
-----------------
Line.Info = Info:New
{
	objectType = "Line",
	dataType = "Graphics",
	structureType = "Static"
}

---------------------
-- Static Functions
---------------------

-- {a = {x,y}, b = {x,y}, width, color}
function Line:New(data)

	local o = {}

	--------------------------
	-- Object Info
	--------------------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Line",
		dataType = "Graphics",
		structureType = "Object"
	}


	------------
	-- Vars
	------------
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

	local defaultDraw =
	{
		parent = o,
		layer = "Objects",
		GetDepth = o.GetDepth,
		first = data.first or false,
		last = data.last or false,
	}

	o.Draw = Draw:New(defaultDraw)

	o.components = {"Life", "Fade"}

	-----------------
	-- Functions
	-----------------
	function o:Update()
	end 

	function o:DrawCall()
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
			{text = "Name: " .. self.Info.name},
			{text = "A: {" .. self.a.x .. "," .. self.a.y .. "}"},
			{text = "B: {" .. self.b.x .. "," .. self.b.y .. "}"},
			{text = "LifeCompValue: " .. life},
			{text = "Alpha: " .. self.color.a},
			{text = "Fade: " .. self.Fade.fade}
		}

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



--




return Line