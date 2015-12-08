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
local Fade = require("Fade")
local Life = require("Life")

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

-----------------
-- Static Vars
-----------------
Text.default =
{
	fade = false,
	life = false,	
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
	o.tempText = nil
	
	o.color = data.color or Color:Get("white")
	o.font = love.graphics.newFont(data.size)

	-- size of area that text is within -> ex: button size
	o.displayWidth = data.displayWidth or o.font:getWidth(o.text)
	o.displayHeight = data.displayHeight or o.font:getHeight()

	o.multiLine = false
	o.multiLineText = nil
	o.multiLineYSpace = data.multiLineYSpace or o.displayHeight

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

		Link.newParent = o
		Link:Simple
		{
			a = {o.box, "Pos", {"x", "y"}},
			b = {o, "Pos", {"x", "y"}}
		}

	end

	if(data.life or Text.default.life) then 
		o.Life = Life:New
		{
			life = 100,
			drain = true,
			parent = o
		}
	end 

	if(data.fade or Text.default.fade) then
		o.Fade = Fade:New
		{
			parent = o,
			fadeWithLife = true
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
		drawList = data.drawList,
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

		-- might not used this but I dunno
		-- will disable for now until I have a better feature to replace it
		--[[
		if(Window:IsPosOnScreen(self.Pos) == false) then
			return
		end 
		--]]

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

		-- single line text
		if(self.multiLine == false) then
			LovePrint
			{
				text = self.text,
				x = x,
				y = y,
				color = Color:AsTable(self.color)
			}

		-- multi line text
		else

			for i=1, #self.multiLineText do
				LovePrint
				{
					text = self.multiLineText[i],
					x = x,
					y = y + (self.multiLineYSpace * (i - 1)),
					color = Color:AsTable(self.color)
				}
			end 

		end 

	end 


	function o:GetWidth()
		return self.font:getWidth(o.text)
	end 

	function o:GetWidthTempText()
		return self.font:getWidth(o.tempText)
	end 

	function o:GetHeight()
		return self.font:getHeight()
	end 

	-- split string into several lines of passed in length
	function o:BreakIntoLines(maxLength)

		-- create table for lines of text
		self.multiLineText = {}

		-- used to collect lines of text
		local tempText = ""

		-- indicated where to read from
		local readIndex = 1

		for i=1, string.len(self.text) do
			
			tempText = tempText .. string.sub(self.text,i,i)

			if(self.font:getWidth(tempText) > maxLength) then

				-- move back to a space character
				repeat
					i = i - 1
				until	 string.sub(self.text, i, i) == " "


				-- break off and add the line of text
				self.multiLineText[#self.multiLineText+1] = string.sub(self.text, readIndex, i)

				-- start reading from the next character
				readIndex = (i+1)

				-- clear temp text for the next loop
				tempText = nil
				tempText = ""

			end

		end


		-- add the last line,
		-- this happens after the loop, since it won't reach the max
		self.multiLineText[#self.multiLineText+1] = string.sub(self.text, readIndex, string.len(self.text))



		--string.sub(text.text,)

		self.multiLine = true
	end 


	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
		ObjectUpdater:Destroy(self.box)
		ObjectUpdater:Destroy(self.Pos)
		ObjectUpdater:Destroy(self.Draw)

		if(self.Links) then
			self.Links:DestroyAll()
			ObjectUpdater:Destroy(self.Links)
		end 

		ObjectUpdater:Destroy(self.Life)
		ObjectUpdater:Destroy(self.Fade)
		
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



-- Notes
------------------------
-->FIX
-- BreakIntoLines fails on long overstretched words
-- like BOOOOOOOOOOOOOOOOOO!!!!!
-- this could be solved with scissor, but other solution?

-->FIX
-- BreakIntoLines can sometimes fail on letters with wide width?

-->DONE
-- need to not break works apart in BreakIntoLines
-- right now it disregards them




-- Junk
-----------------------------------------------
--[[
-- changing BreakIntoLines a bit
-- here is the old version

	-- split string into several lines of passed in length
	function o:BreakIntoLines(maxLength)

		self.tempText = ""

		local readIndex = 1

		print(string.len(self.text))
		for i=1, string.len(self.text) do
			
			self.tempText = self.tempText .. string.sub(self.text,i,i)

			if(self:GetWidthTempText() > maxLength) then

				if(self.multiL)

				self.multiLineText[#self.multiLineText+1] = string.sub(self.text, readIndex, i)
				readIndex = (i+1)
				self.tempText = nil
				self.tempText = ""
			end

		end


		self.multiLineText[#self.multiLineText+1] = string.sub(self.text, readIndex, string.len(self.text))



		--string.sub(text.text,)

		self.multiLine = true
	end 


--]]
