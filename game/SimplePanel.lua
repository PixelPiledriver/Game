-- SimplePanel.lua

-- an alternate version of Panel.lua

-------------
-- Requires
-------------

local Color = require("Color")
local Box = require("Box")
local Pos = require("Pos")
local Size = require("Size")
local Collision = require("Collision")
local MouseHover = require("MouseHover")
local MouseDrag = require("MouseDrag")
local MapTable = require("MapTable")
local Button = require("Button")
local Link = require("Link")
local Draw = require("Draw")
local Text = require("Text")

---------------------------------------------------------------

local Panel = {}

----------------
-- Static Info
----------------

Panel.Info = Info:New
{
	objectType = "SimplePanel",
	dataType = "User Interface",
	structureType = "Static"
}

-----------------
-- Static Vars
-----------------

Panel.defaultPanelColor = Color:New
{ r = 0, g = 0, b = 0, a = 128}

Panel.defaultTopFrame =
{
	height = 16,
	color = Color:New
	{r = 255, g = 255, b = 255, a = 128}
}

Panel.defaultNameColor = Color:Get("black")

Panel.windowBorderSpace = 16
Panel.objectToPanelPad = 8
Panel.objectToObjectPad = 16
Panel.objectDirections = {"left, right, up, down"}

-----------
-- Object
-----------

