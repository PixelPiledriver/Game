-- Panel.lua

-- requires
local ObjectUpdater = require("ObjectUpdater")
local Color = require("Color")
local Box = require("Box")
local Pos = require("Pos")
local Size = require("Size")



local Panel = {}

-- Static Vars
-----------------
Panel.name = "Panel"
Panel.oType = "Static"
Panel.dataType = "HUD Constructor"

Panel.defaultPanelColor = Color:New
{
	r = 0,
	g = 0,
	b = 0,
	a = 128
}

Panel.windowBorderSpace = 32


------------------------
-- Static Functions
------------------------

function Panel:New(data)

	local o = {}

	o.name = data.name or "..."
	o.oType = "Panel"
	o.dataType = "HUD Object"

	o.active = true

	o.box = Box:New
	{
		parent = o,
		color = Panel.defaultPanelColor
	}

	-- should probly make this a component for other objects to use
	o.objects = {}

	---------------
	-- Components
	---------------
	o.Size = Size:New
	{
		width = data.width or 32,
		height = data.height or 32
	}

	o.Pos = Pos:New(data.pos or Pos.defaultPos)

	o.posType = data.posType or "none"

	if(o.posType == "bottom") then
		o.Pos:SetPos
		{
			x = Panel.windowBorderSpace,
			y = love.window.getHeight() - o.Size.height - Panel.windowBorderSpace
		}
	end






	---------------
	-- Functions
	---------------

	function o:Update()
		self:Activate()
		self:UpdatePanel()
		self:UpdateObjects()
	end

	function o:Activate()
		if(self.active) then
			self.box.draw = true
		else
			self.box.draw = false
		end 
	end

	function o:UpdatePanel()
		self.box.x = self.Pos.x
		self.box.y = self.Pos.y
	end 

	function o:UpdateObjects()

		for i=1, #self.objects do
			if(self.objects[i].Pos) then
				self.objects.Pos:SetPos
				{
					x = self.x,
					y = self.y
				}
			end 
		end 

	end 

	-- add an object to the panel
	-- object needs to have components to work properly
	function o:Add(object)
		self.Size.width = self.Size.width + object.Size.width
		self.Size.height = self.Size.Height + object.Size.height
		
	end 

	function o:ApplySize()
		
	end



	ObjectUpdater:Add{o}

	return o

end 











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