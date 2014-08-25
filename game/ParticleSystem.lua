-- shoots out particles
-- omg son that shit is crazy

local ObjectUpdater = require("ObjectUpdater")
local Particle = require("Particle")
local Color = require("Color")


local ParticleSystem = {}



function ParticleSystem:New(data)

	local object = {}


	object.x = data.x or 200
	object.y = data.y or 200
	object.delay = data.delay or 10
	
	object.particleTable = data.particleTable or nil
	object.index = 1

	object.delay = data.delay or 0
	object.count = 0

	if(object.particleTable) then
		object.delay = object.particleTable.delays[1]
	end 

	function object:CreateParticle()
			
		local size = Random:MultipleOf(5, 4)

		local p = Particle:New
		{
			x = self.x,
			y = self.y,
			life = 100,
			xSpeed = 1,
			ySpeed = 1,
			color = Color:Get("blue"),
			width = size,
			height = size,
			angle = 0,
			fade = 3
		}

		return

	end

	function object:CreateParticleFromTable()

		self.particleTable.particles[self.index].x = self.x
		self.particleTable.particles[self.index].y = self.y
		local p = Particle:New(self.particleTable.particles[self.index])

		self.index = self.index + 1
		self.delay = self.particleTable.delays[self.index]


		-- done with all particles in list?
		if(self.index > #self.particleTable.particles) then

			-- reset back to beginning
			self.index = 1
			self.delay = self.particleTable.delays[self.index]

		end 


	end 


	function object:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "ParticleSystem"},
			{text = "Particle System"},
			{text = "----------------------"},
			{text = self.count}
		}
	end 

	function object:DelayUpdate()

		self.count = self.count + 1

		if(self.count > self.delay) then
			self.count = 0

			if(self.particleTable) then 
				if(#self.particleTable.particles > 0) then
					self:CreateParticleFromTable()
				end 
			else
				self:CreateParticle()	
			end 
			
		end 

	end 

	function object:Update()
		
		self:DelayUpdate()
		
		
	end 


	ObjectUpdater:Add{object}

	return object

end 




return ParticleSystem





-- Notes
-----------------------------------
-- this is dumb, i should make tables that determine when and what gets created
