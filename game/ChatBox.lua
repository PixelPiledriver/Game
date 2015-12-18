-- ChatBox.lua

local Box = require("Box")
local Polygon = require("Polygon")
local Text = require("Text")
local Pos = require("Pos")
local Color = require("Color")
local Link = require("Link")
local Links = require("Links")
local Life = require("Life")

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
		color = Color:Get("black"),
	}

	--------------------------
	-- Width and Height
	--------------------------

	o.widthPad = data.widthPad or 16 --> not used yet -->FIX 
	o.maxWidth = data.maxWidth or ChatBox.default.width	

	-- control height of box relative to font and text
	o.fixedHeight = data.fixedHeight or false
	local heightAdjust = nil

	-- match text height?
	if(o.fixedHeight == false) then
		heightAdjust = o.text.font:getHeight(o.text.text)
	end 

	-- if font height is bigger than box height match height
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

	Link.newParent = o
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
	-- Pointer Graphics
	---------------------
	-- this creates a down facing centered pointer
	-- need to make other optional styles

	function o:CreateBoxPointer()
		o.boxPointer = Polygon:New
		{
			x = o.Pos.x,
			y = o.Pos.y,
			verts =
			{
				{x = 0, y = 0},
				{x = 5, y = 10},
				{x = 10, y = 0}
			},
			color = Color:Get(o.box.color.name)
		}

		Link:Simple
		{
			a = {o.boxPointer, "Pos", "x"},
			b = {o, "Pos", "x"},
			offsets =
			{
				{value = {(o.box.Size.width/2) - 5}}
			}
		}

		Link:Simple
		{
			a = {o.boxPointer, "Pos", "y"},
			b = {o, "Pos", "y"},
			offsets =
			{
				{object = {o.box.Size, "height"}}
			}
		}
	end 

	if(data.boxPointer) then
		o:CreateBoxPointer()
	end 

	---------------------
	-- Multiline text?
	---------------------
	-- if text doesnt fit box width, break it into multiple lines
	if(o.text:GetWidth() > o.maxWidth) then
		o.text:BreakIntoLines(o.maxWidth)
		o.box.Size.height = o.text.font:getHeight(o.text.text) * #o.text.multiLineText
	end 


	------------------------------
	-- Typing Animtaion Functions 
	------------------------------

	-- box overlap text and ruduces width to reveal text
	function o:SlidingBoxSetup()

		-- all boxes are stored together
		self.slideBox = {}

		-- the number of boxes to create
		self.slideBoxCount = self.text.multiLineText and #self.text.multiLineText or 1

		--		
		for i=1, self.slideBoxCount do

			-- create overlay 
			self.slideBox[#self.slideBox+1] = Box:New
			{
				layer = "Overlap",
				color = Color:GetCopy(self.box.color),
				width = self.box.Size.width,
				height = self.box.Size.height / self.slideBoxCount
			}

			self.slideBox[#self.slideBox].slideSpeed = ChatBox.default.slideSpeed
			self.slideBox[#self.slideBox].slideTotal = 0

			Link:Simple
			{
				a = {self.slideBox[#o.slideBox], "Pos", "x"},
				b = {self, "Pos", "x"},
			}

			Link:Simple
			{
				a = {self.slideBox[#o.slideBox], "Pos", "y"},
				b = {self, "Pos", "y"},
				offsets =
				{
					{value = {self.text.multiLineYSpace * (i-1)}}
				}
			}
		end 

		-- create slide box vars
		self.slideBoxIndex = 1
		self.slideBoxTotal = #o.slideBox
	end 

	

	function o:SlidingBoxUpdate()

		-- done with all slide boxes?
		if(self.slideBoxIndex > self.slideBoxCount) then
			if(self.Life.drain == false) then
				self.Life.drain = true
			end 

			return
		end 
		
		self.slideBox[self.slideBoxIndex].slideTotal = self.slideBox[self.slideBoxIndex].slideTotal + self.slideBox[self.slideBoxIndex].slideSpeed
		self.slideBox[self.slideBoxIndex].Size.width = self.slideBox[self.slideBoxIndex].Size.width - self.slideBox[self.slideBoxIndex].slideSpeed
		self.slideBox[self.slideBoxIndex].Pos.x = self.slideBox[self.slideBoxIndex].Pos.x + self.slideBox[self.slideBoxIndex].slideTotal

		if(self.slideBox[self.slideBoxIndex].Size.width <= 1) then
			self.slideBox[self.slideBoxIndex].color.a = 0
			ObjectManager:Destroy(self.slideBox[self.slideBoxIndex])
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
		
	--------------------
	-- Close ChatBox
	--------------------
	-- timer needs to start AFTER text is done typing
	-->FIX
	o.closeType = data.closeType or "timer"
	if(o.closeType == "timer") then
		o.Life = Life:New
		{
			life = 100,
			drain = false,
			parent = o
		}
	end 
	


	---------------
	-- Functions
	---------------

	-- reveals the text, type writer style
	function o:UpdateTypingAnimation()
		if(self.typingAnimation == nil) then
			return
		end 

		self.typingAnimation[self.typingAnimation.type].UpdateFunction(o)
	end 

	function o:Update()
		self:UpdateTypingAnimation()
		--self.Pos.x = self.Pos.x + 1
		--self.Pos.y = self.Pos.y + 1
	end

	function o:Destroy()
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.Pos)
		ObjectManager:Destroy(self.text)
		ObjectManager:Destroy(self.box)
		ObjectManager:Destroy(self.boxPointer)
		ObjectManager:Destroy(self.text)
		ObjectManager:Destroy(self.Life)
		
		self.Links:DestroyAll()
		ObjectManager:Destroy(self.Links)
		

		-- this probly wont be needed
		-- since destroy timer start after all
		-- slide boxes have been destroyed
		-- leave it in for now
		if(self.slideBox) then
			for i = self.slideBoxIndex, self.slideBoxTotal do
				ObjectManager:Destroy(self.slideBox[i])
			end 
		end



	end 

	o.typingAnimation[o.typingAnimation.type].SetupFunction(o)



	------------
	-- End
	------------

	ObjectManager:Add{o}

	return o

end 




ObjectManager:AddStatic(ChatBox)

return ChatBox



-- Notes
----------------------------
-->NEED
-- a way to stop multiple of the same chat box from being created
-- proby needs to be done on object that creates chatbox end
-- but might do it here
-- will think of something

-->NEED 
-- option var for setting chatbox to be unaffected by camera
-- this is so that zooming does not make the font get blurry

-->NEED
-- better default sizing - auto detect settings needed
-- global size options for player to adjust to their liking - manual settings

-->DONE
-- need to figure out how I'm going to do multiple lines
-- and text typing animation