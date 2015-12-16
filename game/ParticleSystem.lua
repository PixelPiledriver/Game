-- ParticleSystem.lua

-- Purpose
-----------------------------------------------
-- shoots out particles
-- omg son that stuff is crazy

---------------
-- Requires
---------------
local Particle = require("Particle")
local Color = require("Color")

--------------------------------------------------------------------------------------

local ParticleSystem = {}

---------------
-- Static Info
---------------

ParticleSystem.Info = Info:New
{
	objectType = "ParticleSystem",
	dataType = "Effects",
	structureType = "Static"
}

---------------------
-- Static Functions
---------------------

function ParticleSystem:New(data)

	local o = {}

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "ParticleSystem",
		dataType = "Effects",
		structureType = "Object"
	}

	o.x = data.x or 200
	o.y = data.y or 200


	o.followMouse = data.followMouse or false
	
	o.particleTable = data.particleTable or nil
	for i=1, #o.particleTable do 
		o.particleTable[i].count = 0
	end 


	o.index = 1

	o.count = 0



	function o:CreateParticleFromTable()

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


	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "ParticleSystem"},
			{text = "Particle System"},
			{text = "----------------------"},
			{text = self.count}
		}
	end 

	function o:DelayTimer()

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

	function o:ParticleUpdate()
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

	function o:FollowMouse()
		if(self.followMouse == nil) then
			return
		end 

		self.x = love.mouse.getX()
		self.y = love.mouse.getY()

	end

	function o:Update()
		
		self:ParticleUpdate()
		self:FollowMouse()
	end 


	function o:Destroy()
		ObjectManager:Destroy(self.Info)
	end

	-------------
	-- End
	-------------

	ObjectManager:Add{object}

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

ParticleSystem.systems.flip = 
{
	x = love.graphics.getWidth() * 0.5 - 32,
	y = love.graphics.getHeight() * 0.5,
	followMouse = true,
	particleTable = 
	{
		{particle = Particle.flipper, delay = delay},
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

-- BUG
-- apparently particles are broken
-- need to fix that stuff
-- wtf