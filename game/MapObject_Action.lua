-- MapObject.Action.lua

-- Purpose 
-----------------------------
-- actions for MapObjects to use
-- does not work with other object types

------------------
-- Requires
-------------------
local MapObject = require("MapObject")

-------------------------------------------------------
-- Sub Component
MapObject.Action = {}

MapObject.Action.parentObject = nil

--{name, func, }
function MapObject.Action:New(data)

	local o = {}

	o.name = data.name
	o.func = data.func
	o.noReactionFunc = data.noReactionFunc or nil
	o.failMessage = data.failMessage
	o.failMessageFirst = data.failMessageFirst or true

	o.requireReaction = true 
	if(data.requireReaction ~= nil) then 
		o.requireReaction = data.requireReaction
	end 

	o.otherRequiredReactions = data.otherRequiredReactions or nil

	o.x = data.x or nil
	o.y = data.y or nil


	-- run action function
	function o:Use(object)

		-- how to get target?
		-- relative position?
		if(self.targetPos) then
			print("targetPos: " .. self.targetPos.x .. ", " .. self.targetPos.y)
			object.actionTarget = object.mapWorld:Get(object.x + self.targetPos.x, object.y + self.targetPos.y)
			
		-- absolute position?
		elseif(self.targetAbsPos) then
			object.actionTarget = object.mapWorld:Get(self.targetAbsPos.x, self.targetAbsPos.y)

		-- by direction?
		else
			object.actionTarget = object.mapWorld:Get(object.x + object.direction.x, object.y + object.direction.y)
		end 
		
		-- was a target found?
		-- most likely case of 'No Target' is out of bounds --> even empty tiles can be targeted
		if(object.actionTarget == nil) then
			printDebug{"No target", "MapObject"}
			return false
		end 

		-- state action used
		printDebug{"used action: " .. o.name, "MapObject", 2}
		
		-- does target reaction to this action? does this action require it?
		if(self.requireReaction and object:TargetHasReaction(self.name) == false) then

			-- some action types have something different to do on absence of a reaction
			if(self.noReactionFunc) then
				self:noReactionFunc(object)
			end
			
			return false
		end

		-- does action require reactions other than its own name?
		if(self.otherRequiredReactions) then

			-- does target have all reactions in list?
			for i=1, #self.otherRequiredReactions do

				if(object:TargetHasReaction(self.otherRequiredReactions[i]) == false) then

					if(self.noReactionFunc) then
						self:noReactionFunc(object)
					end

					return false

				end 

				-- target able for other reactions?
				if(object:TargetReactionAble(self.otherRequiredReactions[i]) == false) then
					
					if(self.failMessageFirst) then
						printDebug{self.failMessage .. object.actionTarget.name, "MapObject", 2}
					else
						printDebug{object.actionTarget.name .. self.failMessage, "MapObject", 2}
					end 
					
					return false
				end

			end 

		end

		-- is target able? does it allow the action?
		if(object:TargetReactionAble(self.name) == false) then
			
			if(self.failMessageFirst) then
				printDebug{self.failMessage .. object.actionTarget.name, "MapObject", 2}
			else
				printDebug{object.actionTarget.name .. self.failMessage, "MapObject", 2}
			end 
			
			return false
		end

		self.func(object)

		return true
	end 

	return o

end 


function MapObject.Action:Get(actionName)
	return self:New(MapObject.Action[actionName])
end


---------------------
-- Actions
---------------------

MapObject.Action.walk =
{
	name = "walk",

	failMessage = "Cannot walk on ",

	func = function(object)

		-- if target space has object in it, switch pos with each other
		object.mapWorld.map:Swap
		{
			a = {x = object.x, y = object.y},
			b = {x = object.x + object.direction.x, y = object.y + object.direction.y}
		}
	
		-- update pos values of self
		object.x = object.x + object.direction.x
		object.y = object.y + object.direction.y

		-- upate pos values of target
		-- to compensate for the swap
		if(object.actionTarget.x) then
			object.actionTarget.x = object.actionTarget.x - object.direction.x
		end 

		if(object.actionTarget.y) then
			object.actionTarget.y = object.actionTarget.y - object.direction.y
		end

	end 
}

-- talk to target
-- this is very basic at the moment
-- in the future it will active a seperate Chat component
MapObject.Action.chat =
{
	name = "chat",

	failMessage = " has nothing to say",
	failMessageFirst = false,

	-- dialog
	func = function(object)
		print(object.actionTarget.reactions.chat.chat)
	end,

	noReactionFunc = function(object)
		printDebug{"Nothing to chat with", "MapObject"}
	end 
}


-- move target away from self
MapObject.Action.push = 
{
	name = "push",
	failMessage = "Cannot push ",

	func = function(object)
		object.actionTarget.direction = object.direction
		object.actionTarget:UseAction("walk")
	end 	
}

MapObject.Action.pushWalk = 
{
	name = "pushWalk",
	failMessage = "Cannot pushWalk ",
	requireReaction = false,
	--otherRequiredReactions = {"push"},

	func = function(object)
		object:UseAction("push")
		object:UseAction("walk")
	end 	
}

MapObject.Action.pushLine = 
{
	name = "pushLine",
	failMessage = "Cannot pushLine ",
	requireAction = false,

	func = function(object)
		-- not sure how I will accomplish this yet
		-->FIX
	end 

}

