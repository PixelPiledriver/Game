-- MapObject_Objects.lua

-- Purpose
-------------------------------------
-- library of MapObject templates
-- rock, tree, human, etc

----------------
-- Requires
----------------
local MapObject = require("MapObject")
local Name = require("Name")

----------------------------------------------------------
MapObject.Objects = {}

---------------------
-- Objects
---------------------

MapObject.Objects.tree =
{
	type = "plant",
	name = "tree",
	reactions = 
	{
		walk = {able = false, message = " bumps into the tree"},
		chat = {able = true, chat = "The leaves on the tree rustle softly, as if whispering..."},
		chop = {able = true, chat = "The mighty cannot handle the chopping action"}
	},
	x = 0,
	y = 0,
	sprite = "tree",
	animation = "tree"
}

MapObject.Objects.pond =
{
	type = "water",
	name = "pond",
	reactions = 
	{
		walk = {able = false, message = " can't swim."},
		chat = {able = true, chat = "You speak to your reflection in the pond..."},
	},
	x = 0,
	y = 0,
	sprite = "pond"
}

MapObject.Objects.rock =
{
	type = "rock",
	name = "rock",
	actions =
	{
		walk = MapObject.Action:Get("walk"),
		index = "walk"
	},
	reactions = 
	{
		walk = {able = false, message = " finds it unsafe to get on top of."},
		chat = {able = true, chat = "The rock has nothing to say..."},
		push = {able = true}
	},
	x = 0,
	y = 0,
	sprite = "rock"
}

MapObject.Objects.orc =
{
	type = "orc",
	randomNameGet = Name.GetIndex.Monster,
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
	y = 5,
	sprite = "orc",
	animation = "orc"
}



-----------------
-- Index
-----------------
MapObject.Objects.index =
{
	"tree",
	"pond",
	"rock",
	"orc",
}


-- Notes
---------------------------------------------------
-- made in new file in sub component format
-- this is to help keep complex object types file clean
-- make a standard practice in other parts of the engine as well



