-- basic object with sprite, input, etc


local ObjectUpdater = require("ObjectUpdater")
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

-- use to create more instances
local Player = {}



-- create instance
function Player:New(data)

	----------
	-- Create
	----------
	local object = {}

	object.sprite = data.sprite or nil
	object.x = data.x or 100
	object.y = data.y or 100
	object.yOffset = 0
	object.width = data.width or 32
	object.height = data.height or 32
	object.color = data.color or {255,255,255,255}
	object.playerColor = data.playerColor or "red"
	object.speed = data.speed or 2

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
	object.gun = data.gun or Guns.laserRifle
	--object.rateOfFire = object.gun.rateOfFire

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
		color = Color[object.playerColor],
		name = object.name,
		parent = object,
		collisionList = object.collisionList.robot,
		draw = false
	}


	function object:OnCollision(data)
		
		-- Bullet
		if(data.other.parent.type == "bullet") then
			self.health:Damage(data.other.parent)
		end 

		--print(self.health:GetHealth())
	end 


	-------------
	-- Functions
	-------------

	function object:PrintDebugText()
		
		DebugText:TextTable
		{
			{text = "", obj = "Player" },
			{text = "Name: " .. data.name},
			{text = "X: " .. data.x},
			{text = "Y: " .. data.y},
			{text = "HP:" ..self.health.hp},
			{text = "Gun: " .. self.gun.name},
			{text = "Direction: " .. self.direction},
			{text = "Map { " .. self.mapX .. ", " .. self.mapY .. "}"},
			{text = "Y Offset: " .. self.yOffset}
		}
	end 

	function object:DoMapStuff()

		self.mapX = (( (self.x) - (self.x % Map.tileWidth)) / Map.tileWidth) + 1
		self.mapY = (( (self.y + self.height) - (self.y % Map.tileHeight)) / Map.tileHeight) + 1
	
		Map:ObjectInTile(self)
	end 

	local gravity = 1
	object.yJump = 0
	function object:JumpUpdate()

		self.yOffset = self.yOffset + self.yJump

		if(self.yOffset > 0 ) then
			self.yJump = self.yJump - gravity
		end

		if(self.yOffset < 0 ) then
			self.yOffset = 0
			self.yJump = 0
		end 
		
	end 

	function object:Shadow()
		self.shadow.x = self.x + 6
		self.shadow.y = self.y + self.height - self.shadow.height

	end 

	function object:Update()
		self:DoMapStuff()
		self:JumpUpdate()
		self:Shadow()
	end 

	function object:Draw()

		-- what type of graphic does the object have
		-- this is bullshit and needs to be re worked
		if(self.frame) then
			self.skin.idle:Draw(self)
		elseif(self.animation) then
			self.animation:Draw(self)
		end 

	end 


	-------------
	-- Actions
	---------------

	-- movement
	function object:MoveLeft()
		self.x = self.x - self.speed
	end 

	function object:MoveRight()
		self.x = self.x + self.speed
	end 

	function object:MoveUp()
		self.y = self.y - self.speed
	end 

	function object:MoveDown()
		self.y = self.y + self.speed
	end 




	function object:Jump(j)
		self.yJump = j
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

		if(key == " ") then
			self.yJump = 10
		end 

	end 


	-- this is keyboard controls
	-- need to reorganize :P
	-- only used for isDown=pressed 
	-- not for button down or up
	function object:RepeatedInput()

		-- simple controls
		if(love.keyboard.isDown(self.keys.left)) then
			self:MoveLeft()
			self:SetDirection("left")
		end 

		if(love.keyboard.isDown(self.keys.right)) then
			self:MoveRight()
			self:SetDirection("right")
		end 

		if(love.keyboard.isDown(self.keys.up)) then
			self:MoveUp()
			self:SetDirection("up")
		end 

		if(love.keyboard.isDown(self.keys.down)) then
			self:MoveDown()
			self:SetDirection("down")
		end

		if(love.keyboard.isDown(self.keys.jump)) then
			print("jump")
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


	end

	-- add new object to updater
	ObjectUpdater:Add{object}

	-- done creating player object
	return object

end 


-- done with static
return Player










-- Notes
---------------

		--[[
		local box1 = Box:New
		{
			x = (self.x - (self.x % 32)) + self.width/2,
			y = (self.y - (self.y % 32)) + self.height/2,
			color = Color[self.playerColor]
		}
		--]]




				--[[
		self.rateOfFire = self.rateOfFire + 1

		-- unable to shoot?
		if(self.rateOfFire < self.gun.rateOfFire) then
			return
		end 

		if(self.shootDirection == -1) then
			Bullet:New
				{
					name = self.playerColor .. "Bullet",
					frame = self.skin.bullet,
					xSpeed = -1,
					bulletType = self.gun.bullet,
					shooter = self,
					collisionList = self.collisionList.bullet
				}


		else
			Bullet:New
			{
				name = self.playerColor .. "Bullet",
				frame = self.skin.bullet,
				xSpeed = 1,
				bulletType = self.gun.bullet,
				shooter = self,
				collisionList = self.collisionList.bullet
			}
		end 

		self.rateOfFire = 0
		--]]