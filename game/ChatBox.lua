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

-----------------
-- Object
----------------

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

	o.text = Text:New
	{
		text = data.text or "...",
		color = Color:Get("black")
	}

	o.widthPad = data.widthPad or 16

	o.box = Box:New
	{
		width = o.text:GetWidth()	+ o.widthPad
	}

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

	---------------
	-- Functions
	---------------
	function o:Update()
	
	end 


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