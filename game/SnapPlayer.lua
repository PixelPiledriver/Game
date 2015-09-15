-- SnapPlayer.lua

-- 
-- basic object with sprite, input, etc

---------------
-- Requires
---------------

local Animation = require("Animation")
local Controller = require("Controller")
local Bullet = require("Bullet")
local Box = require("Box")
local Block = require("Block")
local Sprites = require("Sprites")
local Color = require("Color")
local PlayerSkins = require("PlayerSkins")
local Collision = require("Collision")
local CollisionLists = require("CollisionLists")
local Game = require("Game")
local BlockMap = require("BlockMap")
local Health = require("Health")
local Guns = require("Guns")
local Map = require("Map")
local SnapGrid = require("SnapGrid")
local Timer = require("Timer")

-------------------------------------------------------------
local SnapPlayer = {}

SnapPlayer.Info = Info:New
{
	objectType = "SnapPlayer",
	dataType = "Game Object",
	structureType = "Static"
}

------------
-- Object
------------

function SnapPlayer:New(data)

	local object = {}

	------------
	-- Info
	------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "SnapPlayer",
		dataType = "Game Object",
		structureType = "Object"
	}

	object.sprite = data.sprite or nil

	object.x = data.x or SnapGrid.x + SnapGrid.cellWidth -- This is a dumb hack. Currently necessary to allign SnapPlayer with SnapGrid 4sumrzn 
	object.y = data.y or SnapGrid.y
	object.z = 0

	object.gridX = data.gridX or 0
	object.gridY = data.gridY or 0
	
	object.gravity = 1

	object.yJump = 0
	object.jumpNow = false

	object.GridMovementTimer = Timer:New()

	object.width = data.width or 32
	object.height = data.height or 32
	object.color = data.color or {255,255,255,255}
	object.playerColor = data.playerColor or "red"

	object.speed = data.speed or 2
	object.walkSpeed = data.walkSpeed or 2
	object.dodgeSpeed = data.dodgeSpeed or 6

	object.direction = "none"
	object.xDirection = 1
	object.yDirection = 0

	object.frame = data.frame or nil
	object.animation = data.animation or nil

	object.angle = data.angle or 0
	object.xScale = data.xScale or 1
	object.yScale = data.yScale or 1
	object.xShootPos = data.xShootPos or 25
	object.yShootPos = data.yShootPos or 0
	object.shootDirection = data.shootDirection or 1

	object.xStick = 0
	object.yStick = 0
	
	object.name = data.name
	object.collisionList = CollisionLists[object.name]

	object.skin = data.skin
	object.type = "player"

	object.health =  Health:New{}

	object.mapX = 0
	object.mapY = 0

	-- weapon
	object.gun = Guns:Get("laserRifle")

	-- controls
	object.keys =
	{
		left = data.keys and data.keys.left or "a",
		right = data.keys and data.keys.right or "d",
		up = data.keys and data.keys.up or "w",
		down = data.keys and data.keys.down or "s",
		shoot = data.keys and data.keys.shoot or "q",
		build = data.keys and data.keys.build or "e",
		jump = data.keys and data.keys.jump or " "
	}


	-- controller setup
	object.useController = false
	if(Controller:Count() > 0) then
		object.controller = Controller:GetUnclaimedController()

		-- claimed a controller?
		if(object.controller) then 
			object.useController = true
		end 

	end

	-- shadow
	local shadowHeight = 6
	local shadowWidth = object.width - 12
	object.shadow = Box:New
	{
		x = object.x + 6,
		y = object.y + object.height - shadowHeight,
	 	width = shadowWidth,
	 	height = shadowHeight,
		color = {0,0,0,100},
		fill = true
	}



	---------------
	-- Collision
	---------------
	
	object.collision = Collision:New
	{
		width = 32,
		height = 32,
		shape = "rect",
		color = Color:Get(object.playerColor),
		name = object.name,
		parent = object,
		collisionList = object.collisionList.robot,
		visible = false
	}


	function object:OnCollision(data)
		
		-- Bullet
		if(data.other.parent.type == "bullet") then
			self.health:Damage(data.other.parent)
			self:ColorFlash()
		end 

	end 


	-------------
	-- Functions
	-------------

	function object:ColorFlash()
		self.color = Color:Get("red")
	end 

	function object:ColorUpdate()

		--self.color = {255,255,255}
		local colorSpeed = 20

		if(Color:Equal(self.color, Color:Get("white")) == false) then
			self.color = Color:Add
			{
				a = self.color, 
				b = {colorSpeed, colorSpeed, colorSpeed},
				loop = false
			}

		end 
		

	end 

	function object:PrintDebugText()
		
		DebugText:TextTable
		{
			{text = "", obj = "SnapPlayer" },
			{text = "X: " .. self.x},
			{text = "Y: " .. self.y},
			{text = "gridX: " .. self.gridX},
			{text = "gridY: " .. self.gridY}
		}
	end 

	-- function object:DoMapStuff()
	-- 	self.mapX = (( (self.x) - (self.x % Map.tileWidth)) / Map.tileWidth) + 1
	-- 	self.mapY = (( (self.y + self.height) - (self.y % Map.tileHeight)) / Map.tileHeight) + 1
	
	-- 	local tile = Map:ObjectInTile(self)
		
	-- 	if(tile) then 
	-- 		self.z = -tile.z
	-- 	end 		
	-- end 

	function object:JumpUpdate()

		if(self.jumpNow == false) then
			return
		end

		self.z = self.z + self.yJump

		if(self.z > 0 ) then
			self.yJump = self.yJump - self.gravity
		end

		if(self.z < 0 ) then
			self.z = 0
			self.yJump = 0
		end 
		
	end 

	function object:Shadow()
		self.shadow.x = self.x + 6
		self.shadow.y = self.y + self.height - self.shadow.height
		self.shadow.z = self.z
	end 

	function object:Update()
		--self:DoMapStuff()
		self:JumpUpdate()
		self:Shadow()
		self:ColorUpdate()
	end 

	function object:Draw()
		-- what type of graphic does the object have
		-- this is bullstuff and needs to be re worked
		if(self.frame) then
			self.skin.idle:Draw(self)
		elseif(self.animation) then
			self.animation:Draw(self)
		end 
	end 


	-------------
	-- Actions
	---------------

	-- Grid Movement
	function object:MoveLeft()
		if(self.gridX > 1) then
			self.gridX = self.gridX - 1
			self.x = self.x - SnapGrid.cellWidth
		end
	end 

	function object:MoveRight()
		if(self.gridX < SnapGrid.boardWidth) then
			self.gridX = self.gridX + 1
			self.x = self.x + SnapGrid.cellWidth
		end
	end 

	function object:MoveUp()
		if(self.gridY > 1) then
			self.gridY = self.gridY - 1
			self.y = self.y - SnapGrid.cellHeight
		end
	end 

	function object:MoveDown()
		if(self.gridY < SnapGrid.boardHeight) then
			self.gridY = self.gridY + 1
			self.y = self.y + SnapGrid.cellHeight
		end
	end 

	-- jump
	function object:Jump(j)
		if(self.z == 0) then
			self.yJump = 10
		end 
	end 

	-- used for 4 directional movement
	-- put in options for movement types
	-- need to get hud buttons for changing options at runtime
	function object:SetDirection(dir)

		object.direction = dir

		if(dir == "left") then
			self.xDirection = -1
			self.yDirection = 0
		end 

		if(dir == "right") then
			self.xDirection = 1
			self.yDirection = 0
		end

		if(dir == "up") then
			self.xDirection = 0
			self.yDirection = -1
		end 

		if(dir == "down") then
			self.xDirection = 0
			self.yDirection = 1
		end

	end 

	function object:Shoot()

		self.gun:Shoot(self)
	
	end 

	-- build blocks
	function object:Build()

		local x = self.x - (self.x % 32)
		local y = self.y - (self.y % 32)

		if(BlockMap:SpaceEmpty{x = x, y = y}) then

			printDebug{"Block built", "Build"}
			local block = Block:New
			{
				x = x + self.width/2,
				y = y + self.height/2,
				xIndex = x / BlockMap.blockSize,
				yIndex = y / BlockMap.blockSize,

				frame = self.skin.block,
				builder = self,
				collisionList = self.collisionList.block
			}

			BlockMap:Add{x = x, y = y, block = block}

		end 



	end 




	---------------
	-- Input
	---------------

	-- only used for press and release
	function object:Input(key)

		if(key == "d") then 
			--self:MoveRight()
		end

		if(key == "a") then
			--self:MoveLeft()
		end 

		if(key == self.keys.jump) then
			self:Jump(10)
		end 

	end 


	-- this is keyboard controls
	-- need to reorganize :P
	-- only used for isDown=pressed 
	-- not for button down or up
	function object:RepeatedInput()
		-- Grid Snap Movement		
		if(self.GridMovementTimer:TimeElapsedMs(100)) then			
			--If there is a tile to the immediate left of the player, allow them to mov
			if(love.keyboard.isDown(self.keys.left)) then
				self:MoveLeft()
				self:SetDirection("left")
				self.GridMovementTimer:ResetTimer()
			end

			if(love.keyboard.isDown(self.keys.right)) then
				self:MoveRight()
				self:SetDirection("right")
				self.GridMovementTimer:ResetTimer()
			end

			if(love.keyboard.isDown(self.keys.up)) then
				self:MoveUp()
				self:SetDirection("up")
				self.GridMovementTimer:ResetTimer()
			end

			if(love.keyboard.isDown(self.keys.down)) then
				self:MoveDown()
				self:SetDirection("down")
				self.GridMovementTimer:ResetTimer()
			end
		end


		if(love.keyboard.isDown(self.keys.jump)) then
			
		end

		if(love.keyboard.isDown(self.keys.shoot)) then
			self:Shoot()
		end 

		if(love.keyboard.isDown(self.keys.build)) then
			self:Build()
		end 

	end 


	-- xbox controller input
	object.controls = 
	{
		gamepad =
		{
			up = "up",
			down = "down",
			left = "left",
			right = "right",
			shoot = "X",
			build = "B",
			jump = "A",
			dodge = "RT",
			stop = "LT"
		}
	}

	function object:ControllerInput()

		if(self.useController == false) then
			return
		end 

		--------------
		-- D-Pad
		--------------
		-- up
		if(self.controller:ButtonDown(self.controls.gamepad.up)) then
			self:MoveUp()
		end 

		-- down
		if(self.controller:ButtonDown(self.controls.gamepad.down)) then
			self:MoveDown()
		end 

		-- left
		if(self.controller:ButtonDown(self.controls.gamepad.left)) then
			self:MoveLeft()
		end 

		-- right
		if(self.controller:ButtonDown(self.controls.gamepad.right)) then
			self:MoveRight()
		end 

		----------------
		-- Sticks
		----------------
		-- move
		self.xStick = self.controller.leftStick.x.lastValue

		----------------
		-- Buttons
		----------------

		-- shoot
		if(self.controller:ButtonDown(self.controls.gamepad.shoot)) then
			self:Shoot()
		end 

		-- build
		if(self.controller:ButtonDown(self.controls.gamepad.build)) then
			self:Build()
		end 

		-- jump
		if(self.controller:ButtonDown(self.controls.gamepad.jump)) then
			self:Jump(10)
		end 

	end

	-- add new object to updater
	ObjectUpdater:Add{object}

	-- done creating player object
	return object

end 


-- done with static
return SnapPlayer


-- Notes
-------------------------------------
-- this is a copy of Player.lua
-- to be used with Adam's SnapGrid