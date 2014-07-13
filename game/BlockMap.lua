-- Block Map
-- keeps track of all blocks in game
-- pos, type, who owns them, etc


local BlockMap = {}


BlockMap.blocks = {}



-- needs to be a two dimensional table
function BlockMap:Add(block)
	self.blocks[#self.blocks + 1] = block
end 







return BlockMap