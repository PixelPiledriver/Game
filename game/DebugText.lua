-- DebugText.lua
-->CLEAN
-->REFACTOR


-- Purpose
----------------------------
-- draw text info to screen
-- add --> function o:PrintDebugText()
-- to your object type to print to this


------------------
-- Requires
------------------
local Color = require("Color")
local Input = require("Input")

-----------------------------------------------------------------------------

-- global
DebugText = {}

----------------------
-- Static Info
----------------------
DebugText.Info = Info:New
{
	objectType = "DebugText",
	dataType = "Debug",
	structureType = "Manager"
}

----------------------
-- Static Vars
----------------------

-- On or Off
DebugText.active = true

-- all text messages that need to be drawn on the next frame
DebugText.texts = {}

DebugText.font = love.graphics.newFont(12)

----------------------
-- Print Type Flags
----------------------

-- flip these on and off 
-- to run o:PrintDebugText() for named object type
-- changed 'type' to 'messageType'

DebugText.messageType = 
{
	-- Managers
	ObjectManager = false,
	CollisionManager = false,
	DrawList = false,

	-- Statics
	ButtonStatic = false,
	ShaderStatic = false,
	MouseStatic = false,
	InputTextStatic = false,
	Info = false,

	-- Data types
	MapTable = false,
	Link = false,

	-- Objects
	Box = false,
	Camera = true,
	Bullet = false,
	Block = false,
	Controller = false,
	Window = false,
	Map = false,
	ParticleSystem = false,
	Particle = false,
	Life = false,
	SnapPlayer = false,
	
	-- Text
	InputText = false,

	-- Input
	Mouse = false,
	Keyboard = false,

	-- HUD
	Button = false,

	-- Tools
	DrawTools = false,
	
	--Components
	Collision = false,
	Pos = false,
	MouseHover = false,
	MouseDrag = false,

	-- Counters
	SinCounter = false,

	-- Graphics
	Line = true,
	Shape = false,
	Point = false,
	Palette = false,
	Animation = false,
	AnimationComponent = false,
	DrawLine = true,

	-- Other
	Generic = false

}



-- Draw Position
DebugText.xStart = 8
DebugText.yStart = 64
DebugText.xSpace = 16
DebugText.ySpace = 16


-- index of all messages for scrolling
-- using  mouse wheel
DebugText.messageIndex = 1
DebugText.lineIndex = 1

----------------
-- Functions
----------------

function DebugText:Update()
	
end 

-- debug text info can be scrolled thru
-- using the mouse and keyboard
function DebugText:ScrollMessagesControl()

	-- scroll object message index
	if(Mouse.wheelUp) then
		self.messageIndex = self.messageIndex - 1
	end 

	if(Mouse.wheelDown) then
		self.messageIndex = self.messageIndex + 1
	end

	-- set index within bounds of given min and max
	self.messageIndex = Math:Bind
											{
												value = self.messageIndex,
												min = 1,
												max = #self.texts
											}

  -- scroll each line of the first object message
  if(Keyboard:Key("2")) then
  	self.lineIndex = self.lineIndex + 1
  end 

  if(Keyboard:Key("1")) then
  	self.lineIndex = self.lineIndex - 1
  end

  if(#self.texts > 0) then
	  self.lineIndex = Math:Bind
	  								 {
	  								   value = self.lineIndex,
	  								   min = 1,
	  								   max = #self.texts[self.messageIndex]
	  								 }
	end 

end  



-- add a single line
function DebugText:Text(txt)
	self.texts[#self.texts + 1] = { {text = txt} }
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
-- { type = className, text = {string, color}, objectType}
function DebugText:TextTableSimple(data)

	local textType = data.type or "Generic"

	if(self.messageType[textType] == false) then
		return
	end 

	local convertedTable = {{text = "", data.objectType}}

	for i=1, #data.text do
		convertedTable[#convertedTable+1] = {text = data.text[i][1], color = data.text[i][2] or nil }
	end

	self.texts[#self.texts + 1] = convertedTable

end

-- {t, objectType}
function DebugText:PrintStringTable(data)
	local textTable = 
	{
		{text = "", data.objectType}
	}

	for i=1, #data.t do
		textTable[#textTable + 1] = {text = data.t[i], color = nil}
	end 

	self.texts[#self.texts + 1] = textTable

end

-- put table of elments 
-- {t, text}
function DebugText:AppendTableToText(data)
	for i=1, #data.t do
		data.text[#data.text + 1] = {text = data.t[i]}
	end 
end

-- draw all texts
function DebugText:Draw()

	if(self.active == false) then
		return
	end

	if(#self.texts < 1) then
		return
	end 

	-- set font for all messages
	-- each message could have its own font
	-- but I dont think it matters right now
	love.graphics.setFont(self.font)

	-- use index for sub items in text tables
	local index = 1

	self:ScrollMessagesControl()

	-- for each text item
	for i = self.messageIndex, #self.texts do

		-- line index controls how many sub messages are printed 
		local lineIndex = 0

		-- top message to be printed?
		if(i == self.messageIndex) then

			-- print messages starting from selected index
			lineIndex = self.lineIndex

		-- not top message?
		else

			-- print all sub messages
			lineIndex = 1

		end 

		-- for each text message in item
		for t = lineIndex, #self.texts[i] do

			-- draw the text
			love.graphics.setColor(self.texts[i][t].color and Color:AsTable(self.texts[i][t].color) or Color:AsTable(Color.white))
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


---------------
-- Static End
---------------

ObjectManager:AddStatic(DebugText)


-- Notes
------------- 
-- DONE!
	-- need to add button for scrolling up and down text
	-- since lots of objects overflows vertically

-- DONE! --> put a better way to control it tho :|
	-- need to be able to scroll thru each line of text of a single printed object
	-- add an alternate way to control it
	-- eventually add debug hud for this stuff like some buttons and a panel :P

-- NEED
	-- add in feature to print children or parents :P

-- Other
	-- DebugText is a Global, no need to require, just use

	-- Input wont work here because texts need to be gathered first....
	-- hrmmm weid... not sure what to do about that at this point :(

-- need to make a console too

-- need to convert the setup to be objects that submit themselves
-- using a debug text component
-- also need to simplify passing data to be printed
-->REFACTOR


