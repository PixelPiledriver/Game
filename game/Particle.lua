-- Particle
-- basic shit for explosions
-- KERPOW


local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")
local Color = require("Color")
local Random = require("Random")
local Value = require("Value")
local Shape = require("Shape")




local Particle = {}



function Particle:New(data)

	local object = {}

	-----------------------------
	-- Other
	-----------------------------
	object.name = data.name or "???"
	object.oType = "Particle"
	object.dataType = "Game Object"


	-----------------------------
	-- Pos
	-----------------------------
	object.xOffset = data.xOffset and data.xOffset.Get() or 0
	object.x = data.x + object.xOffset
	object.yOffset = data.yOffset and data.yOffset.Get() or 0
	object.y = data.y + object.yOffset or 0

	if(data.verts) then
		local vert = data.verts.Get()
		object.x = data.x + vert[1] * data.vertSpace
		object.y = data.y + vert[2] * data.vertSpace
	end 

	-----------------------------
	-- Size
	-----------------------------
	object.width = data.width.Get()
	object.height = data.height.Get()

	----------------------------
	-- Scale
	----------------------------
	object.scale = {}
	object.scale.xSpeed = data.scale.xSpeed
	object.scale.ySpeed = data.scale.ySpeed
	object.scale.x = data.scale.x and data.scale.x.Get() or 1
	object.scale.y = data.scale.y and data.scale.y.Get() or 1
	object.scale.min = 0
	object.scale.max = data.scale.max or 10

	----------------------------
	-- Flip
	----------------------------
	object.xFlip = data.xFlip and data.xFlip:Get() or 0
	object.yFlip = data.yFlip and data.yFlip:Get() or 0
	object.xFlipDamp = data.xFlipDamp and data.xFlipDamp:Get() or 0
	object.yFlipDamp = data.yFlipDamp and data.yFlipDamp:Get() or 0

	----------------------------
	-- Spin
	----------------------------
	object.spin = data.spin and data.spin.Get() or 0
	object.angle = data.angle and data.angle.Get() or 0
	object.spinDamp = data.spinDamp and data.spinDamp.Get() or 1

	-----------------
	-- Color
	-----------------
	local color = data.color and data.color.Get() or "white"

	-- color interpolation
	object.interpolateColor = data.interpolateColor or false
	object.colorMod = data.colorMod or nil

	if(object.colorMod) then
		object.colors = {}
		object.colors = data.colors.Get()
		color = object.colors[1]
	end 


	-----------------------------
	-- Fill
	-----------------------------
	local fill = data.fill and data.fill.Get()
	
	if(fill == nil) then
		object.fill = true
	else 
		object.fill = fill
	end 
	
	-----------------------------
	-- Box
	-----------------------------

	object.box = Box:New
	{
		x = object.x,
		y = object.y,
		color = Color:Get(color),
		width = object.width * object.scale.x,
		height = object.height * object.scale.y,
		fill = object.fill,
		angle = object.angle,
		rotatable = true,
		spin = object.spin,
		draw = true,
		xFlip = object.xFlip,
		yFlip = object.yFlip,
	}

	--object.shape = Shape:Get("cross")

	


	-----------------------------
	-- Fade
	-----------------------------

	object.fade = data.fade or 0
	object.fadeWithLife = data.fadeWithLife or false

	-- inverse
	object.inverseFade = data.inverseFade and data.inverseFade.Get() or false
	if(object.inverseFade == true) then
		object.box.color[4] = 0 
	end 

	object.box.color[4] = data.alpha and data.alpha.Get() or object.box.color[4]
	object.alphaStart = object.box.color[4]

	

	-------------------------
	-- Direction
	-------------------------
	-- sort x and y speeds from options in data table
	local dir = data.direction.Get() or {x = 1, y = 0}

	-- direct setting of x and y components
	if(data.xSpeed and data.ySpeed) then
		dir.x = data.xSpeed or 0
		dir.y = data.ySpeed or 0
	end 

	object.xSpeed = dir.x
	object.ySpeed = dir.y

	-----------------------------
	-- Rotational Direction
	-----------------------------
	if(data.rotDirection) then
		object.rotDirection = {}
		object.rotDirection.angle = math.deg(Math:VectorToAngle(dir))
		object.rotDirection.speed =  data.rotDirection.Get()
	end

	

	if(data.rotDirectionLerp) then
		object.rotDirectionLerp = {}
		object.rotDirectionLerp.speed = data.rotDirectionLerp.speed.Get()
		object.rotDirectionLerp.angle = data.rotDirectionLerp.angle.Get()
		object.rotDirectionLerp.t = 0
	end

	------------------------
	-- Speed
	------------------------
	object.speed = data.speed and data.speed.Get() or 1
	object.speedDamp = data.speedDamp and data.speedDamp.Get() or 1

	-------------------------
	-- Life
	-------------------------
	object.life = data.life.Get() or 100
	object.lifeStart = object.life
	object.lifeSpeed = data.lifeSpeed.Get() or 1
	


	

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

		if(self.box) then
			self.box.x = self.x
			self.box.y = self.y
		end 

	
		if(self.shape) then 
			self.shape.x = self.x
			self.shape.y = self.y
			self.shape:SetPos()
		end


		self.speed = self.speed * self.speedDamp
	end 

	function object:RotDirection()
		
		if(self.rotDirection == nil) then
			return
		end 

		if(self.rotDirectionLerp == nil) then 
			self.rotDirection.angle = self.rotDirection.angle + self.rotDirection.speed * 0.01
		else
			self.rotDirection.angle = Math:Lerp
			{
				a = self.rotDirection.angle, 
				b = self.rotDirectionLerp.angle, 
				t = self.rotDirectionLerp.t
			}

			self.rotDirectionLerp.t = self.rotDirectionLerp.t + self.rotDirectionLerp.speed 
		end

		local dir = Math:AngleToVector(self.rotDirection.angle)


		dir = Math:UnitVector(dir)
		self.xSpeed = dir.x
		self.ySpeed = dir.y

	end 


	function object:Life()
		self.life = self.life - self.lifeSpeed

		if(self.life <= 0) then

			self.life = 0

			ObjectUpdater:Destroy(self.box)
			
			if(self.shape) then
				ObjectUpdater:Destroy(self.shape)
			end

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

			local value = self.alphaStart * lifePercentage
			
			
			if(self.inverseFade == true) then
				value = 255 - value
				
				--value = self.alphaStart - (value * (self.alphaStart/255))
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
				colorIndex = math.floor(#self.colors * lifePercentage)
				lerpValue = (#self.colors * lifePercentage) - colorIndex 
			else
				colorIndex = math.floor(#self.colors * lifePercentage) + 1
			end

			-- color index weight
			if(self.colorMod.weight == "end") then
				colorIndex = colorIndex + 1
			elseif(self.colorMod.weight == "start") then
				colorIndex = colorIndex
			end

			-- index max
			if(colorIndex > #self.colors) then
				colorIndex = #self.colors
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

				if(bIndex > #self.colors) then
					bIndex = #self.colors
				end 

				self.colorIndex = colorIndex
				self.bIndex = bIndex

				self.box.color = Color:Lerp
				{
					a = Color:Get(self.colors[colorIndex]),
					b = Color:Get(self.colors[bIndex]),
					t = lerpValue
				}
			else

				self.colorIndex = colorIndex
				self.box.color = Color:Get(self.colors[colorIndex])
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

	function object:Spin()
		self.box.spin = self.box.spin * self.spinDamp
	end 

	function object:Flip()
	end

	function object:Update()
		self:Move()
		self:Life()
		self:ColorModulate()
		self:Fade()
		self:RotDirection()
		self:Scale()
		self:Spin()
		self:Flip()
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

	function object:Destroy()

		if(self.box) then
			ObjectUpdater:Destroy(self.box)
		end 

		if(self.shape) then
			ObjectUpdater:Destroy(self.shape)
		end
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

Particle.grid =
{
	life = Value:Range{min = 200, max = 200},
	width = Value:Range{min= 8, max = 32},
	height = Value:Random{values = {2, 22, 34, 12}},
	spin = Value:Range{min = 10, max = 20},
	spinDamp = Value:FloatRange{min = 0.99, max = 1},
	speed = Value:FloatRange{min = 0, max = 1},
	speedDamp = Value:Value(0.9),
	
	angle = Value:Value(0),
	color = Value:Value("random"),
	verts = Value:Random
	{
		values = 
		{
			{-1,1}, {1,1}, {0,-1},
		}
	},
	vertSpace = 32,
	--inverseFade = Value:Random{values = {true}},
	fill = Value:Random{values = {false, true}},
	direction= Value:RandomAngleToVector{values = {0, 90, 180,270, 45, 135, 225, 315}},
	
	fadeWithLife = true,
	alpha = Value:Range{min = 10, max = 120},

	scale = 
	{
		xSpeed = -10, 
		ySpeed = -10, 
		x = Value:FloatRange{min = 1, max = 2}, 
		y = Value:FloatRange{min = 1, max = 2}, 
	},
	
	colorMod = 
	{
		type = "life",
		weight = "end"
	},
	
	colors = Value:Random
	{
		values = 
		{
			Color.group.ice,	
		}
	},

	interpolateColor = true
}

Particle.fire1 =
{
	life = Value:Range{min = 200, max = 200},
	lifeSpeed = Value:Range{min = 1, max = 5},
	width = Value:Range{min= 8, max = 32},
	height = Value:Random{values = {2, 22, 34, 12}},
	spin = Value:Range{min = 10, max = 20},
	spinDamp = Value:FloatRange{min = 0.99, max = 1},
	speed = Value:FloatRange{min = 0, max = 3},
	speedDamp = Value:FloatRange{min = 0.93, max = 0.99},
	angle = Value:Value(0),
	color = Value:Value("random"),
	xOffset = Value:Range{min = 0, max = 0},---love.graphics.getWidth()/2, max = love.graphics.getWidth()/2},
	yOffset = Value:Range{min = 0, max = 0},---love.graphics.getHeight()/2, max = love.graphics.getHeight()/2},
	inverseFade = Value:Random{values = {false}},
	fill = Value:Random{values = {false, true}},
	direction= Value:RandomAngleToVector{values = {0, 90, 180}}, --45, 135, 225, 315},
	rotDirection = Value:Range{min = -500, max = 500},
	rotDirectionLerp = {speed = Value:Value(0.005), angle = Value:Value(270)},
	fadeWithLife = true,
	xFlip = Value:FloatRange{min = 0, max = 0.4},
	yFlip = Value:FloatRange{min = 0, max = 0.4},
	xFlipDamp = Value:FloatRange{min = 0.92, max = 0.98},
	yFlipDamp = Value:FloatRange{min = 0.92, max = 0.98},



	scale = 
	{
		xSpeed = -4, 
		ySpeed = -4, 
		x = Value:FloatRange{min = 0.3, max = 1}, 
		y = Value:FloatRange{min = 0.3, max = 1}, 
	},
	
	colorMod = 
	{
		type = "life",
		weight = "end"
	},
	
	colors = Value:Random
	{
		values = 
		{
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire2,
		}
	},

	interpolateColor = true
}


Particle.flipper =
{
	life = Value:Range{min = 200, max = 200},
	lifeSpeed = Value:Range{min = 1, max = 5},
	width = Value:Range{min= 8, max = 32},
	height = Value:Random{values = {2, 22, 34, 12}},
	spin = Value:Range{min = 10, max = 20},
	spinDamp = Value:FloatRange{min = 0.99, max = 1},
	speed = Value:FloatRange{min = 0, max = 3},
	speedDamp = Value:FloatRange{min = 0.93, max = 0.99},
	angle = Value:Value(0),
	color = Value:Value("random"),
	xOffset = Value:Range{min = 0, max = 0},---love.graphics.getWidth()/2, max = love.graphics.getWidth()/2},
	yOffset = Value:Range{min = 0, max = 0},---love.graphics.getHeight()/2, max = love.graphics.getHeight()/2},
	inverseFade = Value:Random{values = {false}},
	fill = Value:Random{values = {false, true}},
	direction= Value:RandomAngleToVector{values = {0, 90, 180}}, --45, 135, 225, 315},
	rotDirection = Value:Range{min = -500, max = 500},
	rotDirectionLerp = {speed = Value:Value(0.005), angle = Value:Value(270)},
	fadeWithLife = true,

	flip = Value:Value(1),

	scale = 
	{
		xSpeed = -4, 
		ySpeed = -4, 
		x = Value:FloatRange{min = 0.3, max = 1}, 
		y = Value:FloatRange{min = 0.3, max = 1}, 
	},
	
	colorMod = 
	{
		type = "life",
		weight = "end"
	},
	
	colors = Value:Random
	{
		values = 
		{
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire,
			Color.group.fire2,
		}
	},

	interpolateColor = true
}






return Particle



-- this whole list of shit might become void
-- if Value.lua works correctly
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
-- vertex positions for making shapes and pixel art
-- starting alpha
-- direction list --------------------done
-- speed range-------------------- done
-- life range  ----------------------- done
-- speed damp -------------------------done
-- rot damp ------------------------done
-- flip in z space rotation --> use the scale component and change it to work








--[[

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


Particle.testType3 =
{
	life = Value:Range{min = 200, max = 200},
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




Particle.testType4 =
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
	spin = Value:Range{min = 1, max = 20},
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

--]]


------------------------------
-- Junk Code
------------------------------

	--[[
	local spin = DataPass:Options
	{
		data = data,
		options =
		{
			{"spin", "value"},
			{"spinRange", "range"}
		}
	}
	--]]
