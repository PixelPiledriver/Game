-- Block Map
-- keeps track of all blocks in game
-- pos, type, who owns them, etc

local ObjectUpdater = require("ObjectUpdater")

local BlockMap = {}


--------------
-- Vars
----------------

-- object
BlockMap.name = "BlockMap"
BlockMap.oType = "Static"
BlockMap.dataType = "Map"

BlockMap.blocks = { {} }
BlockMap.blockSize = 32

-- needs to be a two dimensional table
function BlockMap:Add(data)

	local x = data.x / self.blockSize
	local y = data.y / self.blockSize

	if(self.blocks[y] == nil) then
		self.blocks[y] = {}
	end

	self.blocks[y][x] = data.block

end 

function BlockMap:Remove(data)
	self.blocks[data.y][data.x] = nil
end 

-- check to see if there is no block in this space
function BlockMap:SpaceEmpty(data)
	local x = data.x / self.blockSize
	local y = data.y / self.blockSize

	--print("X:" .. x)
	--print("Y:" .. y)
	if(self.blocks[y] == nil or self.blocks[y][x] == nil) then
		return true
	end 

	return false

end 


ObjectUpdater:AddStatic(BlockMap)

return BlockMap