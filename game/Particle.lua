-- Particle
-- basic shit for explosions
-- KERPOW


local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")
local Color = require("Color")

local Particle = {}


function Particle:New(data)


	local object = {}

	object.x = data.x or 100
	object.y = data.y or 100

	object.box = Box:New
	{
		x = object.x,
		y = object.y,
		color = data.color,
		width = data.width,
		height = data.height,
		fill = true,
		angle = data.angle or 0,
		rotatable = true,
		spin = data.spin,
	}

	object.xSpeed = data.xSpeed or 0
	object.ySpeed = data.ySpeed or 1
	object.speed = data.speed or 1
	object.damp = data.damp or 0


	object.fade = data.fade or 0
		

	object.life = data.life or 30
	

	function object:Move()
		self.x = self.x + (self.speed * self.xSpeed)
		self.y = self.y + (self.speed * self.ySpeed)

		self.box.x = self.x
		self.box.y = self.y
	end 


	function object:Life()
		self.life = self.life - 1

		if(self.life <= 0) then
			ObjectUpdater:Destroy(self.box)
			ObjectUpdater:Destroy(self)
		end 

	end 


	function object:Fade()
		if(self.fade == 0) then
			return
		end 

		self.box.color[4] = self.box.color[4] - self.fade
		
		if(self.box.color[4] < 0) then
			self.box.color[4] = 0
		end 

	end 

	function object:Update()
		self:Move()
		self:Life()
		self:Fade()

	end 


	ObjectUpdater:Add{object}

	return object


end 


 
-- types

Particle.spot = 
{

}


return Particle