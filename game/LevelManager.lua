-- LevelManager.lua

-- Purpose
-----------------------------------
-- Allows for different level files to be loaded in


--------------
-- Requires
--------------
--local Text = require("Text")
local Window = nil
--------------------------------------

-- global
LevelManager = {}


----------
-- Vars
----------

LevelManager.currentLevel = nil
LevelManager.destroyObjectsOnExit = true


--------------
-- Levels
--------------

-- all levels available
LevelManager.levelNames = 
{
	"MapWorldLevel",
	"NewLevelTypeTest",
}

LevelManager.defaultLevel = LevelManager.levelNames[1]
LevelManager.loadLevelAtStart = false

-- level data table
LevelManager.levels = {}

---------------
-- Functions
---------------

-- set the given level and run it 
function LevelManager:StartLevel(level)

	-- fails 
	if(level == nil) then
		printDebug{"No level", "LevelManager"}
		return
	end 

	if(self.currentLevel) then
		printDebug{"A level has already been loaded", "LevelManager"}
		return		
	end 

	-- set object owner to this level
	-- this marks objects created while this level is running
	-- so that they can be destroyed later on exit
	ObjectUpdater.newObjectsOwnedBy = level.filename

	-- set level and load it
	self.currentLevel = level
	self.currentLevel:Start()

	--EventLog:Add{"Start level", "LevelManager"}
	printDebug{"Start level", "LevelManager"}


	

end 

function LevelManager:UpdateLevel()
	if(self.currentLevel == nil) then
		printDebug{"No level", "LevelManager", 2}
		return
	end 

	self.currentLevel:Update()
end 

function LevelManager:RestartLevel()
	self:ExitLevel()
	self:StartLevel()

	--EventLog:Add{"Restart level", "LevelManager"}
	printDebug{"Restart level", "LevelManager"}
end 

function LevelManager:ExitLevel()

	if(self.currentLevel == nil) then
		printDebug{"No level", "LevelManager", 2}
		return
	end 

	ObjectUpdater:DestroyAllObjectsOwnedBy(self.currentLevel.filename)

	self.currentLevel:Exit()
	self.currentLevel = nil

	--EventLog:Add{"Exit level", "LevelManager"}
	printDebug{"Exit level", "LevelManager"}


end 


function LevelManager:Setup()

	if(self.loadLevelAtStart == false) then
		printDebug{"Don't load level on startup", "LevelManager"}
		return
	end 

	self:StartLevel(self.levels[self.defaultLevel])
end 

function LevelManager:StartDefaultLevel()
	self:StartLevel(self.levels[self.defaultLevel])
end 

function LevelManager:PostRequire()

	----------------
	-- Levels
	----------------

	-- get all levels
	for i=1, #LevelManager.levelNames do
		LevelManager.levels[LevelManager.levelNames[i]] = require("levels/" .. LevelManager.levelNames[i])
	end 

	-------------------
	-- Static Info
	-------------------
	LevelManager.Info = Info:New
	{
		objectType = "LevelManager",
		dataType = "Game",
		structureType = "Manager"
	}


	ObjectUpdater:AddStatic(LevelManager)

	-- other
	Window = require("Window")

end 





-- Notes
-------------------------------
-- when ObjectUpdater has destroys
-- sweep currentLevel.objects for objects marked to destroy
-- remove from the table and create a new table without them
-- thats my best guess for right now
-- try coding this when I'm not so tired
-- bleh

-- this has a very serious bug still trying to figure it out
-- if an object is destroyed by another means before level destroys it
-- then it FUCKS EVERYTHING THE SHIT UP
-- gotta figure out a way to fix this shit
-- the table def gets fractured somehow in memory and screws it all up
-- FIX THIS GARBAGE

-- NEEDED
-- default level to load
-- level choice menu
-- load a selected level
-- create a new level at runtime
-- save whats in level at runtime
-- restart current level


-->DONE
-- you should not be able to load a level after already loading it

-->DONE
-- add a list of all level names
-- so they can be switched between at runtime

-- this should be changed to Scene
-- or someother better name
-- Level is too close to gameplay in meaning

-- build a load level ui on top of this
-- levels should really be called "games" or carts" or something
-- but this is fine for now I  guess







-- Junk
---------------------------------
--[[


	-- create table for objects if it doesnt exist
	if(self.currentLevel.objects == nil) then
		self.currentLevel.objects = {}
	end 



-- objects created within a level are listed to that level
-- so they can be destroyed on Exit
-- BROKEN
-- this will be removed
function LevelManager:ObjectCreatedByLevel(object)

	if(self.currentLevel == nil) then
		printDebug{"No current level", "LevelManager", 2}
		return
	end 

	if(self.currentLevel.objects[1] == nil) then
		--self.currentLevel.objects = nil
		--self.currentLevel.objects = {}
	end 

	-- add object
	self.currentLevel.objects[#self.currentLevel.objects+1] = object

end 


	-- delete all objects made within this level
	-- this is bugged somehow, but not sure what to make of it yet
	-->FIX
	-- fix: gonna remove this and give objects a .ownedBy var
	-- to track what should be destroyed on exit
	if(self.destroyObjectsOnExit) then
		print(#self.currentLevel.objects .. " objects BEFORE destroy list")
		for i=1, #self.currentLevel.objects do
			
			-- need to figure out this bug
			--print(self.currentLevel.objects[i].Info.objectType)
			
	 		ObjectUpdater:Destroy(self.currentLevel.objects[i])
	 		

	 	end 
	 	print(#self.currentLevel.objects .. " objects AFTER destroy list")

	 	for i=1, #self.currentLevel.objects do
	 		print(i .. self.currentLevel.objects[i].Info.objectType)
	 	end 
	end

	

	self.currentLevel.objects = nil
	self.currentLevel.objects = {}

	print(#self.currentLevel.objects)




--]]