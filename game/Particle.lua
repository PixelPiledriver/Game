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

	local size = 
	{
		width = data.width or Random:MultipleOf(data.sizeMultiple, data.sizeMultipleRange),
		height = data.height or Random:MultipleOf(data.sizeMultiple, data.sizeMultipleRange),
	}

	object.box = Box:New
	{
		x = object.x,
		y = object.y,
		color = data.colorName and Color:Get(data.colorName) or data.color or Color:Get("white"),
		width = size.width,
		height = size.height,
		fill = true,
		angle = data.angle or 0,
		rotatable = true,
		spin = data.spin,
	}

	local speed = 
	{
		x = data.xSpeed or 0,
		y = data.ySpeed or 0
	}

	object.xSpeed = speed.x
	object.ySpeed = speed.y
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

-- returns a copy of particle type
function Particle:Get(name)

	local p = self:New(Particle[name])

	return p

end 

Particle.testType =
{
	life = 100,
	xSpeed = 1,
	ySpeed = 0,
	colorName = "green",
	sizeMultiple = 2,
	sizeMultipleRange = 6,
	angle = 0,
	fade = 1
}

Particle.testType2 =
{
	life = 100,
	xSpeed = 1,
	ySpeed = -1,
	colorName = "blue",
	sizeMultiple = 2,
	sizeMultipleRange = 6,
	angle = 0,
	fade = 3
}



return Particle