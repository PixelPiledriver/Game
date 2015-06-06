-- Player.lua
-- basic o with sprite, input, etc

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




-- use to create more instances
local Player = {}



-- create instance
function Player:New(data)

	----------
	-- Create
	----------
	local o = {}

	o.name = data.name or "..."
	o.oType = "Player"
	o.datatype = "Game Object"

	o.sprite = data.sprite or nil

	o.x = data.x or 100
	o.y = data.y or 100
	o.z = 0
	
	o.gravity = 1

	o.yJump = 0
	o.jumpNow = false

	o.GridMovementTimer = Timer:New()

	o.width = data.width or 32
	o.height = data.height or 32
	o.color = data.color or {255,255,255,255}
	o.playerColor = data.playerColor or "red"

	o.speed = data.speed or 2
	o.walkSpeed = data.walkSpeed or 2
	o.dodgeSpeed = data.dodgeSpeed or 6

	o.direction = "none"
	o.xDirection = 1
	o.yDirection = 0

	o.frame = data.frame or nil
	o.animation = data.animation or nil

	o.angle = data.angle or 0
	o.xScale = data.xScale or 1
	o.yScale = data.yScale or 1
	o.xShootPos = data.xShootPos or 25
	o.yShootPos = data.yShootPos or 0
	o.shootDirection = data.shootDirection or 1

	o.xStick = 0
	o.yStick = 0
	
	o.name = data.name or "???"
	o.type = "player"


	o.collisionList = CollisionLists[o.name]

	o.skin = data.skin
	
	o.health =  Health:New{}

	o.mapX = 0
	o.mapY = 0

	-- weapon
	o.gun = Guns:Get("laserRifle")

	-- controls
	o.keys =
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
	o.useController = false
	if(Controller:Count() > 0) then
		o.controller = Controller:GetUnclaimedController()

		-- claimed a controller?
		if(o.controller) then 
			o.useController = true
		end 

	end

	-- shadow
	local shadowHeight = 6
	local shadowWidth = o.width - 12
	o.shadow = Box:New
	{
		x = o.x + 6,
		y = o.y + o.height - shadowHeight,
	 	width = shadowWidth,
	 	height = shadowHeight,
		color = {0,0,0,100},
		fill = true
	}



	---------------
	-- Collision
	---------------
	
	o.collision = Collision:New
	{
		width = 32,
		height = 32,
		shape = "rect",
		color = Color:Get(o.playerColor),
		name = o.name,
		parent = o,
		collisionList = o.collisionList.robot,
		visible = false
	}


	function o:OnCollision(data)
		
		-- Bullet
		if(data.other.parent.type == "bullet") then
			self.health:Damage(data.other.parent)
			self:ColorFlash()
		end 

	end 


	-------------
	-- Functions
	-------------

	function o:ColorFlash()
		self.color = Color:Get("red")
	end 

	function o:ColorUpdate()

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

	function o:PrintDebugText()
		
		DebugText:TextTable
		{
			{text = "", obj = "Player" },
			{text = "Name: " .. self.name},
			{text = "X: " .. self.x},
			{text = "Y: " .. self.y},
			{text = "Z: " .. self.z},
			{text = "HP:" .. self.health.hp},
			{text = "Gun: " .. self.gun.name},
			{text = "Direction: " .. self.direction},
			{text = "Map { " .. self.mapX .. ", " .. self.mapY .. "}"},
		}
	end 

	function o:DoMapStuff()

		self.mapX = (( (self.x) - (self.x % Map.tileWidth)) / Map.tileWidth) + 1
		self.mapY = (( (self.y + self.height) - (self.y % Map.tileHeight)) / Map.tileHeight) + 1
	
	--[[
		local tile = Map:ObjectInTile(self)

		
		if(tile) then 
			self.z = -tile.z
		end 
	--]]

	end 

	function o:JumpUpdate()

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

	function o:Shadow()
		self.shadow.x = self.x + 6
		self.shadow.y = self.y + self.height - self.shadow.height
		self.shadow.z = self.z
	end 

	function o:Update()
		self:DoMapStuff()
		self:JumpUpdate()
		self:Shadow()
		self:ColorUpdate()
	end 

	function o:DrawCall()

		-- what type of graphic does the o have
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

	-- simple movement
	function o:MoveLeft()
		self.x = self.x - self.speed
	end 

	function o:MoveRight()
		self.x = self.x + self.speed
	end 

	function o:MoveUp()
		self.y = self.y - self.speed
	end 

	function o:MoveDown()
		self.y = self.y + self.speed
	end 



	-- jump
	function o:Jump(j)
		if(self.z == 0) then
			self.yJump = 10
		end 
	end 

	-- used for 4 directional movement
	-- put in options for movement types
	-- need to get hud buttons for changing options at runtime
	function o:SetDirection(dir)

		o.direction = dir

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

	function o:Shoot()

		self.gun:Shoot(self)
	
	end 

	-- build blocks
	function o:Build()

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
	function o:InputUpdate(key, inputype)

		if(key == "d") then 
			self:MoveRight()
		end

		if(key == "a") then
			self:MoveLeft()
		end 

		if(key == "w") then 
			self:MoveUp()
		end

		if(key == "s") then
			self:MoveDown()
		end 

		if(key == self.keys.jump) then
			self:Jump(10)
		end 

	end 


	-- this is keyboard controls
	-- need to reorganize :P
	-- only used for isDown=pressed 
	-- not for button down or up
	function o:RepeatedInput()
		-- simple controls
		if(love.keyboard.isDown(self.keys.left)) then
			love.timer.getTime();
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
			
		end

		if(love.keyboard.isDown(self.keys.shoot)) then
			self:Shoot()
		end 

		if(love.keyboard.isDown(self.keys.build)) then
			self:Build()
		end 

	end 


	-- xbox controller input
	o.controls = 
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

	function o:ControllerInput()

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

	-- add new o to updater
	ObjectUpdater:Add{o}

	-- done creating player o
	return o

end 


-- done with static
return Player

-- Notes
--------------
-- pull out all the controller bullshit and move to its own component








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