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



-- name of this needs to be change to printList
local printDebugSettings = {}

-- switches
printDebugSettings["stuff"] = false
printDebugSettings["mathTest"] = false
printDebugSettings["animation"] = false
printDebugSettings["Health"] = false
printDebugSettings["Collision"] = false
printDebugSettings["Collision2"] = false
printDebugSettings["Collision3"] = false
printDebugSettings["CollisionList"] = false
printDebugSettings["CollisionManager"] = false
printDebugSettings["Build"] = false
printDebugSettings["Controller"] = false
printDebugSettings["MapTable"] = true
printDebugSettings["Mouse"] = false
printDebugSettings["MapObject"] = true



--------------
-- Functions
--------------

-- alternative print with global switches
-- {"message", "typeName"}
function printDebug(data)
	
	if(printDebugSettings[data[2]]) then
		print(data[1])
	end 

end 






-------------------
-- Run on Require
-------------------

-- switch to print to console
local printAtRuntime = true

-- allows printing?
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