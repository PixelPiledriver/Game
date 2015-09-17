-- Text.lua

-- Purpose
--------------------------
-- a singular block of text to be shown

-------------
-- Requires
-------------
local Color = require("Color")
local Pos = require("Pos")
local Draw = require("Draw")
local Box = require("Box")
local Link = require("Link")

---------------------------------------------------

local Text =  {}

----------------
-- Static Info
----------------

Text.Info = Info:New
{
	objectType = "Text",
	dataType = "User Interface",
	structureType = "Static"
}

------------
-- Object
------------

function Text:New(data)

	local o = {}

	----------
	-- Info
	----------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Text",
		dataType = "UserInterface",
		structureType = "Object"
	}

	--------------------
	-- Vars
	--------------------

	o.text = data.text or ""
	o.color = data.color or Color:Get("white")
	o.font = love.graphics.newFont(data.size)

	-- size of area that text is within -> ex: button size
	o.displayWidth = data.displayWidth or o.font:getWidth(o.text)
	o.displayHeight = data.displayHeight or o.font:getHeight()

	o.alignment = data.alignment or "left" 
	o.verticalAlignment = data.verticalAlignment or "center"

	o.active = data.active or true

	-- timer
	o.useTimer = false

	if(data.timer) then
		o.useTimer = true
	end

	o.timer = data.timer or 0
	o.timerMax = data.timer or 100

	-- pass a bool here that text object can check
	--{object, var}
	o.timerTrigger = data.timerTrigger or nil

	

	---------------
	-- Graphics
	---------------

	o.boxPad = data.boxPad or 0

	-- optional simple box backdrop for text
	if(data.box) then
		o.box = Box:New
		{
			width = o.font:getWidth(o.text) + o.boxPad,
			height = o.font:getHeight() + o.boxPad,
			color = data.box.color
		}

		Link:Simple
		{
			a = {o.box, "Pos", {"x", "y"}},
			b = {o, "Pos", {"x", "y"}}
		}

	end

	---------------
	-- Components
	---------------

	o.Pos = Pos:New
	{
		x = data.x or Pos.defaultPos.x,
		y = data.y or Pos.defaultPos.y
	}

	local defaultDraw =
	{
		parent = o,
		layer = "Hud",
		GetDepth = o.GetDepth,
		first = data.first or false,
		last = data.last or false,
	}

	o.Draw = Draw:New(data.Draw or defaultDraw)

	---------------
	-- Functions
	---------------

	function o:Update()
		self:UpdateTimer()
	end 


	function o:UpdateTimer()
		if(self.useTimer == false) then
			return
		end

		if(self.timerTrigger) then
			--print(self.timerTrigger[1][self.timerTrigger[2]])
			if(self.timerTrigger[1][self.timerTrigger[2]]) then
				self.timer = self.timerMax
				self:SetActive(true)
			end
		end 

		if(self.timer > 0) then
			self.timer = self.timer - 1
		end 

		if(self.timer == 0 and self.active) then
			self:SetActive(false)
		end 
	end 


	function o:ToggleActive()

		if(self.active) then
			self:SetActive(false)
		else 
			self:SetActive(true)
		end 

	end 

	function o:SetActive(state)
		if(state == false) then 
			
			self.active = false

			if(self.box) then
				self.box.Draw.active = false
			end

		else

			self.active = true

			if(self.box) then
				self.box.Draw.active = true
			end			

		end 

	end 

	function o:DrawCall()

		if(self.active == false) then
			return
		end 

		love.graphics.setColor(Color:AsTable(self.color))
		love.graphics.setFont(self.font)

		local x = 0
		local y = 0

		-- horizontal alignment
		if(self.alignment == "left") then
			x = self.Pos.x
		elseif(self.alignment == "right") then
			x = self.Pos.x + self.displayWidth - self.font:getWidth(self.text)
		elseif(self.alignment == "center") then
			x = self.Pos.x + (self.displayWidth/2) -((self.font:getWidth(self.text))/2)
		end 

		-- vertical alignment
		if(self.verticalAlignment == "left") then
			y = self.Pos.y
		elseif(self.verticalAlignment == "right") then
			y = self.Pos.y
		elseif(self.verticalAlignment == "center") then
			y = self.Pos.y + (self.displayHeight/2) - (self.font:getHeight()/2)
		elseif(self.verticalAlignment == "none") then
			y = self.Pos.y
		end 

		LovePrint
		{
			text = self.text,
			x = x,
			y = y,
			color = Color:AsTable(self.color)
		}
	end 


	function o:GetWidth()
		return self.font:getWidth(o.text)
	end 

	function o:GetHeight()
		return self.font:getHeight()
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

ObjectUpdater:AddStatic(Text)


-------------
-- Global -- this needs to be moved to somewhere else
-------------
-- optional text altering
-- data = {text, x, y, rot, xScale, yScale, 
--	xOffset, yOffset, xShear, yShear}
function LovePrint(data)
	local text = data.text or "NoText"
	local x = data.x or 0
	local y = data.y or 0
	local rot = data.rot or 0
	local xScale = data.xScale or 1
	local yScale = data.yScale or 1
	local xOffset = data.xOffset or 0
	local yOffset = data.yOffset or 0
	local xShear = data.xShear or 0
	local yShear = data.yShear or 0

	love.graphics.setColor(data.color or Color:AsTable(Color:Get("white")))

	love.graphics.print(text, x, y, rot, xScale, yScale, xOffset, yOffset, xShear, yShear)

end 

return Text
