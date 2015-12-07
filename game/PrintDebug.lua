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



-- name of this needs to be change to printList
local printList = {}

-- switches
printList.stuff = {false, false}
printList.mathTest = {false, false}
printList.animation = {false, false}
printList.Health = {false, false}
printList.Collision = {false, false}
printList.Collision2 = {false, false}
printList.Collision3 = {false, false}
printList.CollisionList = {false, false}
printList.CollisionManager = {false, false}
printList.Build = {false, false}
printList.Controller = {false, false}
printList.MapTable = {false, false}
printList.Mouse = {true, false}
printList.MapObject = {true, false}
printList.ChatBox = {true, false}
printList.Links = {false, false}
printList.ObjectUpdater = {false, false}
printList.Fail = {true, false}
printList.LevelManager = {true, false}



--------------
-- Functions
--------------

-- alternative print with global switches
-- {"message", "typeName"}
function printDebug(data)
	
	local priority = data[3] or 1

	if(printList[data[2]][priority]) then
		print(data[1])
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