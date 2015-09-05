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

	----------
	-- Vars
	----------
	o.text = data.text or ""
	o.color = data.color or Color:Get("white")
	o.font = love.graphics.newFont(data.size)

	o.displayWidth = data.displayWidth or o.font:getWidth(o.text)

	-- oophorizontal only
	-- need to add vertical
	o.alignment = data.alignment or "left" 

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

	function o:DrawCall()
		love.graphics.setColor(Color:AsTable(self.color))
		love.graphics.setFont(self.font)

		local x = 0
		local y = 0

		-- alignment --> move this to a function?
		if(self.alignment == "left") then
			x = self.Pos.x
			y = self.Pos.y
		elseif(self.alignment == "right") then
			x = self.Pos.x + self.displayWidth - self.font:getWidth(self.text)
			y = self.Pos.y
		elseif(self.alignment == "center") then
			x = self.Pos.x + (self.displayWidth/2) -((self.font:getWidth(self.text))/2)
			y = self.Pos.y
		end 


		LovePrint
		{
			text = self.text,
			x = x,
			y = y
		}
	end 


	--------
	-- End
	--------


	return o

end 

----------------
-- Static End
----------------

ObjectUpdater:AddStatic(Text)


----------
-- Global
----------
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
	love.graphics.print(text, x, y, rot, xScale, yScale, xOffset, yOffset, xShear, yShear)
end 

return Text
