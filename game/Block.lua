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
---------------------
Block.name = "Block"
Block.oType = "Static"
Block.DataType = "GameObject Constructor"


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
	object.name = data.name or "..."
	object.oType = "Block"
	object.dataType = "GameObject"

	----------------
	-- Vars
	----------------
	object.x = data.x
	object.y = data.y
	object.xIndex = data.xIndex
	object.yIndex = data.yIndex

	printDebug{"New block xIndex:" .. object.xIndex, "Build"}
	printDebug{"New block yIndex:" .. object.yIndex, "Build"}
	
	object.frame = data.frame
	object.color = {255,255,255,255}

	object.buildTime = data.buildTime or 100
	object.completion = 0
	object.collisionList = data.collisionList or nil
	
	object.health = Health:New{}

	---------------
	-- Collision
	---------------
	object.collision = Collision:New
	{
		name = data.builder.playerColor .. "Block",
		parent = object,
		width = object.frame.width,
		height = object.frame.height,
		collisionList = object.collisionList or nil
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


	ObjectUpdater:Add{object}

	return object

end 



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














