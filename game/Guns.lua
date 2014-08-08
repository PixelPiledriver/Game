-- Gun Types
-- players can carry guns and shoot stuff
-- Guns have stats and properties --> ammo from BulletTypes etc

local BulletTypes = require("BulletTypes")
local Bullet = require("Bullet")



local Guns = {}

function Guns:New(data)

	local object = {}

	object.name = data.name or "Gun"
	object.bullet = data.bullet or BulletTypes.laser
	object.maxRateOfFire = data.rateOfFire or 10
	object.rateOfFire = 0
	object.clip = data.clip or 10
	object.reloadTime = data.reloadTime or 100				-- time it takes to load new ammo clip, need to add reload types
	object.shotsFired = data.shotsFired or 1 					-- for shotguns, etc

	object.parent =  nil 															-- owner of the gun
	object.triggerDown = false
	object.triggerMashing = false

	function object:Shoot(p)


		self.rateOfFire = self.rateOfFire + 1

		-- unable to shoot?
		-- need to put in gun stat you can just press the button for non automatics
		if(self.rateOfFire < self.maxRateOfFire) then
			return
		end 

		Bullet:New
		{
			name = p.playerColor .. "Bullet",
			frame = p.skin.bullet,
			direction = {x = p.xDirection, y = p.yDirection},
			bulletType = self.bullet,
			shooter = p,
			collisionList = p.collisionList.bullet
		}

		self.rateOfFire = 0

	end 

	return object

end 

function Guns:Get(gunName)
	local copy = {}

	for i=1, #Guns.stats do
		copy[Guns.stats[i]] = Guns[gunName][Guns.stats[i]]
	end


	return copy
end 

Guns.stats =
{
	"name",
	"bullet",
	"rateOfFire",
	"maxRateOfFire",
	"clip",
	"reloadTime",
	"Shoot"
}

Guns.laserRifle = Guns:New
{
	name = "LaserRifle",
	bullet = BulletTypes.laser,
	rateOfFire = 8,
	clip = 20,
	reloadTime = 100,
	ammo = -1
}

Guns.assaultRifle = Guns:New
{
	name = "AssaultRifle",
	bullet = BulletTypes.laser,
	rateOfFire = 4,
	clip = 20,
	reloadTime = 100,
	ammo = 100
}

Guns.missleLauncher = Guns:New
{
	name = "missleLauncher",
	rateOfFire = 100,
	bullet = BulletTypes.missle,
	clip = 3,
	reloadTime = 300,
	ammo = 20
}



return Guns




-- notes
----------------

-- oh shit bro :O
-- there is only one instance of each gun, both players cant shoot at the same time
-- need to hand out copies to players

-- 