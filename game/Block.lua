-- Block.lua 
-->OLD 



-- Purpose
--------------------------------------------------
-- blocks that players can build 

------------------
-- Requires
------------------
local Collision = require("Collision")
local BlockMap = require("BlockMap")
local Camera = require("Camera")
local Health = require("Health")


---------------------------------------------------------------------------

local Block = {}

---------------------
-- Static Info
---------------------s
Block.Info = Info:New
{
	objectType = "Block",
	dataType = "Game",
	structureType = "Static"
}


---------------------
-- Static Functions
---------------------

-- create a Block
-- data = {x, y, frame, buildtime, collisionList, builder}
function Block:New(data)

	local object = {}

	------------------
	-- Object Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Block",
		dataType = "Game",
		structureType = "Object"
	}

	----------------
	-- Vars
	----------------
	o.x = data.x
	o.y = data.y
	o.xIndex = data.xIndex
	o.yIndex = data.yIndex

	printDebug{"New block xIndex:" .. o.xIndex, "Build"}
	printDebug{"New block yIndex:" .. o.yIndex, "Build"}
	
	o.frame = data.frame
	o.color = {255,255,255,255}

	o.buildTime = data.buildTime or 100
	o.completion = 0
	o.collisionList = data.collisionList or nil
	
	o.health = Health:New{}

	---------------
	-- Collision
	---------------
	o.collision = Collision:New
	{
		name = data.builder.playerColor .. "Block",
		parent = object,
		width = o.frame.width,
		height = o.frame.height,
		collisionList = o.collisionList or nil
	}

	---------------
	-- Functions
	---------------

	-- render this block to screen --> needs to be updated to DRAW -->OLD -->FIX
	function object:Draw()
		self.frame:Draw(self)
	end 

	-->???
	function object:Build()
		if(self.completion < self.buildTime) then
			self.completion = self.completion + 1
		end 
	end

	-- deal damage to this block
	-- data = sent from self:OnCollision()
	function object:Damage(data)
		self.health = self.health - data.other.parent.damage

		if(self.health <= 0) then
			ObjectUpdater:Destroy(self)
		end 

	end 

	-- something is touching this block
	-- data = sent from CollisionManager
	function object:OnCollision(data)
		
		-- is object of bullet type?
		if(data.other.parent.type == "bullet") then
			self.health:Damage(data.other.parent)
		end 

	end 

	-- destroy this block
	function object:Destroy()
		BlockMap:Remove{x = self.xIndex, y = self.yIndex}
		Camera:AddShake{x = 5, y= 5}

		ObjectUpdater:Destroy(self.Info)
		ObjectUpdater:Destroy(self.health)
		ObjectUpdater:Destroy(self.collision)
	end 

	-->???
	function object:CheckStatus()
	end


	function object:Update()
		self:CheckStatus()
	end 


	-- info about this block
	function object:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Block"},
			{text = "Block"},
			{text = "----------"},
			{text = "HP: " .. self.health.hp}
		}
	end 


	----------
	-- End
	----------


	ObjectUpdater:Add{object}

	return object

end 


---------------
-- Static End
---------------

ObjectUpdater:AddStatic(Block)

return Block





-- Notes
---------------------------------------
-- player can enter blocks of their color
-- move between blocks by pressing a direction and A
-- jumps to next block like startroptics
-- press towards an exit and press A to leave a block
-- press towards and ext and press X to shoot out
-- blocks can be destroyed by other players

-- this is very old, game specific code
-- needs to be looked at see if any of it is still useful
-- it may not be














