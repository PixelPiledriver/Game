-- Block Map.lua
-->OLD


-- Purpose
----------------------------
-- keeps track of all blocks in game
-- pos, type, who owns them, etc

---------------------------------------------------------------------------

local BlockMap = {}

------------------
-- Static Info
------------------
BlockMap.name = "BlockMap"
BlockMap.oType = "Static"
BlockMap.dataType = "Map"


----------------
-- Static Vars
----------------
BlockMap.blocks = { {} }
BlockMap.blockSize = 32


---------------------
-- Static Functions
---------------------

-- add a block to the map
-- data = {x,y}
function BlockMap:Add(data)

	local x = data.x / self.blockSize
	local y = data.y / self.blockSize

	if(self.blocks[y] == nil) then
		self.blocks[y] = {}
	end

	self.blocks[y][x] = data.block

end 

-- remove block from map
-- data = {x,y}
function BlockMap:Remove(data)
	self.blocks[data.y][data.x] = nil
end 

-- is there a block in the given space?
-- data = {x,y}
function BlockMap:SpaceEmpty(data)

	local x = data.x / self.blockSize
	local y = data.y / self.blockSize

	if(self.blocks[y] == nil or self.blocks[y][x] == nil) then
		return true
	end 

	return false

end 


ObjectUpdater:AddStatic(BlockMap)

return BlockMap






-- Notes
---------------------------------------
-- this component acts only as a static and doesnt create BlockMaps
-- needs to be reworked

