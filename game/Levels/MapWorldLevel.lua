-- MapWorldLevel.lua


-- Purpose
-------------------------------
-- test MapWorld code

-------------
-- Requires
--------------
local MapWorld = require("MapWorld")
local MapObject = require("MapObject")
require("MapObject_Sprites")
require("MapObject_Action")
require("MapObject_Objects")
local ChatBox = require("ChatBox")
local Polygon = require("Polygon")
local Name = require("Name")


------------------------------------------------------------


--------------------
-- Level Functions
--------------------

-- define a function for each action a level can take


local Start = function()

	local Earth = MapWorld:New
	{
		size =
		{
			width = 12,
			height = 12
		}	
	}

	MapObject.currentMapWorld = Earth


	local human = MapObject:New
	{
		type = "human",
		name = "Steve",
		actions = 
		{
			walk = MapObject.Action:Get("walk"),
			chat = MapObject.Action:Get("chat"),
			push = MapObject.Action:Get("push"),
			pushWalk = MapObject.Action:Get("pushWalk"),
			pull = MapObject.Action:Get("pull"),
			jumpOver = MapObject.Action:Get("jumpOver"),
			kill = MapObject.Action:Get("kill"),
			jumpTo = MapObject.Action:Get("jumpTo"),
			jumpToFromHere = MapObject.Action:Get("jumpToFromHere"),
			index = {"walk", "chat", "push", "pushWalk", "pull", "jumpOver", "kill", "jumpTo", "jumpToFromHere"}
		},
		reactions =
		{
			chat = {able = true, chat = "Yo, I'm Steve"}
		},
		x = 2,
		y = 2,
		active = false,
		playerControlled = true,
		sprite = "human",
		animations = 
		{
			{"walk", "humanWalk"}, -- {name to play animation by, name of animation var used by Get function}
			{"chat", "humanChat"},
			{"push", "humanPush"},
			{"idle", "humanIdle"}
		}
	}


	MapObject:Create
	{
		name = "rock",
		x = 3,
		y = 2	
	}

	MapObject:Create
	{
		name = "rock",
		x = 1,
		y = 1
	}

	MapObject:Create
	{
		name = "rock",
		x = 4,
		y = 4	
	}

	MapObject:Create
	{
		name = "tree",
		x = 6,
		y = 2
	}

	MapObject:Create
	{
		name = "orc",
		x = 8,
		y = 8
	}

	MapObject:Create
	{
		name = "orc",
		x = 10,
		y = 10
	}

	MapObject:Create
	{
		name = "tree",
		x = 10,
		y = 10
	}



	MapObject:CreateRandom
	{
		name = "tree",
		count = 4
	}

	MapObject:CreateRandom
	{
		name = "pond",
		count = 4
	}

	ChatBox:New
	{
		x = 150,
		y = 80,
		text = "Hello! Whats the fucking deal man? Why are you so cool!?!??"
		--text = "bing bang biggity boo what the fuck is the deal with you you got a big hat and a nice pair of pants but that fancy dress aint gonna help you dance yah herd word"
		--text = "this is a shit Stoooooooooorm"
		--text = "yo dood! :D"
	}

end


local Update = function()
end 

local Exit = function()
end 

local Restart = function()
end 


-- create level object 
-- add all functions needed to run
local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "MapWorldLevel"
}

return level










-- Junk
----------------------------
--[[


local orc = MapObject:New
{
	type = "orc",
	name = "Worf",
	actions = 
	{
		walk = MapObject.Action:Get("walk"),
		index = {"walk"}
	},
	reactions = 
	{
		walk = {able = true, message = " walks past Worf."},
		chat = {able = true, chat = "Fuck off, I'm busy..."},
		push = {able = true},
		kill = {able = true},
		index = {"walk", "chat", "push", "kill"}
	},
	active = false,
	direction = 
	{
		pattern = 
		{
			index = 1,
			steps = 
			{
				{x = 1, y = 0 },
				{x = -1, y = 0 },
			}
		},
	},
	x = 4,
	y = 5
}









local polygon = Polygon:New
{
	verts = 
	{
		{x = 0, y = 0},
		{x = 100, y = 0},
		{x = 200, y = 100},
	}		
}


--]]