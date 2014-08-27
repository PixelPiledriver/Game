-- Particle
-- basic shit for explosions
-- KERPOW


local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")
local Color = require("Color")
local Random = require("Random")

local Particle = {}


function Particle:New(data)

	local object = {}


	------------------------
	-- Pos
	------------------------
	if(data.xOffset) then
		object.x = data.x + love.math.random(data.xOffset.min, data.xOffset.max) 
	else 
		object.x = data.x
	end 

	if(data.yOffset) then
		object.y = data.y + love.math.random(data.yOffset.min, data.yOffset.max)
	else
		object.y = data.y
	end 
	
	-------------------------
	-- Size
	-------------------------
	local width = 0
	local height = 0

	-- direct
	if(data.width) then
		width = data.width
	end

	if(data.height) then
		height = data.height
	end

	-- multiple
	if(data.sizeMultiple) then
		width = Random:MultipleOf(data.sizeMultiple.start, data.sizeMultiple.range)
		height = Random:MultipleOf(data.sizeMultiple.start, data.sizeMultiple.range)
	end

	-- range
	if(data.widthRange) then
		width = love.math.random(data.widthRange.min, data.widthRange.max)
	end 

	if(data.heightRange) then
		height = love.math.random(data.heightRange.min, data.heightRange.max)
	end

	----------------------------
	-- Spin
	----------------------------
	local spin = 0 
	
	if(data.spin) then
		spin = data.spin
	end 

	if(data.spinRange) then
		spin = love.math.random(data.spinRange.min, data.spinRange.max)
	end 

	------------------------------
	-- Graphics
	------------------------------
	
	-- box
	object.box = Box:New
	{
		x = object.x,
		y = object.y,
		color = data.colorName and Color:Get(data.colorName) or data.color or Color:Get("white"),
		width = width,
		height = height,
		fill = true,
		angle = data.angle or 0,
		rotatable = true,
		spin = spin,
	}

	-- color
	object.colorMod = data.colorMod or nil

	-------------------------
	-- Speed and Direction
	-------------------------
	-- sort x and y speeds from options in data table
	local dir = {}

	-- speeds --> old dumb way to do it
	if(data.xSpeed and data.ySpeed) then
		dir.x = data.xSpeed or 0
		dir.y = data.ySpeed or 0
	end 

	-- direction range
	if(data.directionRange ) then
		local vec = Math:VectorFromAngle(love.math.random(data.directionRange.min, data.directionRange.max))
		dir.x = vec.x
		dir.y = vec.y
	end

	-- direction
	if(data.direction) then
		local vec = Math:VectorFromAngle(data.direction)
		dir.x = vec.x
		dir.y = vec.y
	end 
		
	object.xSpeed = dir.x
	object.ySpeed = dir.y

	------------------------
	-- Speed
	------------------------
	object.speed = data.speed or 1
	object.damp = data.damp or 1

	------------------------
	-- Other
	------------------------
	object.fade = data.fade or 0
	object.lifeStart = data.life or 50
	object.life = data.life or 50
	


	function object:Move()
		self.x = self.x + (self.speed * self.xSpeed)
		self.y = self.y + (self.speed * self.ySpeed)

		self.box.x = self.x
		self.box.y = self.y

		self.speed = self.speed * self.damp
	end 


	function object:Life()
		self.life = self.life - 1

		if(self.life <= 0) then
			ObjectUpdater:Destroy(self.box)
			ObjectUpdater:Destroy(self)
		end 

	end 


	function object:Fade()

		-- matches fade exactly with end of life
		if(self.fadeWithLife) then
			self.box.color[4] = self.life
		end 

		if(self.fade == 0) then
			return
		end 

		self.box.color[4] = self.box.color[4] - self.fade
		
		if(self.box.color[4] < 0) then
			self.box.color[4] = 0
		end 

	end 

	-- modulate color over life
	function object:ColorModulate()
		
		if(self.colorMod == nil) then
			return 
		end	

		-- life
		if(self.colorMod.type == "life") then

		end


		-- speed
		if(self.colorMod.type == "speed") then


		end 





	end 


	function object:Update()
		self:Move()
		self:Life()
		self:Fade()
		self:ColorModulate()

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
	directionRange = {min = 0, max = 360},
	colorName = "random",
	sizeMultiple = {start= 2, range= 6},
	angle = 0,
	fade = 1,
	spinRange = {min= 0, max= 10},
	xOffset = {min= -32, max= 32}
}

Particle.testType2 =
{
	life = 100,
	directionRange = {min = 0,  max = 360},
	colorName = "random",
	widthRange = {min= 1, max = 6},
	heightRange = {min= 28, max = 32},
	angle = 0,
	fade = 3,
	spinRange = {min= 0, max= 20} 
}



return Particle