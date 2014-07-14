-- Blocks that the player builds



local ObjectUpdater = require("ObjectUpdater")
local Collision = require("Collision")
local BlockMap = require("BlockMap")
local Camera = require("Camera")

local Block = {}


-------------
-- Create
-------------
function Block:New(data)

	local object = {}

	object.x = data.x
	object.y = data.y
	object.xIndex = data.xIndex
	object.yIndex = data.yIndex
	print("New block xIndex:" .. object.xIndex)
	print("New block yIndex:" .. object.yIndex)
	object.frame = data.frame
	object.color = {255,255,255,255}

	object.buildTime = data.buildTime or 100
	object.completion = 0
	object.health = 100
	object.collisionList = data.collisionList or nil
	object.type = "block"

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

	function object:Draw()
		self.frame:Draw(self)
	end 

	function object:Build()
		if(self.completion < self.buildTime) then
			self.completion = self.completion + 1
		end 
	end

	function object:Damage(data)
		self.health = self.health - data.other.parent.damage

		if(self.health <= 0) then
			ObjectUpdater:Destroy(self)
		end 

	end 

	function object:OnCollision(data)
		
		-- is object of bullet type?
		if(self.collisionList[data.other.name] == "bullet") then
			self:Damage(data)
		end 

	end 


	function object:Destroy()
		BlockMap:Remove{x = self.xIndex, y = self.yIndex}
		Camera:AddShake{x = 5, y= 5}
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













