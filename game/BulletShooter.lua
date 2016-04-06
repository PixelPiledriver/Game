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

	local shoot =
	{
		"n", "hold",
		function()
			o.a:Shoot
			{
				x = o.sprite.Pos.x + 55,
				y = o.sprite.Pos.y + 10
			}
		end 
	}

	o.Input:AddKeys
	{
		moveUp, moveDown, moveRight, moveLeft, shoot
	}


	---------------
	-- Bullets
	---------------
	
	o.a = Bullet:New
	{
		image = "bullet.png",
		width = 20,
		height = 20,
		frames = 12
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
			{text = "Y: " .. o.sprite.Pos.y}
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