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
	object.width = data.width or 32
	object.height = data.height or 32
	object.color = data.color or {255,255,255,255}
	object.playerColor = data.playerColor or "red"
	object.speed = data.speed or 2

	object.frame = data.frame or nil
	object.animation = data.animation or nil

	object.angle = data.angle or 0
	object.xScale = data.xScale or 1
	object.yScale = data.yScale or 1
	object.xShootPos = data.xShootPos or 25
	object.yShootPos = data.yShootPos or 0
	object.shootDirection = data.shootDirection or 1
	
	object.name = data.name
	object.collisionList =  CollisionLists[object.name]

	object.skin = data.skin
	object.type = "player"


	-- controls
	object.keys =
	{
		left = data.keys and data.keys.left or "a",
		right = data.keys and data.keys.right or "d",
		up = data.keys and data.keys.up or "w",
		down = data.keys and data.keys.down or "s",
		shoot = data.keys and data.keys.shoot or "q",
		build = data.keys and data.keys.build or "e"
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
		parent = object
	}


	-------------
	-- Functions
	-------------

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

	-- shoot bullets
	object.reloadMaxTime = 10
	object.reloadTime = 0

	function object:Shoot()

		self.reloadTime = self.reloadTime + 1

		-- unable to shoot?
		if(self.reloadTime < self.reloadMaxTime) then
			return
		end 

		if(self.shootDirection == -1) then
			Bullet:New
				{
					name = self.playerColor .. "Bullet",
					frame = self.skin.bullet,
					speed = -5,
					lifespan = 60,
					shooter = self,
					collisionList = self.collisionList.bullet
				}
		else
			Bullet:New
			{
				name = self.playerColor .. "Bullet",
				frame = self.skin.bullet,
				speed = 5,
				lifespan = 60,
				shooter = self,
				collisionList = self.collisionList.bullet
			}
		end 

		self.reloadTime = 0

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

	end 


	-- this is keyboard controls
	-- need to reorganize :P
	-- only used for isDown=pressed 
	-- not for button down or up
	function object:RepeatedInput()

		-- simple controls
		if(love.keyboard.isDown(self.keys.left)) then
			self:MoveLeft()
		end 

		if(love.keyboard.isDown(self.keys.right)) then
			self:MoveRight()
		end 

		if(love.keyboard.isDown(self.keys.up)) then
			self:MoveUp()
		end 

		if(love.keyboard.isDown(self.keys.down)) then
			self:MoveDown()
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

		-- up
		if(self.controller:Button(self.controls.gamepad.up)) then
			self:MoveUp()
		end 

		-- down
		if(self.controller:Button(self.controls.gamepad.down)) then
			self:MoveDown()
		end 

		-- left
		if(self.controller:Button(self.controls.gamepad.left)) then
			self:MoveLeft()
		end 

		-- right
		if(self.controller:Button(self.controls.gamepad.right)) then
			self:MoveRight()
		end 

		-- shoot
		if(self.controller:Button(self.controls.gamepad.shoot)) then
			self:Shoot()
		end 

		-- build
		if(self.controller:Button(self.controls.gamepad.build)) then
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