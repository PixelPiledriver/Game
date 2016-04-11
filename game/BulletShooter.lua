--BulletShooter.lua

-- Requires
--------------------

local Pos = require("Pos")
local Input = require("Input")
local SpriteBank = require("SpriteBank")
local Bullet = require("Bullet")


-------------------------------------------------

local BulletShooter = {}

-------------------
-- Static Info
-------------------
BulletShooter.Info = Info:New
{
	objectType = "BulletShooter",
	dataType = "Object",
	structureType = "Static"
}


-----------
-- Object
-----------

function BulletShooter:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Box",
		dataType = "Graphics",
		structureType = "Object"
	}


	--------------
	-- Vars
	--------------
	o.speed = 2
	o.scale = 2

	----------------
	-- Graphics
	----------------
	o.SpriteBank = SpriteBank:New
	{
		image = "Ship.png",
		spriteWidth = 33,
		spriteHeight = 19
	}

	o.SpriteBank:Add
	{
		{"ship",1,1}
	}


	o.sprite = o.SpriteBank:Get("ship")
	o.sprite.Pos.x = 200
	o.sprite.Pos.y = 100
	o.sprite.Scale:SetScale(o.scale)
	
	----------------
	-- Input
	----------------

	o.Input = Input:New{}

	-- predefine keys
	local shoot = {}

	local moveUp =
	{"w", "hold", 
		function() 
			o.sprite.Pos.y = o.sprite.Pos.y - o.speed
		end
	}

	local moveDown =
	{
		"s", "hold",
		function()
			o.sprite.Pos.y = o.sprite.Pos.y + o.speed
		end
	}

	local moveRight =
	{
		"d", "hold",
		function()
			o.sprite.Pos.x = o.sprite.Pos.x + o.speed
		end 
	}

	local moveLeft =
	{
		"a", "hold",
		function()
			o.sprite.Pos.x = o.sprite.Pos.x - o.speed
		end 
	}

	local nextWeapon =
	{
		"u", "press",
		function()
			o.bulletsIndex = o.bulletsIndex + 1
			if(o.bulletsIndex > #o.bullets) then
				o.bulletsIndex = #o.bullets
			end

			shoot[8] = o.bullets[o.bulletsIndex].delay
			print(shoot[8])
		end
	}

	local prevWeapon =
	{
		"y", "press",
		function()
			o.bulletsIndex = o.bulletsIndex - 1
			if(o.bulletsIndex < 1) then
				o.bulletsIndex = 1
			end 

			shoot[8] = o.bullets[o.bulletsIndex].delay
		end
	}

	shoot =
	{
		"n", "hold",
		function()
			o.bullets[o.bulletsIndex]:Shoot
			{
				x = o.sprite.Pos.x + 50,
				y = o.sprite.Pos.y
			}
		end 
	}
	shoot[8] = 2

	o.Input:AddKeys
	{
		moveUp, moveDown, moveRight, moveLeft, shoot,
		nextWeapon, prevWeapon
	}


	---------------
	-- Bullets
	---------------
	o.bullets = {}
	o.bulletsIndex = 1
	
	-- test
	o.bullets[1] = Bullet:New
	{
		image = "bullet.png",
		width = 20,
		height = 20,
		frames = 12,
		delay = 2
	}

	-- thin laser
	o.bullets[2] = Bullet:New
	{
		image = "laser.png",
		width = 80,
		height = 20,
		frames = 5,
		delay = 20
	}

	o.bullets[3] = Bullet:New
	{
		image = "cannonOld.png",
		width = 31,
		height = 11, 
		frames = 1,
		add = true,
		delay = 3
	}

	o.bullets[4] = Bullet:New
	{
		image = "cannonNew.png",
		width = 28,
		height = 20,
		frames = 10,
		delay = 5
	}
	
	---------------
	-- Functions
	---------------

	function o:PrintDebugText()

		local life = self.Life and self.Life.life or 0

		DebugText:TextTable
		{
			{text = "", obj = "BulletShooter" },
			{text = "BulletShooter"},
			{text = "---------------------"},
			{text = "X: " .. o.sprite.Pos.x},
			{text = "Y: " .. o.sprite.Pos.y},
			{text = "Weapon: " .. o.bulletsIndex}
		}

	end 

	---------
	-- End
	---------

	ObjectManager:Add{o}

	return o

end 



------------------
-- Static End
------------------

ObjectManager:AddStatic(BulletShooter)

return BulletShooter


--[[

		Bullet:New
		{
			image = "bullet.png",
			width = 20,
			height = 20,
			frames = 12,
			x = o.sprite.Pos.x + 55,
			y = o.sprite.Pos.y + 10
		}

--]]