-- ChatBox.lua

local Box = require("Box")
local Text = require("Text")
local Pos = require("Pos")
local Color = require("Color")
local Link = require("Link")

local ChatBox = {}

----------------
-- Static Info
----------------
ChatBox.Info = Info:New
{
	objectType = "ChatBox",
	dataType = "Text",
	structureType = "Static"
}

----------------
-- Static Vars
----------------
ChatBox.default = {}
ChatBox.default.slideSpeed = 2.5
ChatBox.default.width = 128
ChatBox.default.height = 64

-----------------
-- Object
-----------------

function ChatBox:New(data)

	local o = {}

	---------------
	-- Info
	---------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "ChatBox",
		dataType = "Text",
		structureType = "Object"
	}

	-----------
	-- Vars
	-----------

	o.Pos = Pos:New
	{
		x = data.x,
		y = data.y
	}


	--------------
	-- Text
	--------------
	o.text = Text:New
	{
		text = data.text or "...",
		color = Color:Get("black")
	}

	--------------------------
	-- Width and Height
	--------------------------

	o.widthPad = data.widthPad or 16 --> not used yet -->FIX 
	o.maxWidth = data.maxWidth or ChatBox.default.width	

	-- if text height of text is bigger than data.height
	-- increase height
	-->FIX
	local heightAdjust = nil
	if(o.text.font:getHeight(o.text.text) > (data.height or ChatBox.default.height)) then
		heightAdjust = o.text.font:getHeight(o.text.text)
		printDebug{"Height adjusted to fit font", "ChatBox"}
	end 


	-------------------
	-- Box Graphics
	-------------------
	-- simple box for now
	o.box = Box:New
	{
		width = math.min(o.text:GetWidth(), o.maxWidth) + o.widthPad or ChatBox.default.width,
		height = heightAdjust or data.height or ChatBox.default.height
	}

	o.boxAlign = data.boxAlign or "left"
	if(o.boxAlign == "center") then
		o.Pos.x = o.Pos.x - (o.box.Size.width * 0.5)
	end 

	-- link box and text to ChatBox object
	Link:Simple
	{
		a = {o.box, "Pos", {"x", "y"}},
		b = {o, "Pos", {"x", "y"}},
	}

	Link:Simple
	{
		a = {o.text, "Pos", {"x", "y"}},
		b = {o, "Pos", {"x", "y"}},
		-- need offsets here for alignment types
		-->FIX
	}

	---------------------
	-- Multiline text?
	---------------------
	-- if text doesnt fit box width, break it into multiple lines
	if(o.text:GetWidth() > o.maxWidth) then
		o.text:BreakIntoLines(o.maxWidth)
		o.box.Size.height = o.text.font:getHeight(o.text.text) * #o.text.multiLineText
	end 



	------------------------------
	-- Tying Animtaion Functions 
	------------------------------

	-- box overlap text and ruduces width to reveal text
	function o:SlidingBoxSetup()
		-- will need to make one for each line
		-->FIX
		o.slideBox = {}
		
		for i=1, #self.text.multiLineText do

			-- create overly 
			o.slideBox[#o.slideBox+1] = Box:New
			{
				layer = "Overlap",
				color = Color:GetCopy(o.box.color),
				width = self.box.Size.width,
				height = self.box.Size.height / # self.text.multiLineText
			}

			o.slideBox[#o.slideBox].slideSpeed = ChatBox.default.slideSpeed
			o.slideBox[#o.slideBox].slideTotal = 0

			Link:Simple
			{
				a = {o.slideBox[#o.slideBox], "Pos", "x"},
				b = {o, "Pos", "x"},
			}

			Link:Simple
			{
				a = {o.slideBox[#o.slideBox], "Pos", "y"},
				b = {o, "Pos", "y"},
				offsets =
				{
					{value = {self.text.multiLineYSpace * (i-1)}}
				}
			}



		end 

			o.slideBoxIndex = 1
	end 

	

	function o:SlidingBoxUpdate()

		-- done with all slide boxes?
		if(self.slideBoxIndex > #self.text.multiLineText) then
			return
		end 
		
		self.slideBox[self.slideBoxIndex].slideTotal = self.slideBox[self.slideBoxIndex].slideTotal + self.slideBox[self.slideBoxIndex].slideSpeed
		self.slideBox[self.slideBoxIndex].Size.width = self.slideBox[self.slideBoxIndex].Size.width - self.slideBox[self.slideBoxIndex].slideSpeed
		self.slideBox[self.slideBoxIndex].Pos.x = self.slideBox[self.slideBoxIndex].Pos.x + self.slideBox[self.slideBoxIndex].slideTotal

		if(self.slideBox[self.slideBoxIndex].Size.width <= 0) then
			ObjectUpdater:Destroy(self.slideBox[self.slideBoxIndex])
			self.slideBoxIndex = self.slideBoxIndex +  1
		end
	end 

	----------------------------
	-- Typing Animation Vars
	----------------------------

	o.typingAnimation = data.typingAnimation
	
	if(o.typingAnimation == nil) then
		o.typingAnimation = {}
		o.typingAnimation.type = "slidingBox"
	end 
	


	-- type = {SetupFunction, UpdateFunction}
	o.typingAnimation.slidingBox = {}
	o.typingAnimation.slidingBox.SetupFunction = o.SlidingBoxSetup 
	o.typingAnimation.slidingBox.UpdateFunction = o.SlidingBoxUpdate
		

	---------------
	-- Functions
	---------------

	function o:UpdateTypingAnimation()
		-- does self have typing animation?
		if(self.typingAnimation == nil) then
			return
		end 

		self.typingAnimation[self.typingAnimation.type].UpdateFunction(o)

	end 

	function o:Update()
		self:UpdateTypingAnimation()
	end

	o.typingAnimation[o.typingAnimation.type].SetupFunction(o)



	------------
	-- End
	------------

	ObjectUpdater:Add{o}

	return o

end 




ObjectUpdater:AddStatic(ChatBox)

return ChatBox



-- Notes
----------------------------
-- need to figure out how I'm going to do multiple lines
-- and text typing animation