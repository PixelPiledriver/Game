--Bullet.lua

-- Requires
--------------------------

local Color = require("Color")
local SpriteBank = require("SpriteBank")
local BulletShot = require("BulletShot")

----------------------------------------------------------------

local Bullet = {}

-------------------
-- Static Info
-------------------
Bullet.Info = Info:New
{
	objectType = "Bullet",
	dataType = "GameObject",
	structureType = "Static"
}

function Bullet:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Bullet",
		dataType = "GameObject",
		structureType = "Object"
	}

	------------
	-- Vars
	------------
	o.frameDirection = data.frameDirection or "x"

	o.speed = data.speed or 10

	o.delay = data.delay or 3

	---------------
	-- Graphics
	---------------

	o.SpriteBank = SpriteBank:New
	{
		image = data.image,
		spriteWidth = data.width,
		spriteHeight = data.height
	}

	-- create frames
	local frames = {}

	for i=1, data.frames do
		frames[#frames+1] = {"frame " .. i, i, 1}
	end

	local frameNames = {}
	for i=1, #frames do
		frameNames[#frameNames+1] = frames[i][1]
	end 

	print(#frameNames)

	-- add frames to bank
	o.SpriteBank:Add(frames)

	-- create animation
	o.SpriteBank:AddAnimation
	{
		name = "shoot",
		frames = frameNames,
		add = Bool:DataOrDefault(data.add, false)
	}

	-- get animation as object
	o.SpriteBank:CreateAnimation("shoot")

	o.sprite = o.SpriteBank:GetAnimation("shoot")


	---------------
	-- Functions
	---------------
	
	o.life = 50

	function o:Update()
		o.sprite.Pos.x = o.sprite.Pos.x + o.speed

		o.life = o.life - 1
		if(o.life < 0) then
			ObjectManager:Destroy(o)
		end 

	end 

	function o:Shoot(data)

		local shoot = BulletShot:New
		{
			bullet = o.SpriteBank:CopyAnimation("shoot"),
			speed = self.speed,
			x = data.x,
			y = data.y
		}

		shoot.bullet.Scale:SetScale(2)

	end 

	function o:Destroy()
		ObjectManager:Destroy(o.Info)
		ObjectManager:Destroy(o.SpriteBank)
		ObjectManager:Destroy(o.sprite)
	end 

	-----------
	-- End
	-----------

	ObjectManager:Add{o}
	return o

end 


----------------
-- Static End
----------------

ObjectManager:AddStatic(Bullet)
	
return Bullet 


-- Notes
-----------------------------------------------------

--[==[

--[[
		if(o.frameDirection == "x") then
			frames[#frames+1] = {"frame " .. i, i, 1}
		else
			frames[#frames+1] = {"frame " .. i, 1, i}
		end
--]]



--]==]