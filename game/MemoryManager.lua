-- MemoryManager.lua
-->WORKING

-- Purpose
-------------------------
-- handles memory usage and cleanup

----------------------------------------------------------------------------------------

-- initial memory usage
-- taken up by LÖVE
local initialMemory = collectgarbage("count")
print(initialMemory)

-- global
MemoryManager = {}

----------------
-- StaticInfo
----------------
-- cant be added until after Info static has been loaded
-- needs to be added from the outside, find a place to do that

---------------------
-- Static Variables
---------------------
MemoryManager.inUse = nil
MemoryManager.initialMemory = initialMemory
MemoryManager.zeroLevel = nil

---------------------
-- Static Functions
---------------------

function MemoryManager:Count()
	MemoryManager.inUse = collectgarbage("count") - MemoryManager.initialMemory
end 

MemoryManager:Count()
MemoryManager.zeroLevel = MemoryManager.inUse

print("MemoryInUse: " .. MemoryManager.inUse)




-- Notes
----------------------------
-- the initial memory is subtracted from the count given by garbage collection
-- this gives a unit estimate of the data I've created 
-- as it factors out the data created by LÖVE
