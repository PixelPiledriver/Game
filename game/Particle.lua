-- Particle
-- basic shit for explosions
-- KERPOW


local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")

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
		fill = true
	}

	object.xSpeed = data.xSpeed or 0
	object.ySpeed = data.ySpeed or 1
	object.speed = data.speed or 1
	object.damp = data.damp or 0

	object.fade = data.fade or 10

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


	function object:Update()
		self:Move()
		self:Life()
	end 


	ObjectUpdater:Add{object}

	return object


end 





return Particle