MapObject.Action.pull = 
{	
	name = "pull",
	failMessage = "Cannot pull",
	requireReaction = false,

	func = function(object)
		--print("pull")
		local oldPos = {x = object.x, y = object.y}
		--print("x:" .. oldPos.x .. " y:" .. oldPos.y)
		object:UseAction("walk")
		object.actions.push.targetAbsPos = {x = oldPos.x - object.direction.x, y = oldPos.y - object.direction.y}
		object:UseAction("push")
		object.actions.push.targetAbsPos = nil
	end 
}


-- has some bugs, need to figure them out
MapObject.Action.jumpOver =
{
	name = "jumpOver",
	failMessage = "Cannot jump over ",
	requireReaction = false,

	func = function(object)

		-- find landing space
		local landTarget = object.mapWorld:Get(object.actionTarget.x + object.direction.x, object.actionTarget.y + object.direction.y)

		-- does landTarget exist? if not its probly outside the map
		if(landTarget == nil) then
			printDebug{"No landTarget for jump over", "MapObject", 2}
			return false
		end 

		-- will self land in walkable space?
		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		-- change pos with landing space
		object.mapWorld.map:Swap
		{
			a = {x = object.x, y = object.y},
			b = {x = object.actionTarget.x + object.direction.x, y = object.actionTarget.y + object.direction.y}
		}

		-- update pos values of self
		object.x = object.actionTarget.x + object.direction.x
		object.y = object.actionTarget.y + object.direction.y
	
	end 
}

-- remove target from the map
-- for now, fill space with default empty
MapObject.Action.kill =
{
	name = "kill",
	failMessage = "Could not Kill: ",
	func = function(object)
		object.mapWorld.map:Remove{x = object.actionTarget.x, y = object.actionTarget.y}
		return true
	end 
}


-- kills target and moves to the space it occupied
MapObject.Action.replace = 
{
	name = "replace",
	failMessage = "Cannot Replace: ",
	
	func = function(object)

		-- this funcition is unfinished
		-->FIX
	end 

}


-- move this object to a specific pos in the map
MapObject.Action.jumpTo =
{
	name = "jumpTo",
	failMessage = "Cannot Jump To: ",
	requireReaction = false,
	x = 6,
	y = 6,

	func = function(object)

		--print(object.actions[object.selectedAction].x)

		if(object.actions[object.selectedAction].x == object.x and object.actions[object.selectedAction].y == object.y) then
			printDebug{"Object in same position as jump to position", "MapObject"}
			return false			
		end

		-- is pos to jump to inside map?
		if(object.mapWorld.map:IsPosInBounds{x = object.actions[object.selectedAction].x, y = object.actions[object.selectedAction].x} == false) then
			printDebug{"Jump to positon is out of bounds", "MapObject"}
			return false	
		end 

		local landTarget = object.mapWorld:Get(object.actions[object.selectedAction].x, object.actions[object.selectedAction].y)

		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		local success = object.mapWorld.map:MoveTo
		{
			a = {x = object.x, y = object.y},
			b = {x = object.actions[object.selectedAction].x, y =  object.actions[object.selectedAction].y} --{x = object.direction.x, y = object.direction.y}
		}
		
		if(success == false) then
			printDebug{"jump fail", "MapObject", 2}
			return false
		end

		-- update position
		object.x = object.actions[object.selectedAction].x
		object.y = object.actions[object.selectedAction].y

		printDebug{"jump success", "MapObject", 2}

		return true
	end 	
}


-- move this object from its relative pos in the map to another pos
-- this probly doesnt need to be its own action type
MapObject.Action.jumpToFromHere =
{
	name = "jumpToFromHere",
	failMessage = "Could not jump from here to ",
	requireReaction = false,
	x = 1,
	y = 1,

	func = function(object)
	

		local x = object.x + object.actions[object.selectedAction].x
		local y = object.y + object.actions[object.selectedAction].y
		

		-- already in same pos?
		if(object.x == x and object.y == y) then
			printDebug{"JumpFromHereTo pos is same as pos", "MapObject"}
			return false
		end 

		-- is pos to jump to inside map?
		if(object.mapWorld.map:IsPosInBounds{x = x, y = y} == false) then
			printDebug{"Jump to positon is out of bounds", "MapObject"}
			return false	
		end 

		local landTarget = object.mapWorld:Get(x, y)
		
		if(landTarget.ReactionAble and landTarget:ReactionAble("walk") == false) then
			printDebug{"Cannot land on top of " .. (landTarget.name or "nothing"), "MapObject"}
			return false
		end 

		local success = object.mapWorld.map:MoveTo
		{
			a = {x = object.x, y = object.y},
			b = {x = x, y = y}
		}

		if(seuccess == false) then
			printDebug{"JumpToFromHere failed","MapObject"}
			return
		end 

		object.x = object.x + object.actions[object.selectedAction].x
		object.y = object.y + object.actions[object.selectedAction].y


		return true

	end 



}

-- Notes
-----------------------------------------------
-- require list for other reactions that an action requires target object
-- to have reactions for


-- need to figure out a way to select multiple actions and run them all in one use
-- this is useful for things like push+walk

-- need alternate fail actions
-- if cant walk but object is pushable then push, etc

-- these actions can be given to map objects
-- each is created new from these tables as templates
-- this makes it so that each action can be have unique vars if need be\



-- Action Ideas
-- scare, lift, flip, bounce, shoot, burn, heal, 

-- pushLine - push object and any objects in its way
-- pull - object follows you 1 space if you walk away from it
-- grab - bump object, then anywhere you move it follows but on the same side it was grabbed from
				-- simulates holding box effect
-- pullLine - pull object and any objects alined with it
-- take - put object into inventory of this object

