-- EventLog.lua

-- Purpose
--------------------------
-- records and displays things that happen at runtime
-- in text format


----------------
-- Requires
----------------
local Text = require("Text")
local Pos = require("Pos")

-----------------------------------------

-- global
EventLog = {}



-------------
-- Info
-------------
EventLog.Info = Info:New
{
	objectType = "EventLog",
	dataType = "Information",
	structureType = "Manager"
}

-----------------
-- Vars
-----------------
EventLog.eventTexts = {}
EventLog.allEvents = {}
EventLog.maxCount = 5
EventLog.ySpace = 18
EventLog.eventIndex = 1

EventLog.Pos = Pos:New
{
	x = love.window.getWidth() * 0.05, 
	y = love.window.getHeight() * 0.95
}

EventLog.priority =
{
	true,
	false,
	false,
	false	
}

function EventLog:Add(data)

	local priority = data[3] or 1

	if(self.priority[priority] == false) then
		return
	end 

	if(self.eventTexts[self.eventIndex] == nil) then
		self.eventTexts[self.eventIndex] = Text:New
		{
			text = data[1],
		}
	else
		-- remove old text
		ObjectUpdater:Destroy(self.eventTexts[self.eventIndex])
		self.eventTexts[self.eventIndex] = nil
		
		-- replace the spot in table with this new text
		self.eventTexts[self.eventIndex] = Text:New
		{
			text = data[1],
		}		
	end 

	-- place new text at bottom of diplayed list
	self.eventTexts[self.eventIndex].Pos.y = self.Pos.y - self.ySpace

	-- push up all other messages
	for i=1, #self.eventTexts do
		repeat

		-- skip the brand new text
		if(i == self.eventIndex) then
			break
		end 

		self.eventTexts[i].Pos.y = self.eventTexts[i].Pos.y - self.ySpace

		until true
	end 

	self.eventIndex = self.eventIndex + 1

	if(self.eventIndex > self.maxCount) then
		self.eventIndex = 1
	end 

end 

function EventLog:Add2(data)
	self.allEvents[#self.allEvents+1] = data

	self.eventTexts[#self.eventTexts+1] = Text:New
	{
		text = data[1],
		objectType = data[2]
	}

	self.eventTexts[#self.eventTexts].Pos.x = self.Pos.x
	self.eventTexts[#self.eventTexts].Pos.y = self.Pos.y + (#self.eventTexts * self.ySpace)
	self.Pos.y = self.Pos.y - self.ySpace

	-- push other messages up
	-- this is only used for nonslide mode
	for i=1, #self.eventTexts do
		self.eventTexts[i].Pos.y = self.eventTexts[i].Pos.y - self.ySpace
	end 

end 

function EventLog:Update()
end 







-- Notes
-------------------
-- seems to work alright
-- might add a panel to this object
-- so it can be dragged around
-- or might just go simple with a box

-- may need to have table sliding function for this object
-- so that new messages can push old ones upwards

-- funnel stuff from here to printDebug so they can be
-- sort of the same thing

-- different types
-- for now just going to do a stack of 5-10 events
-- that it clears as it pushes them out