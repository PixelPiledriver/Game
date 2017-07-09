-- Level.lua

-- Purpose
--------------------------------
-- level files will not be handled in the same way
-- as other object types
-- you must create a level object at the bottom of
-- a level file, and then append all of the functions
-- 

-- global
Level = {}

-------------------
-- Static Info
-------------------
Level.Info = Info:New
{
	objectType = "Level",
	dataType = "Game",
	structureType = "Static"
}

-------------
-- Object
-------------
function Level:New(data)
	local o = {}

	-----------
	-- Fails
	-----------
	if(data.Start == nil or data.Update == nil or data.Restart == nil or data.Exit == nil) then
		printDebug{"Fail: Level requires all functions defined", "Fail"}
		return
	end 

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Level",
		dataType = "Game",
		structureType = "Object"
	}

	-----------
	-- Vars
	-----------

	-- eg: swamp.lua
	o.filename = data.filename or "unknown level" 
	
	-- eg: Wet Willie's Swampy Swamp or Swamp Romp
	o.properName = data.properName or "Unknown Level" 

	-- level function holders
	o.Start = data.Start
	o.Update = data.Update
	o.Restart = data.Restart
	o.Exit = data.Exit -- need a default Exit
	o.PostUpdate = data.PostUpdate or nil

	-- list of every object made while this level was running
	-- have ObjectManager add to this list via LevelManager.currentLevel
	-- not sure if this is used anymore
	o.objects = {}

	o.description = data.description or "..."


	-- Functions
	

	----------
	-- End
	----------

	return o
end 


ObjectManager:AddStatic(o)





-- Notes
-----------------------------
-- levels can also be thought of as games
-- will be renamed later to fit the scale and purpose
-- of future component structure
-- :P

-- come up with a creative solution for save and load
-- levels in action, and keep all the changes on next load
-- will need to ask ObjectManager for some help
