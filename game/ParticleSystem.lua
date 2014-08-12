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
	object.pList = {}
	object.delay = data.delay or 10
	object.count = 0


	function object:CreateParticle()
		
		local p = Particle:New
		{
			x = self.x,
			y = self.y,
			life = 100,
			xSpeed = 1,
			ySpeed = 1,
			color = Color:GetColor("green"),
			width = 10,
			height = 10
		}

		return

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

	function object:Update()
		
		self.count = self.count + 1
		if(self.count > self.delay) then
			self.count = 0
			self:CreateParticle()
		end 

		
		
	end 


	ObjectUpdater:Add{object}

	return object

end 




return ParticleSystem





-- Notes
-----------------------------------
-- this is dumb, i should make tables that determine when and what gets created
