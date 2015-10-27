-- MapObject.lua

-- Purpose
------------------------------------
-- object that can be placed into MapWorld


local MapObject = {}

------------------
-- Static Info
------------------
MapObject.Info = Info:New
{
	objectType = "MapObject",
	dataType = "GameObject",
	structureType = "Static"
}

-----------------
-- Static Vars
-----------------
-- place New objects into this MapWorld 
MapObject.currentMapWorld = nil

--------------
-- Actions
--------------
-- default actions that MapObjects can use on other MapObjects

MapObject.actions = {}

MapObject.actions.walk =
{
	x = 1,
	y = 0
}

MapObject.actions.chat = 
{
	x = 1,
	y = 0	
}




-------------
-- Object
-------------

function MapObject:New(data)

	if(self.currentMapWorld == nil) then
		printDebug{"No MapWorld to put MapObject into!", "MapObject"}
		return
	end 

	local o = {}

	------------
	-- Info
	------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "MapObject",
		dataType = "GameObject",
		structureType = "Object"
	}

	---------
	-- Vars
	---------
	o.map = self.currentMapWorld
	o.type = data.type or "None"
	o.name = data.name or "..."

	o.mood = data.mood or "None"

	-- fix this later
	o.reactions = data.reactions or {}

	-- this needs to be refactored into the Walk action
	-- all actions should be able to contain a timer component
	-- so they can act on their own if needed
	o.move =
	{
		use = data.move,
		wait = 20,
		waitCount = 0
	}

	o.x = data.x or 1
	o.y = data.y or 1

	self.currentMapWorld:Add
	{
		object = o,
		x = data.x or 1,
		y = data.y or 1
	}

	------------
	-- Actions
	------------
	-- potential object in map to use action against
	o.actionTarget = nil

	-- create action tables for this object
	o.actions = {}

	if(data.actions) then
		for i=1, #data.actions do	
			o.actions[data.actions[i]] = self.actions[data.actions[i]] or {}
		end 
	end 

	o.actions.direction =
	{
		x = 1,
	  y = 0
	}

	---------------
	-- Funcitons
	---------------

	-- use an action that this object poses
	function o:UseAction(actionName)

		--self.actionTarget = self.map:Get(self.x + self.actions[actionName].x, self.y + self.actions[actionName].y)
		self.actionTarget = self.map:Get(self.x + self.actions.direction.x, self.y + self.actions.direction.y)
		
		if(self.actionTarget == nil) then
			printDebug{"No target", "MapObject"}
			return false
		end 


		local success = o[actionName](self)

		if(success) then
			printDebug{actionName .. " successful", "MapObject"}
		else
			printDebug{actionName .. " failed", "MapObject"}
		end 

		-- target has reaction message?
		if(self.actionTarget and self.actionTarget.reactions) then
			if(self.actionTarget.reactions[actionName].message) then
				printDebug{self.name .. self.actionTarget.reactions[actionName].message, "MapObject"}
			end 
		end

		self.actionTarget = nil

	end 

	-- check if target has reaction
	function o:TargetHasReaction(reactionName)
		if(self.actionTarget and self.actionTarget.reactions and self.actionTarget.reactions[reactionName]) then
			return true
		end

		return false
	end

	-- get the bool value of reaction
	-- looks for reactionName.able --> might change this later
	function o:TargetReactionState(reactionName)
		if(self.actionTarget and self.actionTarget.reactions and self.actionTarget.reactions[reactionName]) then
			return self.actionTarget.reactions[reactionName].able
		end 
	end

	function o:chat()

		-- cannot chat with target
		if(self:TargetHasReaction("chat") == false) then
			printDebug{"Cannot chat with target", "MapObject"}
			return false
		end 

		if(self:TargetReactionState("chat")) then
			print(self.actionTarget.reactions.chat.chat)
			return true
		end

		return false 

	end 

	-- walk action
	-- (b) = other MapObject to interact with
	function o:walk()

		--[[
		self.actionTarget = self.map:Get(self.x + self.actions.walk.x, self.y + self.actions.walk.y)

		if(self.actionTarget == nil) then
			printDebug{"No target", "MapObject"}
			return false
		end 
		--]]

		-- able to walk?
		if(self.actionTarget.reactions and self.actionTarget.reactions.walk and self.actionTarget.reactions.walk.able == false) then
			
			-- change direction test
			-- this needs to be moved somewhere
			-- actions need to be a bit more complicated it seems
			-- and have changes that can be made upon failure
			self.actions.direction.x = 0
			self.actions.direction.y = 1

			return false
		end 		

		-- for now the objects swap places
		-- this is not the correct response in all cases
		-- but will fix later
		-- there needs to be 2 maps
		-- a terrain map and an object map
		-- or just a map that can hold 2 objects in a sigle slot --> yes :D
		self.map.map:Swap
		{
			a = {x = self.x, y = self.y},
			b = {x = self.x + self.actions.direction.x, y = self.y + self.actions.direction.y}
			--b = {x = self.x + self.actions.walk.x, y = self.y + self.actions.walk.y}
		}
	
		-- update pos values of self
		--self.x = self.x + self.actions.walk.x
		--self.y = self.y + self.actions.walk.y
		self.x = self.x + self.actions.direction.x
		self.y = self.y + self.actions.direction.y


		-- upate pos values of target
		-- to compensate for the swap
		if(self.actionTarget.x) then
			--self.actionTarget.x = self.actionTarget.x - self.actions.walk.x
			self.actionTarget.x = self.actionTarget.x - self.actions.direction.x
		end 

		if(self.actionTarget.y) then
			--self.actionTarget.y = self.actionTarget.y - self.actions.walk.y
			self.actionTarget.y = self.actionTarget.y - self.actions.direction.y
		end 

		
		return true

	end 


	function o:Update()
		if(self.move.use) then

			self.move.waitCount = self.move.waitCount + 1

			if(self.move.waitCount > self.move.wait) then
				self.move.waitCount = 0
				
				self:UseAction("chat")
				self:UseAction("walk")


			end

		end 

	end 

	----------------
	-- Object End
	----------------

	ObjectUpdater:Add{o}

	return o

end



return MapObject


-- Notes
----------------------------
-- Walk  function is an example of how this should work
-- actions and accepts
-- objects have actions the use on other objects
-- objects have accepts that define if the action can be done to them
-- and how they should react


-- Junk
--------------------------------
--[[
self.map.map:Swap
{
	a = {x = self.x, y = self.y},
	b = {x = self.x + 1, y = self.y}
}

self.x = self.x + 1





	-- {actionName, b = object to use action on}
	function o:UseActionOn(data)
		o[data.actionName](data.b)
	end 



--]]
