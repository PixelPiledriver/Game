-- SimplePanel.lua

-- Panel.lua

-- requires
local ObjectUpdater = require("ObjectUpdater")
local Color = require("Color")
local Box = require("Box")
local Pos = require("Pos")
local Size = require("Size")
local Collision = require("Collision")
local MouseHover = require("MouseHover")
local MouseDrag = require("MouseDrag")
local MapTable = require("MapTable")


local Panel = {}

-- Static Vars
-----------------
Panel.name = "Panel"
Panel.oType = "Static"
Panel.dataType = "HUD Constructor"

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

------------------------
-- Static Functions
------------------------

function Panel:New(data)

	local o = {}

	o.name = data.name or "..."
	o.oType = "Panel"
	o.dataType = "HUD Object"


	---------------------
	-- Vars
	---------------------
	o.active = true
	o.draw = true


	-------------------------------------
	-- Objects in Panel
	-------------------------------------
	o.objects = {}
	o.objectDirection = data.objectDirection or "right"

	-------------------
	-- Object Map
	-------------------
	o.gridScale = data.gridScale or 32
	o.gridPad = data.gridPad or 8

	----------------------
	-- Panel Type
	--[[
		ObjectBased - adding objects to the panel expands the panel
		MapBased
	--]]								
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

	-------------------------------
	-- Graphics
	-------------------------------
	-- main panel area
	o.box = Box:New
	{
		color = Panel.defaultPanelColor,
		parent = o,
	}

	o.box.Pos:LinkPosTo
	{
		link = o.Pos
	}

	o.box.Size:LinkSizeTo
	{
		link = o.Size
	}

	--o.box.Pos = o.Pos
	--o.box.Size = o.Size

	-- above panel
	o.topFrame = Box:New
	{
		x = o.Pos.x,
		y = o.Pos.y - Panel.defaultTopFrame.height,
		height = Panel.defaultTopFrame.height,
		width = o.Size.width,
		color = Panel.defaultTopFrame.color,
		parent = o,
	}

	o.topFrame.Size:LinkWidthTo{link = o.Size}

	o.topFrame.Pos:LinkPosTo
	{
		link = o.Pos,
		x = o.topFrame.Pos.x - o.Pos.x,
		y = o.topFrame.Pos.y - o.Pos.y
	}

	--------------------
	-- Collision
	--------------------
	o.topCollision = Collision:New
	{
		x = o.Pos.x,
		y = o.Pos.y - o.topFrame.Size.height,
		width = o.topFrame.Size.width,
		height = o.topFrame.Size.height,
		name = o.name,
		shape = "rect",
		collisionList = {"Mouse"},
	}

	o.topCollision.Pos:LinkPosTo
	{
		link = o.topFrame.Pos,
	}

	o.topCollision.Size:LinkWidthTo
	{
		link = o.topFrame.Size
	}

	------------------------
	-- Mouse Interaction
	------------------------
	o.hover = MouseHover:New
	{
		parent = o,
		collision = o.topCollision
	}

	o.drag = MouseDrag:New
	{
		parent = o
	}

	-------------------------
	-- Object Functions
	-------------------------

	function o:Update()

	end 

	function o:Draw()
		love.graphics.setColor(Color:AsTable(Panel.defaultPanelColor))
		LovePrint
		{
			text = self.name,
			x = self.Pos.x + 6,
			y = self.Pos.y - 14
		}
	end

	function o:ToggleDraw()
		self.draw = Bool:Toggle(self.draw)

		for i=1, #self.objects do
			if(self.objects[i].ToggleDraw) then
				self.objects[i]:ToggleDraw()
			else
				self.objects[i].draw = self.draw
			end 

		end 		
	end 



	-----------------------
	-- Add Functions
	-----------------------

	-- add an object to this panel
	-- {object, x, y}
	function o:Add(data)	

		self.map:Add
		{
			object = data.object,
			x = data.x,
			y = data.y,
		}
	
		local w = (self.gridScale * self.map.width)	--+ ((self.map.width-2) * self.gridPad)
		local h = (self.gridScale * self.map.height) --+ ((self.map.height-2) * self.gridPad)
		self.Size:Set(w,h)

		self.map.map[data.x][data.y].Pos:LinkPosTo
		{
			link = self.Pos,
			x = (data.x - 1) * self.gridScale + self.gridPad,
			y = (data.y - 1) * self.gridScale + self.gridPad
		}
	end 


		



	function o:PrintDebugText()	

		DebugText:TextTable
		{
			{text = "", obj = "DrawTools"},
			{text = "Panel"},
			{text = "-------------------------"},
			{text = #self.objects}
		}
	end 



	ObjectUpdater:Add{o}

	return o

end 




ObjectUpdater:AddStatic(Panel)


return Panel


--[[ Notes

- objects can be drag and dropped
	move out of panel
	move into panel
	change position in panel



--]]