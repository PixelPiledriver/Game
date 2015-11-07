-- MapObject.lua

-- Purpose
------------------------------------
-- object that can be placed into MapWorld


--------------
-- Requires
--------------
local Input = require("Input")

-------------------------------------------

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
	o.mapWorld = self.currentMapWorld
	o.type = data.type or "None"
	o.name = data.name or "..."

	o.mood = data.mood or "None"

	-- fix this later
	o.reactions = data.reactions or {}

	-- this needs to be refactored into the Walk action
	-- all actions should be able to contain a timer component
	-- so they can act on their own if needed
	o.active =
	{
		use = data.active,
		wait = 40,
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
	o.actions = data.actions or {}

	-- all actions use this to determine
	-- the location of their target
	o.direction =
	{
		x = 1,
	  y = 0,
	  pattern = data.direction and data.direction.pattern or nil
	}

	o.selectedAction = o.actions[1]

	-------------
	-- Control
	-------------
	o.playerControlled = data.playerControlled or false

	-- is this object manually controlled by the player?
	if(o.playerControlled) then
		o.Input = Input:New{}

		-- direct and use selected action
		local actionLeft =
		{"left", "press", 
			function() 
				o.direction.x = -1
				o.direction.y = 0
				o:UseAction(o.selectedAction) 
			end
		}

		local actionRight =
		{"right", "press", 
			function() 
				o.direction.x = 1
				o.direction.y = 0
				o:UseAction(o.selectedAction) 
			end
		}

		local actionDown =
		{"down", "press", 
			function() 
				o.direction.x = 0
				o.direction.y = 1
				o:UseAction(o.selectedAction) 
			end
		}

		local actionUp =
		{"up", "press", 
			function() 
				o.direction.x = 0
				o.direction.y = -1
				o:UseAction(o.selectedAction) 
			end
		}

		-- select an action
		local selectAction1 =
		{
			"z", "press",
			function()
				o.selectedAction = o.actions[1]
				printDebug{"action select: " .. o.selectedAction, "MapObject"}
			end 
		}

		local selectAction2 =
		{
			"x", "press",
			function()
				o.selectedAction = o.actions[2]
				printDebug{"action select: " .. o.selectedAction, "MapObject"}
			end 
		}

		local selectAction3 =
		{
			"c", "press",
			function()
				o.selectedAction = o.actions[3]
				printDebug{"action select: " .. o.selectedAction, "MapObject"}
			end 
		}

		o.Input:AddKeys
		{
			actionLeft, actionRight, actionDown, actionUp,
			selectAction1, selectAction2, selectAction3
		}
	end 

	---------------
	-- Funcitons
	---------------

	-- use an action that this object poses
	function o:UseAction(actionName)

		-- get target
		self.actionTarget = self.mapWorld:Get(self.x + self.direction.x, self.y + self.direction.y)
		
		-- does object have a target? --> this will most likely be phased out as even empty slots will be targets
		if(self.actionTarget == nil) then
			printDebug{"No target", "MapObject"}
			return false
		end 

		-- use action
		local success = o[actionName](self)

		-- was action successful?
		if(success) then
			printDebug{actionName .. " successful", "MapObject", 2}
		else
			printDebug{actionName .. " failed", "MapObject", 2}
		end 

		-- target has reaction message?
		if(self:TargetHasReaction(actionName)) then
			if(self.actionTarget.reactions[actionName].message) then
				printDebug{self.name .. self.actionTarget.reactions[actionName].message, "MapObject", 2}
			end 
		end

		-- remove target after action is done
		self.actionTarget = nil

	end 

	-- does target have reaction of given action?
	function o:TargetHasReaction(reactionName)
		if(self.actionTarget and self.actionTarget.reactions and self.actionTarget.reactions[reactionName]) then
			return true
		end

		return false
	end

	-- does target react to given action?
	function o:ReactionAble(reactionName)
		if(self.reactions and self.reactions[reactionName]) then
			return self.reactions[reactionName].able
		end 
	end

	-- get the bool value of reaction
	-- looks for reactionName.able --> might change this later
	function o:TargetReactionAble(reactionName)
		if(self.actionTarget and self.actionTarget.reactions and self.actionTarget.reactions[reactionName]) then
			return self.actionTarget.reactions[reactionName].able
		end 
	end


	-- remove target from the map
	-- for now, fill space with default empty
	function o:kill()
		if(self:TargetReactionAble("kill") == false) then
			printDebug{"Cannot kill " .. (self.actionTarget.name or "nothing"), "MapObject"}
		end 		

		self.mapWorld.map:Remove{x = self.actionTarget.x, y = self.actionTarget.y}

		return true

	end 

	-- kills target and moves to the space it occupied
	function o:replace()

		if(self:TargetReactionAble("replace") == false) then
			printDebug{"Cannot replace " .. (self.actionTarget.name or "nothing"), "MapObject"}
		end 

		-- this funcition is unfinished
		-->FIX

	end 

	-- move this object from its relative pos in the map to another pos
	function o:jumpFromHereTo()

		-- dont think this is needed
		-- jumping doesnt use an action target
		--[[
		if(self:TargetReactionAble("jumpTo") == false) then
			printDebug{"Cannot jump to " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end
		--]]

		local x = self.x + self.direction.x
		local y = self.y + self.direction.y

		-- already in same pos?
		if(self.x == x and self.y == y) then
			printDebug{"JumpFromHereTo pos is same as pos", "MapObject"}
			return false
		end 

		-- is pos to jump to inside map?
		if(self.mapWorld.map:IsPosInBounds{x = x, y = y} == false) then
			printDebug{"Jump to positon is out of bounds", "MapObject"}
			return false	
		end 

		local landTarget = self.mapWorld:Get(x, y)
		
		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		self.mapWorld.map:MoveTo
		{
			a = {x = self.x, y = self.y},
			b = {x = x, y = y}
		}

		return true

	end 

	-- move this object to a specific pos in the map
	function o:jumpTo()

		-- dont think this is needed
		-- jumping doesnt use an action target
		--[[
		if(self:TargetReactionAble("jumpTo") == false) then
			printDebug{"Cannot jump to " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end
		--]]

		if(self.direction.x == self.x and self.direction.y == self.y) then
			printDebug{"Object in same position as jump to position", "MapObject"}
			return false			
		end

		-- is pos to jump to inside map?
		if(self.mapWorld.map:IsPosInBounds{x = self.direction.x, y = self.direction.y} == false) then
			printDebug{"Jump to positon is out of bounds", "MapObject"}
			return false	
		end 

		local landTarget = self.mapWorld:Get(self.direction.x, self.direction.y)

		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		local success = self.mapWorld.map:MoveTo
		{
			a = {x = self.x, y = self.y},
			b = {x = self.direction.x, y = self.direction.y}
		}

		if(success == false) then
			return false
		end

		return true
	end 

	function o:jumpOver()

		if(self:TargetReactionAble("jumpOver") == false) then
			printDebug{"Cannot jump over " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end

		local landTarget = self.mapWorld:Get(self.actionTarget.x + self.direction.x, self.actionTarget.y + self.direction.y)

		-- does landTarget exist? if not its probly outside the map
		if(landTarget == nil) then
			printDebug{"No landTarget for jump over", "MapObject"}
			print(self.actionTarget.x)
			return false
		end 

		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		self.mapWorld.map:Swap
		{
			a = {x = self.x, y = self.y},
			b = {x = self.actionTarget.x + self.direction.x, y = self.actionTarget.y + self.direction.y}
		}

		-- update pos values of self
		self.x = self.actionTarget.x + self.direction.x
		self.y = self.actionTarget.y + self.direction.y

	end 

	-- move the target in the direction
	function o:push()
		if(self:TargetHasReaction("push") == false) then
			printDebug{"Cannot push " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end

		self.actionTarget.direction = self.direction
		self.actionTarget:UseAction("walk")

		return true
	end 

	-- talk to target
	-- this is very basic at the moment
	-- in the future it will active a seperate Chat component
	function o:chat()

		-- cannot chat with target
		if(self:TargetHasReaction("chat") == false) then
			printDebug{"Cannot chat with " .. (self.actionTarget.name or "nothing"), "MapObject"}
			return false
		end 

		if(self:TargetReactionAble("chat")) then
			print(self.actionTarget.reactions.chat.chat)
			return true
		end

		return false 

	end 

	-- walk action
	function o:walk()


		-- able to walk?
		if(self:TargetReactionAble("walk") == false) then
			
			printDebug{"Cannot walk on " .. (self.actionTarget.name or "nothing"), "MapObject"}

			-- change direction test
			-- this needs to be moved somewhere
			-- actions need to be a bit more complicated it seems
			-- and have changes that can be made upon failure
			self.direction.x = 0
			self.direction.y = 1

			return false

		end 		

		-- for now the objects swap places
		-- this is not the correct response in all cases
		-- but will fix later
		-- there needs to be 2 maps
		-- a terrain map and an object map
		-- or just a map that can hold 2 objects in a sigle slot --> yes :D
		self.mapWorld.map:Swap
		{
			a = {x = self.x, y = self.y},
			b = {x = self.x + self.direction.x, y = self.y + self.direction.y}
		}
	
		-- update pos values of self
		self.x = self.x + self.direction.x
		self.y = self.y + self.direction.y

		-- upate pos values of target
		-- to compensate for the swap
		if(self.actionTarget.x) then
			self.actionTarget.x = self.actionTarget.x - self.direction.x
		end 

		if(self.actionTarget.y) then
			self.actionTarget.y = self.actionTarget.y - self.direction.y
		end

		
		return true

	end 


	function o:Update()

		-- this is one massive test area
		-- makes it so objects use actions on their own
		-- a full featured AI component will need
		-- to be developed at some point
		if(self.active.use) then

			self.active.waitCount = self.active.waitCount + 1

			if(self.active.waitCount > self.active.wait) then
				self.active.waitCount = 0
				
				-- Actions Test
				-------------------
				-- needs to be moved eventually
				--self:UseAction("chat")
				--self:UseAction("push")
				--self:UseAction("jumpOver")
				--self:UseAction("walk")
				--self:UseAction("kill")
				self.direction.x = 0
				self.direction.y = 0
				self:UseAction("jumpFromHereTo")


				self.active.use = false
				
				-- direaction pattern test
				-- needs to be moved eventually
				if(self.direction.pattern) then
					self.direction.pattern.index = self.direction.pattern.index + 1

					if(self.direction.pattern.index > #self.direction.pattern.steps) then
						self.direction.pattern.index = 1
					end

					local index = self.direction.pattern.index

					self.direction.x = self.direction.pattern.steps[index].x
					self.direction.y  = self.direction.pattern.steps[index].y

				end 

			end

		end 

	end 

	----------------
	-- Object End
	----------------

	ObjectUpdater:Add{o}

	return o

end


---------------------
-- Static Functions
---------------------

-- create a mapObject from the template list
-- {name, x, y}
function MapObject:Create(data)
	self.objects[data.name].x = data.x
	self.objects[data.name].y = data.y
	self:New(self.objects[data.name])
end

-- use to populate map with objects in random positions
function MapObject:CreateRandom(data)
	
	for i=1, data.count do
		self:Create
		{
			name = data.name,
			x = Random:Range(1, self.currentMapWorld.map.width),
			y = Random:Range(1, self.currentMapWorld.map.height)
		}
	end 
	
end  

-------------
-- Objects
-------------
-- library of objects that can be created
-- make a copy from a template
MapObject.objects = {}

MapObject.objects.tree =
{
	type = "plant",
	name = "tree",
	reactions = 
	{
		walk = {able = false, message = " bumps into the tree"},
		chat = {able = true, chat = "The tree says nothing... but creaks in response"},
		chop = {able = true, chat = "The mighty cannot handle the chopping action"}
	},
	x = 0,
	y = 0
}

MapObject.objects.pond =
{
	type = "water",
	name = "pond",
	reactions = 
	{
		walk = {able = false, message = " can't swim."},
		chat = {able = true, chat = "You look at your reflection."},
	},
	x = 0,
	y = 0
}

MapObject.objects.rock =
{
	type = "rock",
	name = "rock",
	reactions = 
	{
		walk = {able = false, message = " finds it unsafe to get on top of."},
		chat = {able = true, chat = "The rock has nothing to say..."},
		push = {able = true}
	},
	x = 0,
	y = 0	
}


return MapObject

-- test area
--[[

local Actions = {}
Actions.chat = 
{
-- has reaction
if(self:TargetHasReaction("chat") == false) then
	printDebug{"Cannot chat with " .. (self.actionTarget.name or "nothing"), "MapObject"}
	return false
end 

		if(self:TargetReactionAble("chat")) then
			print(self.actionTarget.reactions.chat.chat)
			return true
		end

		return false 

	end 

--]]

-- Notes
----------------------------
-- need to have a function that can create a shared space
-- by creating a link or table in the slot
-- that references the the objects in the space
-- but only creates such a table when necessary
-- otherwise all slots in the map must be dealt with as on table deep
-- and I dont think I really want to do that


-- Walk function is an example of how this should work
-- actions and accepts
-- objects have actions the use on other objects
-- objects have accepts that define if the action can be done to them
-- and how they should react

-- pattern --> action sub table of values to do over and over
-- path --> action sub table of values to complete and delete each step
-- pattern would be a very useful component for all object types
-- consider writing a more complete version of it

-- actions need to be refactored into their own file at some point
-- right now actions only work with MapObjects
-- but they should probly work for anything
-- anyway lets keep it simple and contained for now

-- Junk
--------------------------------
--[==[
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


--self.actionTarget = self.map:Get(self.x + self.actions[actionName].x, self.y + self.actions[actionName].y)



		--[[
		self.actionTarget = self.map:Get(self.x + self.actions.walk.x, self.y + self.actions.walk.y)

		if(self.actionTarget == nil) then
			printDebug{"No target", "MapObject"}
			return false
		end 
		--]]


		--self.x = self.x + self.actions.walk.x
		--self.y = self.y + self.actions.walk.y

--self.actionTarget.x = self.actionTarget.x - self.actions.walk.x

--self.actionTarget.y = self.actionTarget.y - self.actions.walk.y


--b = {x = self.x + self.actions.walk.x, y = self.y + self.actions.walk.y}




	if(data.actions) then
		for i=1, #data.actions do	
			o.actions[data.actions[i]] = self.actions[data.actions[i]] or {}
		end 
	end 

--]==]
