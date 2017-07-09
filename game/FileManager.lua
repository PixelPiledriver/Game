-- FileManager.lua

-- Purpose
-------------------------------------
-- handles file io stuff




-------------------------------------------
-- global
FileManager = {}

-------------------
-- Info
-------------------
FileManager.Info = Info:New
{
    objectType = "FileManager",
    dataType = "IO",
    structureType = "Manager"
}


--------------------
-- Vars
--------------------
FileManager.sourceActive = false

------------------
-- Directories
------------------
FileManager.dir = {}
FileManager.dir.appData = love.filesystem.getAppdataDirectory()
FileManager.dir.sourceBase = love.filesystem.getSourceBaseDirectory()
FileManager.dir.working = love.filesystem.getWorkingDirectory()
FileManager.dir.user = love.filesystem.getUserDirectory()
FileManager.dir.save = love.filesystem.getSaveDirectory()
FileManager.dir.defaultSave = love.filesystem.getSaveDirectory()
FileManager.dir.identity = love.filesystem.getIdentity() --> name only, no path


-- Functions
function FileManager:DoFile(filename)
	
	printDebug{dofile(FileManager.dir.save .. [[/]] .. filename), "FileManager"}

end

function FileManager:LoadFile(filename)
	return loadfile(FileManager.dir.save .. [[/]] .. filename)
end 



function FileManager:PrintDirectoryItems(folderName)

	local filenames = love.filesystem.getDirectoryItems(folderName)

	for i=1, #filenames do
		printDebug{filenames[i], "FileManager"}
	end

end 


-- redefine directory set functions
local ffi = require("ffi")
ffi.cdef[[ int PHYSFS_mount(const char *newDir, const char *mountPoint, int appendToPath); ]]; 
ffi.cdef[[ int PHYSFS_setWriteDir(const char *newDir); ]]
local liblove = ffi.os == "Windows" and ffi.load("love") or ffi.C


-- run this to read files in folder that contains .love file
-- this is for user assets placed outside love file 
-- makes it easy for 
function FileManager:SaveInSource()
	liblove.PHYSFS_setWriteDir(FileManager.dir.sourceBase)
	liblove.PHYSFS_mount(FileManager.dir.sourceBase, nil, 0)
end

-- set save dir back to AppData/game
function FileManager:SaveInDefault()
	liblove.PHYSFS_setWriteDir(FileManager.dir.defaultSave)
	liblove.PHYSFS_mount(FileManager.dir.defaultSave, nil, 0)
end 

FileManager:SaveInSource()
FileManager:PrintDirectoryItems("")



-- folder game is in


printDebug{"fused: ".. Bool:ToString(love.filesystem.isFused), "FileManager"}








--love.filesystem.getRealDirectory()) --> This can be used to determine whether a file is inside the save directory or the game's source .love.

printDebug{love.filesystem.getIdentity(), "FileManager"}
--love.filesystem.setIdentity("MonsterGame")











-- Notes
----------------------------------------------------


---------------------------------------
-- Love filesystem get explanations
---------------------------------------
--[[
print("Identity: " .. love.filesystem.getIdentity()) -->  current save folder name - no path
print("Save: " .. love.filesystem.getSaveDirectory()) --> current save full path
print("User: " .. love.filesystem.getUserDirectory()) --> user dir full path
print("AppData: " .. love.filesystem.getAppdataDirectory()) --> user AppData Roaming full path
print("Working: " .. love.filesystem.getWorkingDirectory()) --> path of main, I think
print("SourceBase: " .. love.filesystem.getSourceBaseDirectory()) --> path of exe or .love file where game was run from --> this is one folder above main.lua when game is played from code
--]]


-- Junk
------------------------------------------------------------
--[==[






printDebug{"Save: " .. FileManager.dir.save, "FileManager"}




-----------------------------------
-- Change Save to non app data
-----------------------------------

-- changes where love will save files in a sneaky way
-- I'm a little afraid to try this
-- not sure if it will be permanent or not
-- So I won't use this for now
function FileManager:SetWriteDirectory()

	local ffi = require("ffi")
   
	ffi.cdef[[ int PHYSFS_mount(const char *newDir, const char *mountPoint, int appendToPath); ]]; 
	ffi.cdef[[ int PHYSFS_setWriteDir(const char *newDir); ]]

	local liblove = ffi.os == "Windows" and ffi.load("love") or ffi.C

	-- This grabs your source folder, but you can point it anywhere, 
	-- Look at love.filesystem to see what you can call so that you can keep it multiplatform. 
	local docsdir = love.filesystem.getSourceBaseDirectory()

	liblove.PHYSFS_setWriteDir(docsdir)
	liblove.PHYSFS_mount(docsdir, nil, 0)

end





-- THIS DOESNT WORK
-- written from the example on love docs
-- fails every time
-- enables loading files from the folder that the game folder or love file is in
function FileManager:EnableSourceFolder()
	if(love.filesystem.isFused) then 
		print("Identity: " .. love.filesystem.getIdentity())



		print("SourceBase: " .. love.filesystem.getSourceBaseDirectory())

		local dir = love.filesystem.getSourceBaseDirectory()
		print("Source: " .. dir)
    local success = love.filesystem.mount(dir, "coolgame")
		print("source active:" .. Bool:ToString(success))

		if(success) then
			--love.window.showMessageBox("Good News!", "Source folder loading works on this computer. :)", {"Cool!"})
		end

	else
		printDebug{"cannot use source folder as", "FileManager"}
		love.window.showMessageBox("Oh Shit!", "Source folder loading not supported on this computer. :(", {"That sucks!"})
	end 
end 

--]==]