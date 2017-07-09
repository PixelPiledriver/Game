-- Slider.lua
 
-- Purpose
----------------------------
-- mouse draggable variable adjuster

------------------
-- Requires
------------------
local Box = require("Box")
local Collision = require("Collision")
local MouseDrag = require("MouseDrag")
local MouseHover = require("MouseHover")
local Pos = require("Pos")
local Color = require("Color")
local Link = require("Link")
local Text = require("Text")

---------------------------------------------------------------------------

local Slider = {}


-------------------
-- Static Info
-------------------
Slider.Info = Info:New
{
	objectType = "Slider",
	dataType = "UserInterface",
	structureType = "Static"
}


function Slider:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Slider",
		dataType = "UserInterface",
		structureType = "Object"
	}

	----------------
	-- Vars
	----------------
	o.value = 0
	o.maxValue = data.maxValue or 100

	o.maxPosition = data.maxPosition or "top"

	--{object, "varName"}
	o.control = data.control or nil
	------------------
	-- Graphics
	------------------
	o.slide = Box:New
	{
		width = 4,
		height = 80,
		--x = 200,
		--y = 100,
		color = Color:Get("darkGray"),
		layer = "Hud"
	}

	o.dial = Box:New
	{
		width = 30,
		height = 15,
		--x = 192,
		--y = 130,
		color = Color:Get("white"),
		layer = "HudOver"
	}


	o.text = Text:New
	{
		text = "99"
	}

	Link:Simple
	{
		a = {o.text, "Pos", "x"},
		b = {o, "objectPos", "x"},
		offsets =
		{
			{value = {-6}},
		}
	}

	Link:Simple
	{
		a = {o.text, "Pos", "y"},
		b = {o, "objectPos", "y"},
		offsets =
		{
			{value = {-20}},
		}
	}

	------------------
	-- Components
	------------------
	-- slider dial position --> interacts with mouse
	o.Pos = Pos:New
	{
		x = 0,
		y = 10,
	}

	-- all objects together position
	o.objectPos = Pos:New
	{
		x = data.x or 200,
		y = data.y or 100
	}


	Link:Simple
	{
		a = {o, "Pos", "x"},
		b = {o, "objectPos", "x"},
		offsets =
		{
			{value = {-(o.dial.Size.width/2) + 2}}
		}
	}

	Link:Simple
	{
		a = {o.slide, "Pos", {"x", "y"}},
		b = {o, "objectPos", {"x", "y"}}
	}

	---------------
	-- Collision
	---------------
	o.collision = Collision:New
	{
		x = o.Pos.x,
		y = o.Pos.y,
		width = o.dial.Size.width,
		height = o.dial.Size.height,
		shape = "rect",
		name = o.name,
		collisionList = {"Mouse"},
	}


	Link:Simple
	{
		a = {o.collision, "Pos", {"x", "y"}},
		b = {o.dial, "Pos", {"x", "y"}}
	}


	-----------------------
	-- Mouse Interaction
	-----------------------
		-- mouse over button
	o.hover = MouseHover:New
	{
		parent = o,
	}

	-- right click to move buttons
	o.drag = MouseDrag:New
	{
		parent = o,
		mouseButton = 1,
		xActive = false
	}

	------------------
	-- Functions
	------------------
	function o:Update()
		self:KeepDialOnSlider()

		self.dial.Pos.x = self.Pos.x
		self.dial.Pos.y = self.Pos.y

		self:SlideValue()
		self:Control()
		
	end 

	function o:Control()
		if(self.control) then
			self.control[1][self.control[2]] = self.value
		end 
	end 	

	function o:SlideValue()

		-- top of slider is highest value
		if(o.maxPosition == "top") then

			local unit = self.slide.Size.height
			local slideLevel = unit + (self.objectPos.y - (self.Pos.y))

			self.value = Math:InverseLerp
			{
				a = 0,
				b = unit,
				t = slideLevel,
			}

			self.value = self.value * self.maxValue

			-- display value
			self.text.text = self.value

		-- bottom of slider is highest value
		elseif(o.maxPosition == "bottom") then

			local unit = (self.objectPos.y + self.slide.Size.height) - self.objectPos.y 
			local slideLevel = self.Pos.y - self.objectPos.y

			self.value = Math:InverseLerp
			{
				a = 0,
				b = unit,
				t = slideLevel,
			}

			self.value = self.value * self.maxValue

			-- display value
			self.text.text = self.value
		end 
	end 

	function o:KeepDialOnSlider()
		if(self.Pos.y < self.objectPos.y) then
			self.Pos.y = self.objectPos.y
		end 

		if(self.Pos.y > self.objectPos.y + self.slide.Size.height) then
			self.Pos.y = self.objectPos.y + self.slide.Size.height
		end 

	end 

	----------
	-- End
	----------

	ObjectManager:Add{o}

	return o

end 

---------------
-- Static End
---------------

ObjectManager:AddStatic(Slider)

return Slider






-- Notes
---------------------------------------



--[==[ 
--Test Code
------------------

--]==]


--[===[
-- Junk

unit = (self.objectPos.y + self.slide.Size.height) - self.objectPos.y 


--]===]