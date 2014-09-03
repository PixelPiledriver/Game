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
	local width = DataPass:Options
	{
		data = data,
		options =
		{
			{"width", "value"},
			{"widthRange", "range"},
			{"widthMultiple", "multiple"}
		}
	}

	local height = DataPass:Options
	{
		data = data,
		options =
		{
			{"height", "value"},
			{"heightRange", "range"},
			{"heightMultiple", "multiple"}
		}
	}

	object.width = width
	object.height = height

	----------------------------
	-- Scale
	----------------------------
	object.scale = {}
	object.scale.xSpeed = data.scale.xSpeed
	object.scale.ySpeed = data.scale.ySpeed
	object.scale.x = 1
	object.scale.y = 1
	object.scale.min = 0
	object.scale.max = data.scale.max or 10


	----------------------------
	-- Spin
	----------------------------
	local spin = DataPass:Options
	{
		data = data,
		options =
		{
			{"spin", "value"},
			{"spinRange", "range"}
		}
	}

	-----------------
	-- Color
	-----------------
	object.colorMod = data.colorMod or nil

	local color = DataPass:Options
	{
		data = data,
		options =
		{
			{"color", "value"},
			{"colorName", "value"}
		}
	}

	if(object.colorMod) then
		color = object.colorMod.colors[1]
	end 

	object.interpolateColor = data.interpolateColor or false

	------------------------------
	-- Graphics
	------------------------------
	
	-- box
	object.box = Box:New
	{
		x = object.x,
		y = object.y,
		color = Color:Get(color),
		width = width,
		height = height,
		fill = true,
		angle = data.angle or 0,
		rotatable = true,
		spin = spin,
		draw = true
	}

	-------------------------------------
	-- Fade
	-------------------------------------
	if(data.inverseFade) then
		object.box.color[4] = 0 
	end 



	-------------------------
	-- Direction
	-------------------------
	-- sort x and y speeds from options in data table
	local dir = DataPass:Options
	{
		data = data,
		options = 
		{
			{"direction", "angleToVector"},
			{"directionRange", "angleRangeToVector"},
			{"directionList", "randomVector"}

		}
	}

	-- direct setting of x and y components
	if(data.xSpeed and data.ySpeed) then
		dir.x = data.xSpeed or 0
		dir.y = data.ySpeed or 0
	end 

	object.xSpeed = dir.x
	object.ySpeed = dir.y

	-- rotDirection
	object.rotDirection = {}
	object.rotDirection.enabled = data.rotDirection.enabled or false
	object.rotDirection.angle = math.deg(Math:VectorToAngle(dir))
	

	local dirSpeed = DataPass:Options
	{
		data = data.rotDirection,
		options =
		{
			{"speed", "value"},
			{"speedRange", "range"}
		}

	}
	object.rotDirection.speed = dirSpeed
	

	------------------------
	-- Speed
	------------------------
	local speed = DataPass:Options
	{
		data = data,
		options = 
		{
			{"speed", "value"},
			{"speedRange", "range"}
		}
	}

	object.speed = speed or 1

	-- damp
	local speedDamp = DataPass:Options
	{
		data = data,
		options =
		{
			{"speedDamp", "value"},
			{"speedDampRange", "range"}
		}
	}

	object.speedDamp = data.speedDamp or 1



	-------------------------
	-- Life
	-------------------------
	local life = DataPass:Options
	{
		data = data,
		options =
		{
			{"life", "value"},
			{"lifeRange", "range"}
		}
	}

	object.lifeStart = life or 100
	object.life = life or 100


	------------------------
	-- Other
	------------------------
	object.fade = data.fade or 0
	object.fadeWithLife = data.fadeWithLife or false
	object.inverseFade = data.inverseFade or false

	

	----------------------------
	-- DebugText Variables --> can disable these later
	----------------------------
	object.lerpValue = nil
	object.colorIndex = nil
	object.bIndex = nil
	object.lifePercentage = nil



	-------------------------------
	-- Functions
	-------------------------------


	function object:Move()
		self.x = self.x + (self.speed * self.xSpeed)
		self.y = self.y + (self.speed * self.ySpeed)

		self.box.x = self.x
		self.box.y = self.y

		self.speed = self.speed * self.speedDamp
	end 

	function object:RotDirection()
		if(self.rotDirection.enable == false) then
			return
		end 

		self.rotDirection.angle = self.rotDirection.angle + self.rotDirection.speed * 0.01

		local dir = Math:AngleToVector(self.rotDirection.angle)
		dir = Math:UnitVector(dir)
		self.xSpeed = dir.x
		self.ySpeed = dir.y

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

			local value = 255 * lifePercentage
			
			if(self.inverseFade) then
				value = 255 - value
			end 

			self.box.color[4] = value

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

			local lifePercentage = Math:InverseLerp
			{
				a = 0,
				b = self.lifeStart,
				t = self.life
			}

			-- inverse percentage
			lifePercentage = 1 - lifePercentage
			self.lifePercentage = lifePercentage

			-- create values
			local colorIndex = nil
			local lerpValue = nil 

			-- get a index
			if(self.interpolateColor) then
				colorIndex = math.floor(#self.colorMod.colors * lifePercentage)
				lerpValue = (#self.colorMod.colors * lifePercentage) - colorIndex 
			else
				colorIndex = math.floor(#self.colorMod.colors * lifePercentage) + 1
			end

			-- color index weight
			if(self.colorMod.weight == "end") then
				colorIndex = colorIndex + 1
			elseif(self.colorMod.weight == "start") then
				colorIndex = colorIndex
			end

			-- index max
			if(colorIndex > #self.colorMod.colors) then
				colorIndex = #self.colorMod.colors
			end 

			-- index min
			local indexLessThanOne = false
			if(colorIndex < 1) then
				colorIndex = 1
				indexLessThanOne = true
			end 

			-- interpolate color with math lerp
			if(self.interpolateColor) then

				local bIndex = nil

				if(indexLessThanOne) then
					bIndex = colorIndex
				else
					bIndex = colorIndex + 1
				end

				if(bIndex > #self.colorMod.colors) then
					bIndex = #self.colorMod.colors
				end 

				self.colorIndex = colorIndex
				self.bIndex = bIndex

				self.box.color = Color:Lerp
				{
					a = Color:Get(self.colorMod.colors[colorIndex]),
					b = Color:Get(self.colorMod.colors[bIndex]),
					t = lerpValue
				}
			else

				self.colorIndex = colorIndex
				self.box.color = Color:Get(self.colorMod.colors[colorIndex])
			end

		end

		-- speed
		if(self.colorMod.type == "speed") then

		end 

	end 


	-- change size of particle over time
	Particle.scaleSpeedReduce = 0.001
	function object:Scale()

		self.scale.x = self.scale.x + (self.scale.xSpeed * Particle.scaleSpeedReduce)
		self.scale.y = self.scale.y + (self.scale.ySpeed * Particle.scaleSpeedReduce)

		-- use original width
		self.box.width = self.width * self.scale.x
		self.box.height = self.height * self.scale.y

		if(self.box.width < self.scale.min) then
			self.box.width = self.scale.min
		end 

		if(self.box.height < self.scale.min) then
			self.box.height = self.scale.min
		end 


	end 



	function object:Update()
		self:Move()
		self:Life()
		self:ColorModulate()
		self:Fade()
		self:RotDirection()
		self:Scale()
	end 

	function object:PrintDebugText()

		local colorIndex = self.colorIndex or "Not set"
		local bIndex = self.bIndex or "Not set"

		DebugText:TextTable
		{
			{text = "", obj = "Particle" },
			{text = "Particle"},
			{text = "--------------------"},
			{text = "Life: " .. self.life},
			{text = "LifePercentage: " .. self.lifePercentage},
			{text = "colorIndex: " .. colorIndex},
			{text = "bIndex: " .. bIndex},
		}

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

--------------------------
-- Particles
--------------------------

Particle.testType =
{
	life = 100,
	directionRange = {min = 0, max = 360},
	colorName = "random",
	widthMultiple = {start = 1, range = 6},
	heightMultiple = {start = 1, range = 6},
	angle = 0,
	fade = 1,
	fadeWithLife = true,
	spinRange = {min= 0, max= 10},
	xOffset = {min= -32, max= 32},
}

Particle.testType2 =
{
	--life = 200,
	lifeRange = {min = 200, max = 200},
	--directionRange = {min = 0,  max = 360},
	--directionList = {90, 0, 180, 270},
	directionList = {0,180}, --45, 135, 225, 315},
	rotDirection = {enabled = true, dir = 0, speedRange = {min = 300, max = 500}},
	colorName = "random",
	widthRange = {min= 8, max = 32},
	heightRange = {min= 8, max = 32},
	angle = 0,
	fade = 1,
	--inverseFade = true,
	scale = {xSpeed = -4, ySpeed = -4},
	fadeWithLife = true,
	spinRange = {min= 1, max= 20},
	speedRange = {min = 5, max = 10},
	speedDamp = 0.98,
	colorMod = 
	{
		type = "life",
		colors = Color.group.ice,
		weight = "end"
	},
	interpolateColor = true

}

Particle.testType3 =
{
	lifeRange = {min = 200, max = 200},
	directionList = {0, 90, 180, 270, 45, 135, 225, 315},
	rotDirection = {enabled = true, dir = 0, speedRange = {min = 300, max = 500}},
	colorName = "random",
	widthRange = {min= 8, max = 32},
	heightRange = {min= 8, max = 32},
	angle = 0,
	fade = 1,
	scale = {xSpeed = -200, ySpeed = -200},
	fadeWithLife = true,
	spinRange = {min= 0, max= 0},
	speedRange = {min = 0, max = 0},
	speedDamp = 0.98,
	colorMod = 
	{
		type = "life",
		colors = Color.group.ice,
		weight = "end"
	},
	interpolateColor = true

}

return Particle



-- all possible arguments
-- for a new particle
--[[
local particle = Particle:New
{
	color, colorName,
	interpolateColor,
	colorMod
	fade, fadeWithLife, 
	inverseFade
	direction, directionRange
	speed, speedRange, speedDamp
	damp, dampRange,
	spin, spinRange,
}
--]]



-- Notes
----------------------

-- curved directions ----------------- done
-- change direction over life ----------- done
-- change color based on life ------------done
-- rotDirection starts to other defined direction ----- done
-- fade over life table
-- change color based on speed 
-- 
-- direction list --------------------done
-- speed range-------------------- done
-- life range  ----------------------- done
-- speed damp -------------------------done
-- rot damp ------------------------done