function Panel:New(data)

	local o = {}

	----------
	-- Info
	----------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "SimplePanel",
		dataType = "User Interface",
		structureType = "Object"
	}

	-----------
	-- Vars
	-----------
	o.active = true
	o.draw = true

	-------------------------
	-- Objects in Panel
	-------------------------
	o.items = {}
	o.objectDirection = data.objectDirection or "right"

	-------------------
	-- Object Map
	-------------------
	o.gridScale = data.gridScale or 32 --> size of items
	o.gridPad = data.gridPad or 0

	o.itemPad = data.itemPad or 8 --> space between items

	----------------------
	-- Panel Type
		-- ObjectBased - adding objects to the panel expands the panel
		-- MapBased
	----------------------
	o.panelType = data.panelType or "ObjectBased"
	o.map = MapTable:New
	{
		width = 2,
		height = 2,
	}

	---------------
	-- Components
	---------------
	o.Size = Size:New
	{
		width = data.width or 32,
		height = data.height or 32
	}

	o.Pos = Pos:New(Pos.defaultPos)

	o.posType = data.posType or "none"

	if(o.posType == "bottom") then
		o.Pos:SetPos
		{
			x = Panel.windowBorderSpace,
			y = love.window.getHeight() - o.Size.height - Panel.windowBorderSpace
		}
	end

	o.Draw = Draw:New
	{
		parent = o,
		layer = "Hud"
	}

	-------------------------------
	-- Graphics
	-------------------------------
	-- main panel area
	o.frame = Box:New
	{
		color = Panel.defaultPanelColor,
		parent = o,
	}

	Link:Simple
	{
		a = {o.frame, "Pos", "x"},
		b = {o, "Pos", "x"},
	}

	Link:Simple
	{
		a = {o.frame, "Pos", "y"},
		b = {o, "Pos", "y"},
	}

	-->REPLACE with Link:Simple
	o.frame.Size:LinkSizeTo
	{
		link = o.Size
	}

	-- above panel
	o.bar = Box:New
	{
		x = o.Pos.x,
		y = o.Pos.y - Panel.defaultTopFrame.height,
		height = Panel.defaultTopFrame.height,
		width = o.Size.width,
		color = Panel.defaultTopFrame.color,
		parent = o,
	}

	-->REPLACE with Link:Simple
	o.bar.Size:LinkWidthTo{link = o.Size}

	Link:Simple
	{
		a = {o.bar, "Pos", "x"},
		b = {o, "Pos", "x"}
	}

	Link:Simple
	{
		a = {o.bar, "Pos", "y"},
		b = {o, "Pos", "y"},
		offsets =
		{
			{object = {o.bar.Size, "height", "Sub"}}
		}
	}

	-- add Text here to diplay name of panel
	-- old way was DrawCall LovePrint
	o.barTitle = Text:New
	{
		text = o.Info.name,
		color = Color:Get("black")
	}

	Link:Simple
	{
		a = {o.barTitle, "Pos", "x"},
		b = {o.bar, "Pos", "x"}
	}

	Link:Simple
	{
		a = {o.barTitle, "Pos", "y"},
		b = {o.bar, "Pos", "y"}
	}


	-----------------
	-- Collision
	-----------------

	o.barCollision = Collision:New
	{
		x = o.Pos.x,
		y = o.Pos.y - o.bar.Size.height,
		width = o.bar.Size.width,
		height = o.bar.Size.height,
		name = o.name,
		shape = "rect",
		collisionList = {"Mouse"},
	}

	Link:Simple
	{
		a = {o.barCollision, "Pos", "x"},
		b = {o.bar, "Pos", "x"},
	}

	Link:Simple
	{
		a = {o.barCollision, "Pos", "y"},
		b = {o.bar, "Pos", "y"},
	}

	o.barCollision.Size:LinkWidthTo
	{
		link = o.bar.Size
	}

	--------------
	-- Buttons
	--------------

	o.openCloseButton = Button:New
	{
		name = "panel close",
		text = "x",
		width = 16,
		height = 16,
		func = function()
			o:ToggleDraw()
		end,

		printDebugTextActive = true
		
	}

	Link:Simple
	{
		a = {o.openCloseButton, "Pos", "x"},
		b = {o.bar, "Pos", "x"},
		offsets =
		{
			{object = {o.frame.Size, "width"}}
		}
	}

	yLink = Link:Simple
	{
		a = {o.openCloseButton, "Pos", "y"},
		b = {o.bar, "Pos", "y"}
	}

	------------------------
	-- Mouse Interaction
	------------------------
	o.hover = MouseHover:New
	{
		parent = o,
		collision = o.barCollision
	}

	o.drag = MouseDrag:New
	{
		parent = o
	}


	----------------
	-- Functions
	----------------

	function o:Update()
	end 

	function o:DrawCall()

		--[[
		love.graphics.setColor(Color:AsTable(Color:Get("black")))
		LovePrint
		{
			text = self.Info.name,
			x = self.bar.Pos.x,
			y = self.bar.Pos.y,
		}
		--]]
	end

	function o:ToggleDraw()

		for i=1, #self.items do
			self.items[i].Draw:ToggleDraw()
		end

		self.frame.Draw:ToggleDraw()
		--self.bar.Draw:ToggleDraw()

	end 


	-----------------------
	-- Add Functions
	-----------------------

	-- add an object to this panel
	-- {object, x, y}
	function o:Add(data)

		self.items[#self.items + 1] = data.object

		self.map:Add
		{
			object = data.object,
			x = data.x,
			y = data.y,
		}
	
		-- not sure why the shit on the right is commented out
		local w = (self.gridScale * self.map.width)	--+ ((self.map.width-2) * self.gridPad)
		local h = (self.gridScale * self.map.height) --+ ((self.map.height-2) * self.gridPad)
		self.Size:Set(w,h)

		-- objects added to the panel
		-- follow the panel based on their map position
		local xLink = Link:Simple
		{
			a = {data.object, "Pos", "x"},
			b = {o, "Pos", "x"},
			offsets = 
			{
				{value = {data.x - 1}}, --> needs to update if map position changes
				{object = {self,"gridScale", "Mul"}},
				{object = {self, "gridPad"}}
			}
		}

		local yLink = Link:Simple
		{
			a = {data.object, "Pos", "y"},
			b = {o, "Pos", "y"},
			offsets = 
			{
				{value = {data.y - 1}}, --> needs to update if map position changes
				{object = {self, "gridScale", "Mul"}},
				{object = {self, "gridPad"}}
			}
		}

	end 


		
	function o:PrintDebugText()	

		DebugText:TextTable
		{
			{text = "", obj = "DrawTools"},
			{text = "Panel"},
			{text = "-------------------------"},
			{text = #self.items}
		}

	end 

--------
-- End
--------

	ObjectUpdater:Add{o}

	return o

end 


----------------
-- Static End
----------------

ObjectUpdater:AddStatic(Panel)

return Panel


-- Notes
---------------

-- DrawGroup needs to be figured out
-- so panels can draw behind their items

-- TO DO --> much later
-- drag and drop objects
--	move out of panel
--	move into panel
--	change position in panel

-- DONE
-- a open and close button in the top right of the panel








-- Junk
-------------------------------------
	--[[
	o.bar.Pos:LinkPosTo
	{
		link = o.Pos,
		x = o.bar.Pos.x - o.Pos.x,
		y = o.bar.Pos.y - o.Pos.y
	}
	--]]