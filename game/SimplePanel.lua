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

Panel.objectsMade = {}

Panel.colorSkins =
{
	blue = 
	{
		frame = Color:Get("darkGray"),
		bar = Color:Get("lightBlue")
	},

	green = 
	{
		frame = Color:Get("lightGreen"),
		bar = Color:Get("green")
	},

	gray =
	{
		frame = Color:Get("lightGray"),
		bar = Color:Get("darkGray")
	}
}

Panel.defaulColorSkin = "gray"

Panel.defaultPanelColor = Color:New
{ r = 0, g = 0, b = 0, a = 255}

Panel.defaultTopFrame =
{
	height = 16,
	color = Color:New
	{r = 255, g = 255, b = 255, a = 128}
}

Panel.defaultNameColor = Color:Get("black")

-- safe space buffer 
Panel.windowBorderSpace = 32

Panel.objectToPanelPad = 32
Panel.objectToObjectPad = 16
Panel.objectDirections = {"left, right, up, down"}

-----------
-- Object
-----------

function Panel:New(data)

	local o = {}

	self.objectsMade[#self.objectsMade + 1] = o

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

	o.itemOffset = {x = 0, y = 0}

	-------------------
	-- Object Map
	-------------------
	o.gridScale = data.gridScale or 32 --> size of items
	o.gridWidth = data.gridWidth or o.gridScale
	o.gridHeight = data.gridHeight or o.gridScale
	o.gridPad = data.gridPad or 8

	o.itemPad = data.itemPad or 8 --> space between items

	----------------------
	-- Panel Type
		-- ObjectBased - adding objects to the panel expands the panel
		-- MapBased
	----------------------
	o.panelType = data.panelType or "ObjectBased"

	-- 2D array of item locations
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

	o.heightMax = data.heightMax or 300

	-- this is not in use yet
	-- because making it work will be awkward
	-- .Size needs to be a pointer and other Size components need to hold
	-- the size data and .Size should switch between them
	-- fix later
	o.SizeMinimized = Size:New
	{
		width = 16,
		height = 8
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

	-- color skin
	o.colorSkin = Panel.colorSkins[Panel.defaulColorSkin] or Panel.colorSkins[data.colorSkin]

	-- main panel area - holds panel items
	---------------------------------------------------
	o.frame = Box:New
	{
		color = o.colorSkin and o.colorSkin.frame or Panel.defaultPanelColor,
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
		color = o.colorSkin and o.colorSkin.bar or Panel.defaultTopFrame.color,
		parent = o,
	}

	o.bar.noScissor = true

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
		toggleText = "o",
		width = 16,
		height = 16,
		toggle = true,

		toggleOnFunc = function() 
			o:ToggleDraw()
		end,

		toggleOffFunc = function()
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
	-- Scroll Buttons
	------------------------
	
	-- add scroll bars later

	-- sets scroll back to zero
	o.scrollResetButton = Button:New
	{
		name = "scroll reset",
		text = "o",
		width = 16,
		height = 16,
		func = function() 
			o.itemOffset.y = 0
		end,
	}

	Link:Simple
	{
		a = {o.scrollResetButton, "Pos", "x"},
		b = {o.bar, "Pos", "x"},
		offsets =
		{
			{object = {o.frame.Size, "width"}},
		}
	}

	Link:Simple
	{
		a = {o.scrollResetButton, "Pos", "y"},
		b = {o.bar, "Pos", "y"},
		offsets =
		{
			{value = {48}}
		}	
	}


	-- up
	o.scrollUpButton = Button:New
	{
		name = "scroll up",
		text = "^",
		width = 16,
		height = 16,
		holdable = true,
		func = function() 
			o:ScrollY(1)
		end,
	}

	Link:Simple
	{
		a = {o.scrollUpButton, "Pos", "x"},
		b = {o.bar, "Pos", "x"},
		offsets =
		{
			{object = {o.frame.Size, "width"}},
		}
	}

	Link:Simple
	{
		a = {o.scrollUpButton, "Pos", "y"},
		b = {o.bar, "Pos", "y"},
		offsets =
		{
			{value = {16}}
		}	
	}



	-- down
	o.scrollDownButton = Button:New
	{
		name = "scroll down",
		text = "v",
		width = 16,
		height = 16,
		holdable = true,
		func = function() 
			o:ScrollY(-1)
		end,
	}

	Link:Simple
	{
		a = {o.scrollDownButton, "Pos", "x"},
		b = {o.bar, "Pos", "x"},
		offsets =
		{
			{object = {o.frame.Size, "width"}},
		}
	}

	Link:Simple
	{
		a = {o.scrollDownButton, "Pos", "y"},
		b = {o.bar, "Pos", "y"},
		offsets =
		{
			{value = {32}}
		}	
	}

	--------------
	-- DrawGroup
	--------------
	-- set draw order of objects
	-- will need to be changed as new items are added to panel
	-- but no worries, just do items last
	o.DrawGroup = DrawGroup:New
	{
		objects = {o.frame, o.bar},
		scissor = 
		{
			x = {o.frame, "Pos", "x"},
			y = {o.frame, "Pos", "y"},
			width = {o.frame, "Size", "width"},
			height = {o.frame, "Size", "height"},
		}
	}

	--o.DrawGroup:SetDepthObject(o.bar)

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

	function o:ScrollY(value)
		o.itemOffset.y = o.itemOffset.y + value
	end 

	function o:ScrollX(value)
		o.itemOffset.x = o.itemOffset.x + value
	end 


	function o:Update()

		--self.itemOffset.y = self.itemOffset.y - 0.5
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
		--local w = (self.gridScale * self.map.width) + self.gridPad	--+ ((self.map.width-2) * self.gridPad)
		--local h = (self.gridScale * self.map.height) + self.gridPad --+ ((self.map.height-2) * self.gridPad)
		local w = (self.gridWidth * self.map.width) + self.gridPad * 2
		local h = (self.gridHeight * self.map.height) + self.gridPad * 2
		
		-- height max constraint
		if(h > self.heightMax) then
			h = self.heightMax
		end 

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
				{object = {self,"gridWidth", "Mul"}},
				{object = {self, "gridPad"}},
				{object = {self.itemOffset, "x"}}
			}
		}

		Link:Simple
		{
			a = {data.object, "Pos", "y"},
			b = {o, "Pos", "y"},
			offsets = 
			{
				{value = {data.y - 1}}, --> needs to update if map position changes
				{object = {self, "gridHeight", "Mul"}},
				{object = {self, "gridPad"}},
				{object = {self.itemOffset, "y"}}
			}
		}

		-- add graphics objects of added object
		if(data.object.drawables) then
			self.DrawGroup:AddDrawablesOf(data.object)
		else 
			self.DrawGroup:Add(data.object.Draw)
		end 

		-- buttons
		if(data.object.Info.objectType == "Button") then

			-- this doesnt work
			-- needs to use a Link
			--[[
			data.object.activeRange = 
			{
				use = true,
				a = {x = self.Pos.x, y = self.Pos.y},
				b = {x = self.Pos.x + self.Size.width, y = self.Pos.y + self.Size.height}
			}
			--]]

			-- a of rect
			Link:Simple
			{
				a = {data.object.activeRange, "a", {"x", "y"}},
				b = {self, "Pos", {"x", "y"}},			
			}

			-- b of rect
			Link:Simple
			{
				a = {data.object.activeRange, "b", "x"},
				b = {self, "Pos", "x"},
				offsets =
	  		{
	  			{object = {self.Size, "width"}}
	  		}
	  	}

			Link:Simple
			{
				a = {data.object.activeRange, "b", "y"},
				b = {self, "Pos", "y"},
				offsets =
	  		{
	  			{object = {self.Size, "height"}}
	  		}
	  	}

	  	data.object.activeRange.use =  true


		end 

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

	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
		ObjectUpdater:Destroy(self.map)
		ObjectUpdater:Destroy(self.Size)
		ObjectUpdater:Destroy(self.SizeMinimized)

		ObjectUpdater:Destroy(self.Pos)
		ObjectUpdater:Destroy(self.Draw)

		ObjectUpdater:Destroy(self.frame)
		ObjectUpdater:Destroy(self.bar)
		ObjectUpdater:Destroy(self.barCollision)
		ObjectUpdater:Destroy(self.title)

		ObjectUpdater:Destroy(self.openCloseButton)
		ObjectUpdater:Destroy(self.scrollResetButton)
		ObjectUpdater:Destroy(self.scrollUpButton)
		ObjectUpdater:Destroy(self.scrollDownButton)

		ObjectUpdater:Destroy(self.DrawGroup)

		ObjectUpdater:Destroy(self.hover)
		ObjectUpdater:Destroy(self.drag)
	end 

	--------
	-- End
	--------

	ObjectUpdater:Add{o}

	return o

end 

---------------------
-- Static Functions
---------------------

function Panel:Update()

	self:SamePosGuard()

end 

function Panel:SamePosGuard()

	if(#self.objectsMade < 2) then
		return
	end

	local a = self.objectsMade[1]

		-- y position of all panels
	for i=2, #self.objectsMade do

		local b = self.objectsMade[i]

		if(a.Pos.y == b.Pos.y) then
			a.Pos.y = a.Pos.y + 0.1
		end 

	end 

end 


----------------
-- Static End
----------------

ObjectUpdater:AddStatic(Panel)

return Panel


-- Notes
---------------
-- need 
-- Minimized size - bar has a small size
-- then restores to open size when restored

-- max panel size should probly be to the screen height or slightly less?
-- def need to put in something to make that more restricted and useful 

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



