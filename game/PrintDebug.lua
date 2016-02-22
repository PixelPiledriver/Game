-- PrintDebug.lua

-- Purpose
----------------------------

-- settings for console output
-- this will include debug print

-- switches for what to print or not
-- flip on and off anytime
-- add a new switch by adding a string index
-- printDebug.["Name"]

-- creates a new type of object to be enabled for PrintDebug


-------------------------------------------------------------
local PrintDebugType = {}

----------------
-- Static Info
----------------
PrintDebugType.Info = Info:New
{
	objectType = "PrintDebugType",
	dataType = "Debug",
	structureType = "Static"
}

-- Set which message types to print or not
-- ObjectName = {priority1, priority2, ...}
local printList = 
{
	mathTest = {false, false},
	Animation = {true, false},
	AnimationComponent = {true, false},
	AnimationEditor = {true, false},
	Build = {false, false},
	Button = {true, false},
	ChatBox = {true, false},
	Collision = {false, false},
	Collision2 = {false, false},
	Collision3 = {false, false},
	CollisionList = {false, false},
	CollisionManager = {false, false},
	Controller = {false, false},
	DrawLine = {true, false},
	Fail = {true, false},
	Health = {false, false},
	Line = {false, false},
	Links = {false, false},
	LevelManager = {true, false},
	MapObject = {true, false},
	MapTable = {false, false},
	Matrix = {true, false},
	MemoryManager = {true, false},
	Mouse = {false, false},
	ObjectManager = {false, false},
	stuff = {false, false},
	Text = {true, false},
	Textfile = {true, false}
}

-- switches
printList.mathTest = {false, false}
printList.Animation = {true, false}
printList.AnimationComponent = {true, false}
printList.AudioComponent = {true, false}
printList.Build = {false, false}
printList.ChatBox = {true, false}
printList.Collision = {false, false}
printList.Collision2 = {false, false}
printList.Collision3 = {false, false}
printList.CollisionList = {false, false}
printList.CollisionManager = {false, false}
printList.Controller = {false, false}
printList.Fail = {true, false}
printList.Health = {false, false}
printList.Links = {false, false}
printList.LevelManager = {true, false}
printList.MapTable = {false, false}
printList.Matrix = {true, false}
printList.Mouse = {false, false}
printList.MapObject = {true, false}
printList.ObjectManager = {false, false}
printList.stuff = {false, false}
printList.Textfile = {true, false}

--------------
-- Functions
--------------

-- alternative print with global switches
-- {"message", "typeName"}
function printDebug(data)
	
	local priority = data[3] or 1

	-- object type on list??
	if(printList[data[2]]) then

		-- then print it
		if(printList[data[2]][priority]) then
			print(data[1])
		end 

	-- not on list
	else
		print("printDebug fail: object type '" .. data[2] .. "' not found in printList")
	end 

end 






-------------------
-- Run on Require
-------------------

-- print to consoel?
local printAtRuntime = true

-- allows printing to console
if(printAtRuntime) then
	io.stdout:setvbuf("no")
end 



-- Notes
------------------------------------

-- should probly add global switches for love.graphic.print as well
-- will do that later

-- prints to console
-- thats what sets this apart from DebugText -> which prints to screen


-- To Do
-----------------------------------
-- priority levels for a call to this so one object can turn on/off groups of messages


-- junk
---------------------------
--[[

-- switches
printList["stuff"] = false
printList["mathTest"] = false
printList["animation"] = false
printList["Health"] = false
printList["Collision"] = false
printList["Collision2"] = false
printList["Collision3"] = false
printList["CollisionList"] = false
printList["CollisionManager"] = false
printList["Build"] = false
printList["Controller"] = false
printList["MapTable"] = false
printList["Mouse"] = false
printList["MapObject"] = true





-- object style
-- decided to not use this
-- might change my mind in the future :P

-----------
-- Object
-----------

function PrintDebugType:New(name)

	--.active = true
	--.priority1 = true
	--.priority2 = true
	--.priority3 = true

	-- add to printList

end 



--]]