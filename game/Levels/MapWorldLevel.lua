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
		width = 12,
		height = 12
	}	
}

MapObject.currentMapWorld = Earth

local orc = MapObject:New
{
	type = "orc",
	name = "Worf",
	actions = {"walk", "fart", "bite"},
	reactions = 
	{
		walk = {able = true, message = " walks past Worf."},
		chat = {able = true, chat = "Fuck off, I'm busy..."},
		push = {able = true}
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

local human = MapObject:New
{
	type = "human",
	name = "Steve",
	actions = {"walk", "chat", "push"},
	reactions =
	{
		chat = {able = true, chat = "Yo, I'm Steve"}
	},
	x = 2,
	y = 2,
	active = false,
	playerControlled = true
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
	x = 4,
	y = 4	
}

MapObject:Create
{
	name = "tree",
	x = 6,
	y = 2
}


MapObject:CreateRandom
{
	name = "tree",
	count = 0
}

MapObject:CreateRandom
{
	name = "pond",
	count = 0
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
