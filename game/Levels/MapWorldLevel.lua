-- MapWorldLevel.lua


-- Purpose
-------------------------------
-- test MapWorld code


-------------
-- Requires
--------------
local MapWorld = require("MapWorld")
local MapObject = require("MapObject")


------------------------------------------------------------

local MapWorldLevel = {}


------------------------
-- Static Functions
------------------------

local Earth = MapWorld:New
{
	size =
	{
		width = 10,
		height = 10
	}	
}

MapObject.currentMapWorld = Earth

local orc = MapObject:New
{
	type = "orc",
	name = "Worf",
	actions = {"fart", "bite"},
	reactions = 
	{
		walk = {able = true, message = " walks past Worf."},
		chat = {able = true, chat = "Fuck off, I'm busy..."}
	},
	x = 5,
	y = 5
}

local human = MapObject:New
{
	type = "human",
	name = "Steve",
	actions = {"walk", "chat"},
	x = 2,
	y = 2,
	move = true
}

local tree = MapObject:New
{
	type = "plant",
	name = "tree",
	reactions = 
	{
		walk = {able = false, message = " bumps into the tree."},
		chat = {able = true, chat = "Hello, I am a tree"},
	},
	x = 6,
	y = 2
}


function MapWorldLevel:Load()

end 


function MapWorldLevel:Update()
end


function MapWorldLevel:Exit()
end 



----------
-- End 
----------
return MapWorldLevel



-- Notes
--------------------------------------------------
