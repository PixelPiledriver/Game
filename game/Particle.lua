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
			{"directionRange", "angleRangeToVector"}
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
	object.rotDirectionEnabled = data.rotDirectionEnable or false
	object.rotDirection = data.rotDirection or 0
	object.rotDirectionSpeed = data.rotDirectionSpeed or 0

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

			--print(lifePercentage)
			--print(#self.colorMod.colors)
			--print(math.floor(#self.colorMod.colors * lifePercentage))

			local colorIndex = math.floor(#self.colorMod.colors * lifePercentage) + 1
			local lerpValue = (#self.colorMod.colors * lifePercentage) + 1 - colorIndex 


			if(colorIndex > #self.colorMod.colors) then
				colorIndex = #self.colorMod.colors
			end 

			colorIndex = (#self.colorMod.colors + 1) - colorIndex

			if(self..interpolateColor) the
				self.box.color = Color:Lerp
				{
					a = Color:Get(self.colorMod.colors[colorIndex]),
					b = Color:Get()
				}
			else
				self.box.color = Color:Get(self.colorMod.colors[colorIndex])
			end
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
	widthMultiple = {start = 1, range = 6},
	heightMultiple = {start = 1, range = 6},
	angle = 0,
	fade = 1,
	fadeWithLife = true,
	spinRange = {min= 0, max= 10},
	xOffset = {min= -32, max= 32}
}

Particle.testType2 =
{
	--life = 200,
	lifeRange = {min = 50, max = 300},
	directionRange = {min = 0,  max = 360},
	colorName = "random",
	widthRange = {min= 8, max = 32},
	heightRange = {min= 8, max = 32},
	angle = 0,
	fade = 1,
	fadeWithLife = true,
	spinRange = {min= 1, max= 20},
	speedRange = {min = 1, max = 3},
	speedDamp = 0.98,
	colorMod = 
	{
		type = "life",
		colors = {"white", "orange", "red", "darkRed"},
	},
	interpolateColor = true


}


-- all possible arguments
--[[
	
	{
		color, colorName,
		fade, fadeWithLife, inverseFade
		direction, directionRange
		speed, speedRange,
		damp, dampRange,
	}


--]]

return Particle




-- Notes
----------------------

-- curved directions 
-- change direction over life 
-- change color over life -- working on it
-- speed range-------------------- done
-- life range  ----------------------- done
-- speed damp -------------------------done
-- rot damp ------------------------done