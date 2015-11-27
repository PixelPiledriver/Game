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



----------------------
-- Static Input
----------------------
-- for controlling any object
-- not all objects can be controlled by the player
-- needs to be put into its own file

MapObject.selectedObjectForInput = nil
MapObject.Input = Input:New{}


--[[
local actionLeft =
{"left", "press", 
	function() 
		o.direction.x = -1
		o.direction.y = 0
		o:UseAction(o.selectedAction) 
	end
}

o.Input:AddKeys
{
	actionLeft, actionRight, actionDown, actionUp,
	nextAction, prevAction
}
--]]

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

	if(data.randomNameGet) then
		o.name = data.randomNameGet()
	end 

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

	o.xAbs = 0
	o.yAbs = 0

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

	o.selectedActionIndex = 1

	o.selectedAction = "nil" --data.actions[o.selectedActionIndex]
	if(o.actions and o.actions.index) then
		o.selectedAction = "walk"
	end 
	

	-------------
	-- Input
	-------------
	o.playerControlled = data.playerControlled or false

	-- is this object manually controlled by the player?
	if(o.playerControlled) then
		o.Input = Input:New{}

		-- use selected action in a dire
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

		-- select action
		local nextAction =
		{
			"e", "press",
			function()

				-- next
				o.selectedActionIndex = o.selectedActionIndex + 1

				-- bind max index value
				if(o.selectedActionIndex > #o.actions.index) then
					o.selectedActionIndex = #o.actions.index
				end 

				-- set action
				o.selectedAction = o.actions.index[o.selectedActionIndex]
			
				EventLog:Add{"Next Action: " .. o.selectedAction, "MapObject"}
				printDebug{"Next Action: " .. o.selectedAction, "MapObject"}
		
			end 
		}

		local prevAction =
		{
			"q", "press",
			function()

				-- prev
				o.selectedActionIndex = o.selectedActionIndex - 1
				
				-- bind min index value
				if(o.selectedActionIndex < 1) then
					o.selectedActionIndex = 1
				end 
				
				-- set action
				o.selectedAction = o.actions.index[o.selectedActionIndex]
	
				EventLog:Add{"Prev Action: " .. o.selectedAction, "MapObject"}
				printDebug{"Prev Action: " .. o.selectedAction, "MapObject"}

			end 		
		}

		o.Input:AddKeys
		{
			actionLeft, actionRight, actionDown, actionUp,
			nextAction, prevAction
		}

	end


	---------------
	-- Graphics
	---------------

	if(data.sprite) then
		o.sprite = MapObject.Sprites:Get(data.sprite)
		o.sprite.parent = o
	end 


	---------------
	-- Functions
	---------------


	-- use an action that this object posses
	function o:UseAction(actionName)

		-- use action --> run the action's function
		local success = o.actions[actionName]:Use(self)

		-- was action successful?
		if(success) then
			printDebug{actionName .. " successful", "MapObject", 2}
		else
			printDebug{actionName .. " failed", "MapObject", 2}
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

	-- does target allow action to be used on it? --> able = true
	function o:TargetReactionAble(reactionName)
		if(self:TargetHasReaction(reactionName) and self.actionTarget.reactions[reactionName].able) then
			return true
		end 

		return false
	end 

	-- does self allow action to be used on it? --> able = true
	function o:ReactionAble(reactionName)

		if(self.reactions and self.reactions[reactionName]) then
			return self.reactions[reactionName].able
		end

		return false
	end


	-- get the bool value of reaction
	-- looks for reactionName.able --> might change this later
	function o:TargetReactionAble(reactionName)

		if(self.actionTarget and self.actionTarget.reactions and self.actionTarget.reactions[reactionName]) then
			return self.actionTarget.reactions[reactionName].able
		end 

	end


	function o:Update()
		self.xAbs = self.mapWorld.x + (self.mapWorld.tileWidth * self.x) 
		self.yAbs = self.mapWorld.y + (self.mapWorld.tileHeight * self.y) 
	end 

	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
		ObjectUpdater:Destroy(self.Input)
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

	if(self.currentMapWorld and self.currentMapWorld:IsPosEmpty(data.x, data.y) == false) then
		printDebug{"Pos already taken", "MapObject"}
		return
	end 

	self.Objects[data.name].x = data.x
	self.Objects[data.name].y = data.y
	self:New(self.Objects[data.name])

end

-- populate map with objects in random position
-- this need another version of function that uses templates
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




------------------
-- Static End
------------------
ObjectUpdater:AddStatic(MapObject)


return MapObject

-- Notes
----------------------

-- Input should be made static to MapObject
-- that way any object can be controlled
-- object to control will be selected with a variable

-- breaking down into seperate files
-- little by little





-- Junk
--------------------------------------------------------
--[[

		-- select an action
		local selectAction1 =
		{
			"z", "press",
			function()
				o.selectedAction = o.actions.walk.name
				printDebug{"action select: " .. o.selectedAction, "MapObject"}
			end 
		}

		local selectAction2 =
		{
			"x", "press",
			function()
				o.selectedAction = o.actions.chat.name
				printDebug{"action select: " .. o.selectedAction, "MapObject"}
			end 
		}

		local selectAction3 =
		{
			"c", "press",
			function()
				o.selectedAction = o.actions.push.name
				printDebug{"action select: " .. o.selectedAction, "MapObject"}
			end 
		}

		local selectAction4 =
		{
			"v", "press",
			function()
				o.selectedAction = o.actions.push.name,
				printDebug{"action select: " .. o.selectedAction}
			end 
		}



--]]