-- Box.lua
-- box/cube/square graphic o

local ObjectUpdater = require("ObjectUpdater")
local SinCounter = require("SinCounter")
local Life = require("Life")
local Fade = require("Fade")


local Box = {}

-------------------
-- Static Vars
-------------------

Box.name = "Box"
Box.oType = "Static"
Box.dataType = "Graphics Constructor"



-- create instance
function Box:New(data)

	----------
	-- Create
	----------
	local o = {}

	-- other
	o.name = data.name or "..."
	o.oType = "Box"
	o.dataType = "Graphics"

	-- position
	o.x = data.x or 0
	o.y = data.y or 0
	o.xStart = o.x
	o.yStart = o.y
	o.speed = data.speed or 5
	o.move = false

	-- size
	o.width = data.width or 32
	o.height = data.height or 32

	-- color
	o.color = data.color or {255,255,255,255}
	
	-- draw
	o.fill = data.fill or false
	o.draw = data.draw or true

	-- rotation
	o.angle = data.angle or 0
	o.pivot = data.pivot or {x = 0.5, y = 0.5} -- 0 to 1 range
	o.spin = data.spin or 0

	if(data.spin) then
		o.rotatable = true
	else
		o.rotatable = false
	end 

	-- scale
	o.xScale = data.xScale or 1
	o.yScale = data.yScale or 1
	o.xScaleStatic = o.xScale
	o.yScaleStatic = o.yScale
	o.xScaleSpeed = data.xScaleSpeed or 0
	o.yScaleSpeed = data.yScaleSpeed or 0

	if(data.xScale or data.yScale) then
		o.scaleable = true
	else
		o.scaleable = false
	end 

	-- flip
	o.xFlip = SinCounter:New
	{
		speed = data.xFlip or 0,
		damp = 0.95
	}

	o.yFlip = SinCounter:New
	{
		speed = data.yFlip or 0,
		damp = 0.95
	}

	-------------------------
	-- Components
	-------------------------
	o.lifeComp = Life:New
	{
		life = data.life,
		maxLife = data.maxLife,
		drain = data.drain,
		parent = o
	}

	o.fadeComp = Fade:New
	{
		active = false,
		parent = o
	}


	-- remove this shit as a component
	-- controls
	o.keys =
	{
		left = data.keys and data.keys.left or "a",
		right = data.keys and data.keys.right or "d",
		up = data.keys and data.keys.up or "w",
		down = data.keys and data.keys.down or "s",
		rotLeft = data.rotatable and data.keys and data.keys.rotLeft or "q",
		rotRight = data.rotatable and data.keys and data.keys.rotLeft or "e",
	}


	-------------
	-- Functions
	-------------

	function o:Draw()

		if(self.draw == false) then
			return
		end

		if(self.fill == false) then
			love.graphics.setWireframe(true)
		end 

		love.graphics.setColor(self.color)

		if(self.rotatable) then
			love.graphics.push()
			love.graphics.translate(self.x + (self.pivot.x * self.width), self.y + (self.pivot.y * self.height))
			love.graphics.scale(self.xScale, self.yScale)
			love.graphics.rotate(self.angle)
			love.graphics.translate(-self.x - (self.pivot.x * self.width), -self.y - (self.pivot.y * self.height))
			love.graphics.rectangle("fill", self.x, self.y - (self.z or 0), self.width, self.height)
			love.graphics.pop()
		else 
			love.graphics.rectangle("fill", self.x, self.y - (self.z or 0), self.width, self.height)
		end 

		if(self.fill == false) then
			love.graphics.setWireframe(false)
		end 

	end 

	-- only used for press and release
	function o:Input(key)

	end 

	function o:Move()

		if(self.move == false) then
			return
		end

		if(love.keyboard.isDown(self.keys.left)) then
			self.x = self.x - self.speed
		end 

		if(love.keyboard.isDown(self.keys.right)) then
			self.x = self.x + self.speed
		end 

		if(love.keyboard.isDown(self.keys.up)) then
			self.y = self.y - self.speed
		end 

		if(love.keyboard.isDown(self.keys.down)) then
			self.y = self.y + self.speed
		end

		

	end


	-- spin controls
	function o:Rotate()

		if(love.keyboard.isDown(self.keys.rotLeft)) then
			self.spin = self.spin - 0.01
		end 

		if(love.keyboard.isDown(self.keys.rotRight)) then
			self.spin = self.spin + 0.01 
		end 

	end 

	-- only used for down
	function o:RepeatedInput()

		self:Rotate()
		self:Move()

	end 


	-- rotation velocity
	function o:Spin()
		self.angle = self.angle + self.spin * 0.01
	end 

	-- flip like paper
	function o:Flip()

		--self.xScale = self.xScaleStatic * self.xFlip:Get()
		

		if(self.xFlip) then
			self.xScale = self.xFlip:Get()
		end

		if(self.yFlip) then
			self.yScale = self.yFlip:Get()
		end
		--print(self.xScale)


		--[[
		self.xScale = Math:Lerp
		{
			a = -self.xScaleStatic,
			b = self.xScaleStatic,
			t = self.xFlip:Get()
		}

		print(self.xScale)
		--]]

		--self.yScale = self.yFlip:Get()
	end

	function o:Scale()
		self.xScale = self.xScale + (self.xScaleSpeed * 0.01)
		self.yScale = self.yScale + (self.yScaleSpeed * 0.01)
		self.xScaleStatic = self.xScale
		self.yScaleStatic = self.yScale
	end 

	function o:Update()
		self:Spin() 
		self:Scale()
		self:Flip()
	end 

	
	function o:Destroy()
		if(self.xFlip) then
			ObjectUpdater:Destroy(self.xFlip)
		end 

		if(self.yFlip) then
			ObjectUpdater:Destroy(self.yFlip)
		end 

	end 

	ObjectUpdater:Add{o}

	return o

end 

ObjectUpdater:AddStatic(Box)

return Box