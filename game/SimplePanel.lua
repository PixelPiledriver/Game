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
local DrawGroup = require("DrawGroup")

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

-- safe space buffer 
Panel.windowBorderSpace = 32

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
		width = 1,
		height = 1,
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

	-- this is super weird and I don't think matters at all?
	-- need a better solution/feature than this
	if(o.posType == "bottom") then
		o.Pos:SetPos
		{
			x = love.window.getWidth() - 100,
			y = Panel.windowBorderSpace
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

	-- main panel area - holds panel items
	---------------------------------------------------
	o.frame = Box:New
	{
		color = Panel.defaultPanelColor,
		parent = o,
	}

	Link:Simple
	{
		a = {o.frame, "Pos", {"x", "y"}},
		b = {o, "Pos", {"x", "y"}},
	}

	Link:Simple
	{
		a = {o.frame, "Size", {"width", "height"}},
		b = {o, "Size", {"width", "height"}}
	}

	-- above panel bar - move panel and holds title
	------------------------------------------------
	o.bar = Box:New
	{
		x = o.Pos.x,
		y = o.Pos.y - Panel.defaultTopFrame.height,
		height = Panel.defaultTopFrame.height,
		width = o.Size.width,
		color = Panel.defaultTopFrame.color,
		parent = o,
	}

	Link:Simple
	{
		a = {o.bar, "Size", "width"},
		b = {o, "Size", "width"}
	}

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
		a = {o.barCollision, "Pos", {"x", "y"}},
		b = {o.bar, "Pos", {"x", "y"}},
	}

	Link:Simple
	{
		a = {o.barCollision, "Size", "width"},
		b = {o.bar, "Size", "width"}
	}


	---------------
	-- Title
	---------------

	o.title = Text:New
	{
		text = o.Info.name,
		color = Color:Get("black"),
	}

	Link:Simple
	{
		a = {o.title, "Pos", "x"},
		b = {o.bar, "Pos", "x"}
	}

	Link:Simple
	{
		a = {o.title, "Pos", "y"},
		b = {o.bar, "Pos", "y"},
		offsets =
		{
			{value = {o.bar.Size.height, "Sub"}}
		}
	}

	-- hide title if too long to fit in window bar
	if(o.title:GetWidth() > o.bar.Size.width) then
		o.title:SetActive(false)
		o.title.useTimer = true
		o.title.timerMax = 30
		o.title.timerTrigger = {o.barCollision, "collidedLastFrame"}
	end

	-- add this feature in a min
	if(data.toolTipTitle) then

	end 

	--o.showTitle = data.showTitle or true
	--o.title.active = o.showTitle


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
		end
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

	Link:Simple
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

	-- empty for now
	function o:Update()
	end 

	-- empty for now
	function o:DrawCall()

	end

	function o:ToggleDraw()

		for i=1, #self.items do

			if(self.items[i].Draw) then
				self.items[i].Draw:ToggleDraw()
			end 

			if(self.items[i].ToggleDraw) then
				self.items[i]:ToggleDraw()
			end 

		end

		self.frame.Draw:ToggleDraw()
		--self.bar.Draw:ToggleDraw()

	end 


	--------------------------------------------
	-- Add Functions - put objects in panel
	--------------------------------------------

	-- add an object to this panel at a specific position
	-- {object, x, y}
	function o:Add(data)

		self.items[#self.items + 1] = data.object

		self.map:Add
		{
			object = data.object,
			x = data.x,
			y = data.y,
		}
	
		-- increase size of panel to make room for new object
		-- not sure why the shit on the right is commented out --> move to junk soon :P
		local w = (self.gridScale * self.map.width)	--+ ((self.map.width-2) * self.gridPad)
		local h = (self.gridScale * self.map.height) --+ ((self.map.height-2) * self.gridPad)
		self.Size:Set(w,h)

		-- link object added
		-- follow the panel based on their map position
		Link:Simple
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

		Link:Simple
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

	-- add multiple objects to panel from left to right
	-- {a, b, c, ...}
	function o:AddHorizontal(data)

		for i=1, #data do
			local table = 
			{
				object = data[i],
				x = i,
				y = data.yStart or 1 -- there is no way to input yStart since data is indexed
			}

			o:Add(table)
		end

	end 

	-- add multiple objects to panel from top to bottom
	-- {a, b, c, ...}
	function o:AddVertical(data)

		for i=1, #data do
			local table = 
			{
				object = data[i],
				x = data.xStart or 1, -- there is no way to input xStart since data is indexed
				y = i
			}

			o:Add(table)
		end

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

--> TO DO
-- fit width to panel name
-- or have title overhang the panel


-- TO DO --> much later
-- drag and drop objects
-- move out of panel
-- move into panel
-- change position in panel

-- DONE
-- a open and close button in the top right of the panel








-- Junk
-------------------------------------
	--[[

	-- old links
	o.bar.Pos:LinkPosTo
	{
		link = o.Pos,
		x = o.bar.Pos.x - o.Pos.x,
		y = o.bar.Pos.y - o.Pos.y
	}

	o.bar.Size:LinkWidthTo{link = o.Size}

	o.frame.Size:LinkSizeTo
	{
		link = o.Size
	}



	-- old title text
	love.graphics.setColor(Color:AsTable(Color:Get("black")))
	LovePrint
	{
		text = self.Info.name,
		x = self.bar.Pos.x,
		y = self.bar.Pos.y,
	}
	--]]


