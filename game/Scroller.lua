-- Scroller.lua



-- Requires
------------------------------

local Pos = require("Pos")
local Box = require("Box")
local SpriteBank = require("SpriteBank") --> unused so far
local Image = require("Image")

-------------------------------------------------------

local Scroller = {}

-------------------
-- Static Info
-------------------
Scroller.Info = Info:New
{
	objectType = "Scroller",
	dataType = "Level",
	structureType = "Static"
}


function Scroller:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Scroller",
		dataType = "Level",
		structureType = "Object"
	}

	------------
	-- Vars
	------------
	o.parent = data.parent or nil
	o.systemLayer = data.layer or 1
	o.drawLayer = "Scroll" .. o.systemLayer
	printDebug{o.drawLayer, "Scroller"}

	o.active = data.active or true

	o.x = nil
	o.y = nil

	-- determins what type of action this scroller will take
	-- loop, hide, destroy, stop

	o.start = data.start or 100
	o.finish = data.finish or -1

	o.onFinish =
	{
		loop = Bool:DataOrDefault(data.loop, true),
		stop = Bool:DataOrDefault(data.stop, true),
		hide = Bool:DataOrDefault(data.hide, false),
		destroy = Bool:DataOrDefault(data.destroy, true)
	}



	--------------
	-- Graphics
	--------------
	o.graphicsType = nila

	local dir = data.folder and data.folder .. "/" or "scroller/"

	-- use image?
	if(data.filename) then
		o.image = Image:New
		{
			filename = dir .. data.filename,
			layer = o.drawLayer,
			--shader = "scroller"
		}

		o.image.Pos.speed.x = data. speed or -20
		o.image.Pos.x = data.start or Window.width
		o.image.Pos.y = data.y or 0

		o.graphicsType = "image"
	
	else

		-- no image? --> use box
		o.box = Box:New
		{
			width = data.width or 32,
			height = data.height or 69,
			x = data.x or 100,
			y = data.y or 200	
		}

		o.box.Pos.speed.x = -10

		o.graphicsType = "box"

	end 
	
	-- select graphics to use	




	-------------------
	-- Functions
	-------------------

	function o:Update()

		-- move and wrap object --> scroll

		self:UpdatePos()
		self:UpdateSpeed()
		self:Finish()
	end

	function o:UpdatePos()
		self.x = self[self.graphicsType].Pos.x
		self.y = self[self.graphicsType].Pos.y
	end 

	function o:UpdateSpeed()
		self[self.graphicsType].Pos.speed.x = -(self.parent.layers[self.systemLayer].speed + self.parent.globalSpeed)
		self.image.shader.vars.speed = self.parent.layers[self.systemLayer].scrollSpeed
	end 

	function o:Finish()

		if(self.x < self.finish) then

			-- wrap around?
			if(self.onFinish.loop) then
				o[o.graphicsType].Pos.x = o.start		
			end 

			-- stop in place?
			if(self.onFinish.stop) then
				o[o.graphicsType].Pos.speed.x = 0
			end 

			-- destroy?
			if(self.onFinish.destroy) then
				ObjectManager:Destroy(self)
				printDebug{"kill it", "Scroller"}
			end 

			-- notify ScrollerSystem?
			if(self.parent) then
				self.parent:Next(self.systemLayer)
			end

		end

	end 

	-- remove this object from the game permanently
	function o:Destroy()
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.Pos)
		ObjectManager:Destroy(self.image)
		ObjectManager:Destroy(self.box)
	end 

	ObjectManager:Add{o}

	return o

end 



--------------------
-- Static End
--------------------


ObjectManager:AddStatic(Scroller)

return Scroller




--[==[
-- Junk
-----------------
	function o:WrapImage()
		if(o.image == nil) then
			return 
		end 

			o.image.Pos.x = o.start

	end 

	function o:WrapBox()
		if(o.box == nil) then
			return 
		end 
			o.box.Pos.x = o.start
	end 


--]==]
