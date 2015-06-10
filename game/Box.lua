-- Box.lua
-- box/cube/square graphic o

local SinCounter = require("SinCounter")
local Color = require("Color")
local Life = require("Life")
local Fade = require("Fade")
local Size = require("Size")
local Pos = require("Pos")
local Input = require("Input")
local Draw = require("Draw")

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
	o.Pos = Pos:New
	{
		x = data.x or Pos.defaultPos.x,
		y = data.y or Pos.defaultPos.y
	}

	o.xStart = o.Pos.x
	o.yStart = o.Pos.y
	o.speed = data.speed or 5
	o.move = false

	-- size
	o.Size = Size:New
	{
		width = data.width or 32,
		height = data.height or 32
	}

	-- color
	o.color = data.color or Color:Get("white")
	
	-- draw
	o.fill = data.fill or true
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

	-- parent
	o.parent = data.parent or nil
	o.useParentPos = data.useParentPos or false

	-------------------------
	-- Components
	-------------------------
	local life = data.life or 100
	local drain = data.drain or false


	o.Life = Life:New
	{
		life = data.life,
		maxLife = data.maxLife,
		drain = drain,
		parent = o
	}


	o.Fade = Fade:New
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

	o.Input = Input:New{}

	-- new draw component -> seems to work fine
	local defaultDraw =
	{
		parent = o,
		layer = "Objects",
		depth = "Objects",
	}

	o.Draw = Draw:New(data.Draw or defaultDraw)

	-------------
	-- Functions
	-------------

	function o:Update()
		self:Spin() 
		self:Scale()
		self:Flip()
	end 

--[[
	function o:SubmitDraw()
		DrawList:Submit
		{
			o = self,
			depth = 1
		}
	end 
--]]

	function o:DrawCall()

		if(self.draw == false) then
			return
		end

		if(self.fill == false) then
			love.graphics.setWireframe(true)
		end 

		love.graphics.setColor(Color:AsTable(self.color))

		-- pos
		local x = nil
		local y = nil
		local z = nil

		if(self.parent and self.useParentPos ) then
			x = self.parent.Pos.x
			y = self.parent.Pos.y
			z = self.parent.Pos.z
		else
			x = self.x
			y = self.y
			z = self.z
		end 

		if(self.rotatable) then
			love.graphics.push()
			love.graphics.translate(self.Pos.x + (self.pivot.x * self.Size.width), self.Pos.y + (self.pivot.y * self.Size.height))
			love.graphics.scale(self.xScale, self.yScale)
			love.graphics.rotate(self.angle)
			love.graphics.translate(-self.Pos.x - (self.pivot.x * self.Size.width), -self.Pos.y - (self.pivot.y * self.Size.height))
			love.graphics.rectangle("fill", self.Pos.x, self.Pos.y - (self.z or 0), self.Size.width, self.Size.height)
			love.graphics.pop()
		else 
			love.graphics.rectangle("fill", self.Pos.x, self.Pos.y - (self.z or 0), self.Size.width, self.Size.height)
		end 

		if(self.fill == false) then
			love.graphics.setWireframe(false)
		end 

	end 


	function o:Move()

		if(self.move == false) then
			return
		end

		if(love.keyboard.isDown(self.keys.left)) then
			self.Pos.x = self.Pos.x - self.speed
		end 

		if(love.keyboard.isDown(self.keys.right)) then
			self.Pos.x = self.Pos.x + self.speed
		end 

		if(love.keyboard.isDown(self.keys.up)) then
			self.Pos.y = self.Pos.y - self.speed
		end 

		if(love.keyboard.isDown(self.keys.down)) then
			self.Pos.y = self.Pos.y + self.speed
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

	function o:PrintDebugText()

		local life = self.Life and self.Life.life or 0

		DebugText:TextTable
		{
			{text = "", obj = "Box" },
			{text = "Box"},
			{text = "---------------------"},
			{text = "Pos: {" .. self.Pos.x .. "," .. self.Pos.y .. "}"},
			{text = "Life: " .. self.Life.life },
			{text = "Fade: " .. self.Fade.fade} 
		}

	end 

	
	function o:Destroy()
		if(self.xFlip) then
			ObjectUpdater:Destroy(self.xFlip)
		end 

		if(self.yFlip) then
			ObjectUpdater:Destroy(self.yFlip)
		end 

	end 

	--[[
	o.Input = Input:New
	{
		{"a", "press", 
		func = function()
			o.Pos:Move{x = 10}
		end 
		}
	}
	--]]



	ObjectUpdater:Add{o}

	return o

end 

ObjectUpdater:AddStatic(Box)

return Box