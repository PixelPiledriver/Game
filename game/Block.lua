-- Blocks that the player builds



local ObjectUpdater = require("ObjectUpdater")

local Block = {}


-------------
-- Create
-------------
function Block:New(data)

	local object = {}

	object.x = data.x
	object.y = data.y
	object.frame = data.frame
	object.color = {255,255,255,255}



	-- functions



	function object:Draw()
		self.frame:Draw(self)
	end 

	function object:Update()

	end 



	ObjectUpdater:Add{object}

	return object

end 







return Block





-------------
-- Notes
-------------
-- player can enter blocks of their color
-- move between blocks by pressing a direction and A
-- jumps to next block like startroptics
-- press towards an exit and press A to leave a block
-- press towards and ext and press X to shoot out
-- blocks can be destroyed by other players













