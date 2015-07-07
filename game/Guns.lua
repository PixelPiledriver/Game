-- Gun Types
-->OLD

-- Purpose
---------------------------------------------------
-- players can carry guns and shoot stuff
-- Guns have stats and properties --> ammo from BulletTypes etc

------------------
-- Requires
------------------

local BulletTypes = require("BulletTypes")
local Bullet = require("Bullet")


-----------------------------------------------------------------------------------

local Guns = {}

------------------
-- Static Info
------------------
Guns.Info = Info:New
{
	objectType = "Guns",
	dataType = "Game",
	structureType = "Static"
}

-----------------
-- Static Vars
-----------------
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



function Guns:New(data)

	local o = {}

	-----------------
	-- Object Info
	-----------------

	o.name = data.name or "???"
	o.objectType = "Gun"
	o.dataType = "Player Item"

	-----------
	-- Vars
	-----------

	o.bullet = data.bullet or BulletTypes.laser
	o.maxRateOfFire = data.rateOfFire or 10
	o.rateOfFire = 0
	o.clip = data.clip or 10
	o.reloadTime = data.reloadTime or 100				-- time it takes to load new ammo clip, need to add reload types
	o.shotsFired = data.shotsFired or 1 					-- for shotguns, etc

	o.parent =  nil 															-- owner of the gun
	o.triggerDown = false
	o.triggerMashing = false


	----------------
	-- Functions
	----------------

	function o:Shoot(p)


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

	return o

end 

----------------------
-- Static Functions
----------------------

function Guns:Get(gunName)
	local copy = {}

	for i=1, #Guns.stats do
		copy[Guns.stats[i]] = Guns[gunName][Guns.stats[i]]
	end


	return copy
end 



----------
-- Guns
----------

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

----------------
-- Static End
----------------

return Guns




-- notes
----------------
-- old code

-- is this fixed? -->FIX
-- there is only one instance of each gun, both players cant shoot at the same time
-- need to hand out copies to players