-- LifeBar.lua

-- Purpose
--------------------------------------
-- fighting game style life bar
-- simple for now


--------------
-- Requires
--------------
local Box = require("Box")
local Pos = require("Pos")
local Color = require("Color")
local Arrow = require("Arrow")
-----------------------------------------------
local LifeBar = {}

-----------------
-- Static Info
-----------------
LifeBar.Info = Info:New
{
	objectType = "LifeBar",
	dataType = "FightingGameHUD",
	structureType = "Static"
}

--------------
-- Object
--------------

function LifeBar:New(data)
	
	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "LifeBar",
		dataType = "FightingGameHUD",
		structureType = "Object"
	}

	------------
	-- Vars
	------------
	o.max = data.max or 100
	o.hitpoints = o.max
	o.min = data.min or 0
	o.scale = data.scale or 2
	o.align = data.align or "right"
	o.dead = false

	o.player = nil

	o.Pos = Pos:New
	{
		x = data.x or 400,
		y = data.y or 100
	}

	--------------
	-- Graphics
	--------------

	-- color of lifebar changes as the value changes
	o.valueColors = 
	{
		Color:Get("green"), 
		Color:Get("orange"),
		Color:Get("red")
	}

	o.color = o.valueColors[1]

	-- simple box type
	o.box = Box:New
	{
		width = 100,
		height = 25,
		x = o.Pos.x,
		y = o.Pos.y,
		color = o.color
	}

	o.framePadX = 6
	o.framePadY = 8

	-- align frame
	local frameX = 0

	if(o.align == "right") then
		frameX = o.box.Pos.x - o.box.Size.width * o.scale
	end

	if(o.align == "left") then
		frameX = o.box.Pos.x
	end 


	o.frame = Box:New
	{
		width = o.box.Size.width * o.scale + o.framePadX,
		height = o.box.Size.height + o.framePadY,
		x = frameX,
		y = o.box.Pos.y - o.framePadY/2,
		drawMode = "line"
	}



	------------------
	-- Functions
	------------------

	function o:Update()

		-- keep hit points in min/max range
		self:Bound()


		-- set lifebar to size of current value
		self.box.Size.width = self.hitpoints * self.scale

		-- align box 
		if(self.align == "right") then
			self.box.Pos.x = self.Pos.x - self.box.Size.width
		end 

		if(self.align == "left") then
			self.box.Pos.x = self.Pos.x
		end 
		
		-- test damage
		--self:Damage(1)


		-- change color to match value
		local index = math.modf(#self.valueColors - (self.hitpoints / (self.max / #self.valueColors)) + 1)
		if(index >= #self.valueColors+1) then
			index = #self.valueColors
		end 
		
		self.color = self.valueColors[index]
		self.box.color = self.color

	end 

	function o:Bound()

		if(self.hitpoints > self.max) then
			self.hitpoints = self.max
		end 

		if(self.hitpoints < self.min) then
			self.hitpoints = self.min
		end 

	end 

	function o:Damage(value)
		self.hitpoints = self.hitpoints - value
	end 

	function o:Heal(value)
		self.hitpoints = self.hitpoints - value
	end 


	----------
	-- End
	----------

	ObjectManager:Add{o}

	return o

end 


------------------
-- Static End
------------------

ObjectManager:AddStatic(LifeBar)


return LifeBar