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
	o.gridPads = {}
	o.gridPads.width =  data.gridPadWidth or 16
	o.gridPads.height =  data.gridPadHeight or 16


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
		link = o.topFrame.Pos
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

		if(self.panelType == "ObjectBased") then
			self:Activate()
			self:UpdatePanel()
			self:UpdateObjects()
		end

		if(self.panelType == "GridBased") then
		end 

	end

	function o:UpdatePanel()
	end 

	function o:UpdateObjects()
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

	function o:Activate()
		--[[
		if(self.active) then
			self.box.draw = true
		else
			self.box.draw = false
		end 
		--]]

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

	------------------
	-- Get Funcitons
	------------------
	-- returns the greatest object height
	function o:GetMaxObjectHeight()
		local max = 0

			for i=1, #self.objects do
				if(self.objects[i].Size.height > max) then
					max = self.objects[i].Size.height
				end 
			end 

		return max
	end 

	function o:GetMaxObjectWidth()
		local max = 0

			for i=1, #self.objects do
				if(self.objects[i].Size.width > max) then
					max = self.objects[i].Size.width
				end 
			end 

		return max
	end 

	function o:GetObjectsHeight()
		local height = 0
			for i=1, #self.objects do
				height = height + self.objects[i].Size.height
			end
		return height
	end 

	function o:GetPadHeight()
		return (#self.objects * Panel.objectToObjectPad) + (Panel.objectToPanelPad * 2)
	end 

	-- get the total width of all objects in the panel
	function o:GetObjectsWidth()
		local width = 0

		for i=1, #self.objects do
			width = width + self.objects[i].Size.width
		end 

		return width
	end 
	
	-- get the total width of all padding in the panel
	function o:GetPadWidth()	
		return (#self.objects * Panel.objectToObjectPad) + (Panel.objectToPanelPad * 2)
	end

	function o:GetObjectPadWidth()
		return (Panel.objectToObjectPad * (#self.objects - 1))
	end 


	-----------------------
	-- Add Functions
	-----------------------
	-- add an object to the panel
	-- (object) <-- needs to have components

	function o:Add(object)

		--if(self.panelType == "ObjectBased") then
			self:AddObjectBased(object)
		--elseif(self.panelType == "GridBased") then
			--self.AddGridBased(object)
		--end
		
	end 

	function o:AddToGrid(data)	

		print("panel adding to grid")
		print(data.object)

		self.map:Add
		{
			object = data.object,
			x = data.x,
			y = data.y,
		}
	
		self.width = self.map.width * self.gridScale
		self.height = self.map.height * self.gridScale

		
--[[
		self.map[data.x][data.y].Pos:SetFollow
		{
			object = self.Pos,
			x = data.x * self.gridScale,
			y = data.y * self.gridScale
		}
		--]]


	end 

	function o:AddObjectBased(object)

		local totalObjectsWidth = self:GetObjectsWidth()
		local totalPadWidth = self:GetPadWidth()

		-- add object to table of objects
		self.objects[#self.objects + 1] = object

		-- resize panel to accomodate new object

		-- width
		--------------
		local changeWidth = false

		if(totalObjectsWidth + totalPadWidth + object.Size.width > self.Size.width) then
			changeWidth = true
		end

		if(changeWidth) then
			self.Size.width = totalObjectsWidth + totalPadWidth + object.Size.width
		end 

		local objectToObjectPad = 0

		if(#self.objects > 1) then
			objectToObjectPad = self:GetObjectPadWidth()
		end

		-- height
		---------------
		local changeHeight = false

		if(object.Size.height + Panel.objectToPanelPad * 2 > self.Size.height) then
			changeHeight = true
		end 

		if(changeHeight) then
			self.Size.height = object.Size.height + (Panel.objectToPanelPad * 2)
		end 

		local x = self.Pos.x + Panel.objectToPanelPad + totalObjectsWidth + objectToObjectPad
		local y = self.Pos.y + Panel.objectToPanelPad

		local offsetX = x - self.Pos.x
		local offsetY = y - self.Pos.y

		object.Pos:LinkPosTo
		{
			link = self.Pos,
			x = offsetX,
			y = offsetY
		}

		
		self:Refresh()
	end 

	-- might want to change these refresh functions
	-- to be categorized by object group rather than what it does
	function o:Refresh()
		self:ApplySize()
		self:ApplyWindowPadding()
		self:ApplyFramePosition()
	end 

	function o:ApplySize()
		self.topFrame.Size.width = self.Size.width
		
		self.topCollision.width = self.topFrame.Size.width
		self.topCollision.height = self.topFrame.Size.height
	end

	function o:ApplyWindowPadding()
		if(self.posType == "bottom") then
			self.Pos.y = love.window.getHeight() - self.Size.height - Panel.windowBorderSpace
		end 
	end 

	function o:ApplyObjectPosition()
		for i=1, #self.objects do
			self.objects[i].Pos.x = self.Pos.x + self.objects[i].panelPos.x
			self.objects[i].Pos.y = self.Pos.y + self.objects[i].panelPos.y
		end 
	end

	function o:ApplyFramePosition()
		self.topFrame.Pos.x = self.Pos.x
		self.topFrame.Pos.y = self.Pos.y - self.topFrame.Size.height

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


-- notes
----------------------

-- needs to be an object that holds buttons
-- can slide in and out
-- be summoned when needed
-- closed when not
-- etc

-- object that holds other objects
-- can be moved around
-- mostly for buttons but can be used for other stuff as well

-- not gonna work on this right now :P
-- but gonna need it eventually

-- Panels should be able to be built from a grid
-- # of objects and scale should determine how it fits objects
-- rather than object sizes <---- optional
-- good idea for a simpler panel setup




-- multiple direction stuff
-- some complicated code I will just fix later
-- left
--object.Pos.x = self.Pos.x - Panel.objectToPanelPad - totalObjectsWidth - objectToObjectPad
--object.Pos.y = self.Pos.y + Panel.objectToPanelPad

-- vertical
--[[
local changeHeight = false

if(object.Size.height + Panel.objectToPanelPad * 2 > self.Size.height) then
	changeHeight = true
end 

if(changeHeight) then
	self.Size.height = object.Size.height + (Panel.objectToPanelPad * 2)
end 
--]]







-- add these in as funcitons later
-- and call from an Add function based on panel direction type
--[[

	function o:AddHorizontal()

	end 

	function o:AddVertical()

	end

--]]



--[[

		-- old panel position for new objects code
		--[[
		-- set position of new object into panel
		--object.Pos.x = self.Pos.x + Panel.objectToPanelPad + totalObjectsWidth + objectToObjectPad
		--object.Pos.y = self.Pos.y + Panel.objectToPanelPad

		object.panelPos =
		{
			x = object.Pos.x - self.Pos.x,
			y = object.Pos.y - self.Pos.y,
		}
		--]]

--]]