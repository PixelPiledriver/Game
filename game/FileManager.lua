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

------------------
-- Directories
------------------
FileManager.directories = {}
FileManager.directories.appData = love.filesystem.getAppdataDirectory()
FileManager.directories.sourceBase = love.filesystem.getSourceBaseDirectory()
FileManager.directories.working = love.filesystem.getWorkingDirectory()
FileManager.directories.user = love.filesystem.getUserDirectory()
FileManager.directories.save = love.filesystem.getSaveDirectory()
FileManager.directories.identity = love.filesystem.getIdentity() --> name only, no path


-- Functions
function FileManager:DoFile(filename)
	
	print(dofile(FileManager.directories.save .. [[/]] .. filename))

end

function FileManager:LoadFile(filename)
	return loadfile(FileManager.directories.save .. [[/]] .. filename)
end 



function FileManager:PrintDirectoryItems(folderName)

	local filenames = love.filesystem.getDirectoryItems(folderName)

	for i=1, #filenames do
	print(filenames[i])
	end

end 

--FileManager:PrintDirectoryItems()
print(FileManager.directories.save)







--love.filesystem.getRealDirectory()) --> This can be used to determine whether a file is inside the save directory or the game's source .love.

print(love.filesystem.getIdentity())
--love.filesystem.setIdentity("MonsterGame")
print(love.filesystem.getIdentity())










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

--]==]