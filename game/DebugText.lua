-- DebugText.lua
-----------------------------------------------
-- draw text info to screen
-- add --> funciton o:PrintDebugText()
-- to your object type to print to this
-- DebugText is a Global --> use anywhere

-- need to make a console too

local Color = require("Color")
local ObjectUpdater = require("ObjectUpdater")

DebugText = {}

----------------------
-- Create
----------------------

-- object
DebugText.name = "DebugText"
DebugText.oType = "Static"
DebugText.dataType = "Manager"

-- On or Off
DebugText.active = true

-- all text messages that need to be drawn on the next frame
DebugText.texts = {}

----------------------
-- Print Type Flags
----------------------
-- flip these on and off 
-- to run o:PrintDebugText() for named object type
-- changed 'type' to 'messageType'
-------------------------------------------------------
DebugText.messageType = 
{
	-- Managers
	ObjectUpdater = false,
	CollisionManager = false,


	-- Statics
	ButtonStatic = false,
	ShaderStatic = false,
	MouseStatic = false,

	-- Objects
	Box = false,
	Camera = false,
	Player = false,
	Bullet = false,
	Block = false,
	Controller = false,
	Window = false,
	Map = false,
	ParticleSystem = false,
	Particle = false,
	Mouse = false,
	Life = false,
	SnapPlayer = false,
	
	Collision = false,
	Button = false,
	DrawTools = false,
	Palette = false,

	--Components
	Pos = false,
	HoverWithMouse = true,



	-- Counters
	SinCounter = false,

	-- Graphics
	Line = false,
	Shape = false,
	Point = false,

	-- Other
	Generic = false
}




-- position shit
DebugText.xStart = 8
DebugText.yStart = 64
DebugText.xSpace = 16
DebugText.ySpace = 16


----------------
-- Functions
----------------

function DebugText:Update()
	-- nuthin to do here for now I guess :P
	-- but would now update as a static
end 

-- add a single line
function DebugText:Text(txt)
	self.texts[#self.texts + 1] = { {text = txt, color = Color.white} }
end 


-- add a new text to be drawn
-- old format --> less easy to use
-- { {text,color,obj}, {text,color}, ... } 
function DebugText:TextTable(data)

	local textType = data[1].obj or "Generic"

	if(self.messageType[textType] == false) then
		return
	end 

	self.texts[#self.texts + 1] = data

end


-- add a new text to be drawn
-- this is the shorthand format --> much faster to type
-- data is converted into a table slot to be used by DebugText
-- { type = className, text = {string, color}
function DebugText:TextTableSimple(data)

	local textType = data.type or "Generic"

	if(self.messageType[textType] == false) then
		return
	end 

	local convertedTable = {{text = "", data.objectType}}

	for i=i, #data.text do
		convertedTable[#convertedTable+1] = {text = data.text[i][1], color = data.text[i][2] or nil }
	end

	self.texts[#self.texts + 1] = convertedTable

end


-- optional text altering
-- {text, x, y, rot, xScale, yScale, 
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

-- generic object print
-- this function isnt really needed anymore
-- DEPRICATED 11-17-2014!!
function DebugText:PrintObject(data)
	self:Text("")
	self:Text("Name: " .. data.name)
	self:Text("X: " .. data.x)
	self:Text("Y: " .. data.y)
end

-- draw all texts
function DebugText:Draw()

	if(self.active == false) then
		return
	end 

	-- use index for sub items in text tables
	local index = 1

	-- for each text item
	for i=1, #self.texts do

		-- for each text message in item
		for t=1, #self.texts[i] do
			love.graphics.setColor(self.texts[i][t].color or Color:AsTable(Color.white))
			LovePrint
			{
				text = self.texts[i][t].text,
				x = self.xStart,
				y = self.yStart + (self.ySpace * (index-1) ),
			}
			--love.graphics.print(self.texts[i][t].text, self.xStart, self.yStart + (self.ySpace * (index-1) ) )

			index = index + 1
		end 

	end 

	-- remove all texts for next frame
	-- only texts that are constantly passed are drawn
	self.ClearTexts()
end 

-- clears all texts
function DebugText:ClearTexts()

	for i=1, #DebugText.texts do
		DebugText.texts[i] = nil
	end 

end 


ObjectUpdater:AddStatic(DebugText)


-- Notes
-------------
-- need to add button for scrolling up and down text
-- since lots of objects overflows vertically

-- add in feature to print children or parents :P

-- DebugText is a Global
