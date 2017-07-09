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

	o.shootDelay = data.shootDelay or 3
	printDebug{"frame delay: " .. (data.frameDelay or "none"), "Bullet"}

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

	printDebug{#frameNames, "Bullet"}

	-- add frames to bank
	o.SpriteBank:Add(frames)

	-- create animation
	o.SpriteBank:AddAnimation
	{
		name = "shoot",
		frames = frameNames,
		add = Bool:DataOrDefault(data.add, false),
		delay = data.frameDelay or nil
	}

	-- get animation as object
	o.SpriteBank:CreateAnimation("shoot")

	o.sprite = o.SpriteBank:GetAnimation("shoot")


	-- increase start frame each time a bullet is shot
	o.startFrameAdd = Bool:DataOrDefault(data.startFrameAdd, false)
	o.startFrameIndex = 1

	-- animation info
	o.frameTotal = data.frames

	o.randomYOffset = data.randomYOffset or 0




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
			y = data.y + Random:Number(self.randomYOffset)
		}

		shoot.bullet.Scale:SetScale(2)

		-- start animation from next frame?
		-- this is used to create bullet flow
		if(self.startFrameAdd) then

			self.startFrameIndex = self.startFrameIndex - 1

			-- reset sub
			if(self.startFrameIndex < 1) then
				self.startFrameIndex = self.frameTotal
			end 		

			shoot.bullet.currentFrame = self.startFrameIndex

			-- reset add
			if(self.startFrameIndex > #shoot.bullet.frames) then
				self.startFrameIndex = 1
			end



		end 


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