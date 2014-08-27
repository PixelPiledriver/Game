-- Particle
-- basic shit for explosions
-- KERPOW


local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")
local Color = require("Color")
local Random = require("Random")
local DataPass = require("DataPass")

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
	local spin = DataPass:Options
	{
		varName = "spin",
		data = data,
		options =
		{
			{key = "spin", value = "value"},
			{key = "spinRange", value = "range"}
		}
	}
	
	--[[
	if(data.spin) then
		spin = data.spin
	end 

	if(data.spinRange) then
		spin = love.math.random(data.spinRange.min, data.spinRange.max)
	end
	--]]

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
	-- Direction
	-------------------------
	-- sort x and y speeds from options in data table
	local dir = {}

	-- direct setting of x and y components
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
	local speed = nil

	if(data.speed) then
		speed = data.speed
	end

	if(data.speedRange) then

	end 

	object.speed = speed or 1

	-- damp
	object.speedDamp = data.speedDamp or 1



	-------------------------
	-- Life
	-------------------------
	local life = nil

	if(data.lifeRange) then
		life = love.math.random(data.lifeRange.min, data.lifeRange.max)
	end 

	if(data.life) then
		life = data.life
	end


	object.lifeStart = life or 100
	object.life = life or 100


	------------------------
	-- Other
	------------------------
	object.fade = data.fade or 0
	object.fadeWithLife = data.fadeWithLife or false

	


	function object:Move()
		self.x = self.x + (self.speed * self.xSpeed)
		self.y = self.y + (self.speed * self.ySpeed)

		self.box.x = self.x
		self.box.y = self.y

		self.speed = self.speed * self.speedDamp
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

			local lifePercentage = Math:InverseLerp
			{
				a = 0, 
				b = self.lifeStart,
				t = self.life
			}

			self.box.color[4] = 255 * lifePercentage

			return

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
	fadeWithLife = true,
	spinRange = {min= 0, max= 10},
	xOffset = {min= -32, max= 32}
}

Particle.testType2 =
{
	--life = 200,
	lifeRange = {min = 10, max = 300},
	directionRange = {min = 0,  max = 360},
	colorName = "random",
	widthRange = {min= 1, max = 6},
	heightRange = {min= 28, max = 32},
	angle = 0,
	fade = 0,
	fadeWithLife = true,
	spinRange = {min= 0, max= 20} 
}



return Particle




-- Notes
----------------------

-- curved directions
-- change direction over life
-- change color over life
-- speed range
-- life range  -----------------------DONE