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
	local shootKeyRef = {}

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

			shootKeyRef.delay = o.bullets[o.bulletsIndex].shootDelay

			printDebug{"next bullet", "BulletShooter"}
			
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

			shootKeyRef.delay = o.bullets[o.bulletsIndex].shootDelay

			printDebug{"prev bullet", "BulletShooter"}

		end
	}

	local shoot =
	{
		"n", "hold",
		function()
			o.bullets[o.bulletsIndex]:Shoot
			{
				x = o.sprite.Pos.x + 50,
				y = o.sprite.Pos.y
			}

			printDebug{"shoot bullet", "BulletShooter"}
		end 
	}

	shoot[8] = 2

	o.Input:AddKeys
	{
		moveUp, moveDown, moveRight, moveLeft,
		nextWeapon, prevWeapon
	}

	shootKeyRef = o.Input:AddKey(shoot)



	---------------
	-- Bullets
	---------------
	
	o.bulletsIndex = 1
	
	-- test
	local bullet = Bullet:New
	{
		image = "bullet.png",
		width = 20,
		height = 20,
		frames = 12,
		shootDelay = 2
	}

	-- thin laser
	local laser = Bullet:New
	{
		image = "laser.png",
		width = 80,
		height = 20,
		frames = 5,
		shootDelay = 10
	}

	local cannonOld = Bullet:New
	{
		image = "cannonOld.png",
		width = 31,
		height = 11, 
		frames = 1,
		add = true,
		shootDelay = 25
	}

	local cannonNew = Bullet:New
	{
		image = "cannonNew.png",
		width = 28,
		height = 20,
		frames = 10,
		shootDelay = 6
	}

	local sniperLevel1 = Bullet:New
	{
		image = "SniperLevel1.png",
		width = 48,
		height = 8,
		frames = 8,
		shootDelay = 40,
		speed = 30
	}

	local sniperLevel2 = Bullet:New
	{
		image = "SniperLevel2.png",
		width = 76,
		height = 18,
		frames = 10,
		shootDelay = 40,
		speed = 30
	}

	local sniperLevel3 = Bullet:New
	{
		image = "SniperLevel3.png",
		width = 82,
		height = 23,
		frames = 10,
		shootDelay = 40,
		speed = 30
	}

	local uzi_thin_3_3 = Bullet:New
	{
		image = "uzi_thin_3_3.png",
		width = 32,
		height = 3,
		frames = 6,
		shootDelay = 3,
		speed = 18,
		frameDelay = 1,
		startFrameAdd = true,
		randomYOffset = 10
	}

	local uzi2_1_3 = Bullet:New
	{
		image = "uzi2_1_3.png",
		width = 15,
		height = 7,
		frames = 9,
		shootDelay = 3,
		speed = 18,
		frameDelay = 2,
		startFrameAdd = true,
		randomYOffset = 10
	}

	local uzi3_2_5 = Bullet:New
	{
		image = "uzi3_2_5.png",
		width = 18,
		height = 8,
		frames = 9,
		shootDelay = 3,
		speed = 18,
		frameDelay = 2,
		startFrameAdd = true,
		randomYOffset = 10
	}

	local uzi3_2_5_simpleColor = Bullet:New
	{
		image = "uzi3_2_5_simpleColor.png",
		width = 18,
		height = 8,
		frames = 9,
		shootDelay = 3,
		speed = 10,
		frameDelay = 2,
		startFrameAdd = true,
		randomYOffset = 10
	}

	local uzi4_3_3_1 = Bullet:New
	{
		image = "uzi4_3_3_1.png",
		width = 20,
		height = 6,
		frames = 12,
		shootDelay = 3,
		speed = 12,
		frameDelay = 1,
		startFrameAdd = true,
		randomYOffset = 10
	}

	local uzi4_3_3_1_simple = Bullet:New
	{
		image = "uzi4_3_3_1_simple.png",
		width = 20,
		height = 6,
		frames = 12,
		shootDelay = 3,
		speed = 12,
		frameDelay = 1,
		startFrameAdd = true,
		randomYOffset = 10
	}

	local uzi4_3_3_2 = Bullet:New
	{
		image = "uzi4_3_3_2.png",
		width = 24,
		height = 8,
		frames = 12,
		shootDelay = 3,
		speed = 12,
		frameDelay = 1,
		startFrameAdd = true,
		randomYOffset = 10
	}

	o.bullets = 
	{
		uzi4_3_3_1,
		uzi4_3_3_1_simple,
		uzi4_3_3_2,
		uzi3_2_5,
		uzi3_2_5_simpleColor,
		uzi2_1_3,
		uzi_thin_3_3,
		sniperLevel1,
		sniperLevel2,
		sniperLevel3,
		bullet,
		laser,
		cannonOld,
		cannonNew,
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