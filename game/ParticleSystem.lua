-- shoots out particles
-- omg son that shit is crazy

local ObjectUpdater = require("ObjectUpdater")
local Particle = require("Particle")
local Color = require("Color")


local ParticleSystem = {}



function ParticleSystem:New(data)

	local object = {}


	object.name = data.name or "???"
	object.type = "particleSystem"

	object.x = data.x or 200
	object.y = data.y or 200


	object.followMouse = data.followMouse or false
	
	object.particleTable = data.particleTable or nil
	for i=1, #object.particleTable do 
		object.particleTable[i].count = 0
	end 


	object.index = 1

	object.count = 0




	function object:CreateParticleFromTable()

		self.particleTable[self.index].x = self.x
		self.particleTable[self.index].y = self.y
		local p = Particle:New(self.particleTable[self.index])

		self.index = self.index + 1
		self.delay = self.particleTable.delays[self.index]


		-- done with all particles in list?
		if(self.index > #self.particleTable) then

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

	function object:DelayTimer()

		self.count = self.count + 1

		if(self.count > self.delay) then
			self.count = 0

			if(self.particleTable) then 
				if(#self.particleTable > 0) then
					self:CreateParticleFromTable()
				end 
			else
				self:CreateParticle(self.particleTable[i].particle)	
			end 
			
		end 

	end 

	function object:ParticleUpdate()
		for i=1, #self.particleTable do
			self.particleTable[i].count = self.particleTable[1].count + 1

			if(self.particleTable[i].count >= self.particleTable[i].delay) then
				self.particleTable[i].particle.x = self.x
				self.particleTable[i].particle.y = self.y
				local p = Particle:New(self.particleTable[i].particle)		
				self.particleTable[i].count = 0
			end 	
		
		end
	end

	function object:FollowMouse()
		if(self.followMouse == nil) then
			return
		end 

		self.x = love.mouse.getX()
		self.y = love.mouse.getY()

	end

	function object:Update()
		
		self:ParticleUpdate()
		self:FollowMouse()
	end 


	ObjectUpdater:Add{object}

	return object

end 

-- Particle Systems

local delay = 0
ParticleSystem.systems = {}


ParticleSystem.systems.objCount =
{
	name = "objCounter",
	x = love.graphics.getWidth() * 0.5 - 32,
	y = love.graphics.getHeight() * 0.5,
	followMouse = true,

	particleTable = 
	{
		{particle = Particle.fire1, delay = 100},
	}
}


ParticleSystem.systems.fire1 = 
{
	x = love.graphics.getWidth() * 0.5 - 32,
	y = love.graphics.getHeight() * 0.5,
	followMouse = true,
	particleTable = 
	{
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},
		{particle = Particle.fire1, delay = delay},

	
	}

}

ParticleSystem.systems.grid1 = 
{
	x = love.graphics.getWidth() * 0.5 - 32,
	y = love.graphics.getHeight() * 0.5,
	followMouse = true,
	particleTable = 
	{
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},
		{particle = Particle.grid, delay = delay},


	}
}

return ParticleSystem









-- Notes
---------------------------------

-- change structure from:
-- particles = {p, p2, ...}
-- delays = {#, #, ...}

-- to:
-- particles =
-- {
--	{particle = p, delay = #, count = 0},
--	{particle = p2, delay = #, count = 0},
--	{particle = p3, delay = #, count = 0},
--	...
--	...
-- }

-- this way particles 