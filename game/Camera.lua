-- Camera.lua
-- main camera
-- in the future will be able to create multiple cameras
-- but just work with one for now

local Input = require("Input")

local Camera = {}

---------------------
-- Static Vars
---------------------
Camera.name = "Camera"
Camera.oType = "Static"
Camera.dataType = "View Constructor"


Camera.pos = {x=0, y=0}
Camera.rot = 0
Camera.zoom = {x=1, y=1}

Camera.zoomSpeed = 0.01
Camera.moveSpeed = 2
Camera.rotSpeed = 0.01

Camera.moveNodes = {}
Camera.moveIndex = 0
Camera.maxShake = 100

Camera.shake =
{
	xMax = 0,
	yMax = 0,
	xOffset = 0,
	yOffset = 0,
	reduce = 0,
} 


Camera.keys =
{
	left = "l",
	right = "'",
	up = "p",
	down = ";",
	zoomIn = "[",
	zoomOut = "o",
	rotLeft = ",",
	rotRight = "/",
	shakeSoft = "z",
}


-- need to make camera an object created by constructor
function Camera:New()
	local o = {}

	--------------
	-- Create
	--------------

	o.name = "cam"
	o.oType = "Camera Static"
	o.dataType = "Static"

	o.pos = {x=0, y=0}
	o.rot = 0
	o.zoom = {x=1, y=1}

	o.zoomSpeed = 0.01
	o.moveSpeed = 2
	o.rotSpeed = 0.01

	o.moveNodes = {}
	o.moveIndex = 0
	o.maxShake = 100

	o.shake =
	{
		xMax = 0,
		yMax = 0,
		xOffset = 0,
		yOffset = 0,
		reduce = 0,
	} 

	o.keys =
	{
		left = "l",
		right = "'",
		up = "p",
		down = ";",
		zoomIn = "[",
		zoomOut = "o",
		rotLeft = ",",
		rotRight = "/",
		shake1 = "z",
	}

	-----------------
	-- Functions
	-----------------

	function o:Update()
		self:UpdateShake()
		self:UpdateMoveNodes()
	end 


	-- manually control the camera
	-- test stuff
	function o:RepeatedInput()
		-- move
		if(love.keyboard.isDown(self.keys.left)) then
			self.pos.x = self.pos.x + self.moveSpeed
		end 

		if(love.keyboard.isDown(self.keys.right)) then
			self.pos.x = self.pos.x - self.moveSpeed
		end 

		if(love.keyboard.isDown(self.keys.up)) then
			self.pos.y = self.pos.y + self.moveSpeed
		end 
		
		if(love.keyboard.isDown(self.keys.down)) then
			self.pos.y = self.pos.y - self.moveSpeed
		end 

		-- zoom
		if(love.keyboard.isDown(self.keys.zoomIn)) then
			self.zoom.x = self.zoom.x + self.zoomSpeed
			self.zoom.y = self.zoom.y + self.zoomSpeed
		end 

		if(love.keyboard.isDown(self.keys.zoomOut)) then
			self.zoom.x = self.zoom.x - self.zoomSpeed
			self.zoom.y = self.zoom.y - self.zoomSpeed
		end 

		-- rotate
		if(love.keyboard.isDown(self.keys.rotLeft)) then
			self.rot = self.rot + self.rotSpeed
		end 

		if(love.keyboard.isDown(self.keys.rotRight)) then
			self.rot = self.rot - self.rotSpeed
		end 

		-- shake
		if(love.keyboard.isDown(self.keys.shake1)) then
			self:Shake{xMax = 10, yMax= 10}
		end
		-- node 
	end

	-- draw all objects based on camera transformation
	function o:Draw()

		local pos = self:CalculatePos()


		local obj = 
		{
			x = love.graphics.getWidth() / 2,
			y = love.graphics.getHeight() / 2
		}

		love .graphics.push()

		love.graphics.translate(obj.x + self.pos.x, obj.y + self.pos.y)
		love.graphics.rotate(self.rot)
		love.graphics.scale(self.zoom.x, self.zoom.y)


		love.graphics.translate(-obj.x + self.pos.x, -obj.y + self.pos.y)

	end 


	function o:AfterDraw()

		local obj = 
		{
			x = love.graphics.getWidth() / 2,
			y = love.graphics.getHeight() / 2
		}
		love.graphics.translate(obj.x, obj.y)
	
		love.graphics.pop()

	end 

	-- move camera from current pos
	-- {x,y}
	function o:Move(data)
		self.pos.x = self.pos.x + (data.x or 0)
		self.pos.y = self.pos.y + (data.y or 0)
	end


	-- set camera pos directly
	-- {x,y}
	function o:SetPos(data)
		self.pos.x = data.x or self.pos.x
		self.pos.y = data.y or self.pos.y
	end 

	function o:CalculatePos()
		local pos = {x=0, y=0}

		pos.x = self.pos.x + self.shake.xOffset
		pos.y = self.pos.y + self.shake.yOffset

		return pos
	end 

	-- set the shake table
	-- should add support for multiple tables
	-- {x, y, duration}
	function o:Shake(data)
		self.shake.xMax = data.xMax or 1
		self.shake.yMax = data.yMax or 1
		self.shake.reduce = data.reduce or 0.98

		self.shake.xOffset = 0
		self.shake.yOffset = 0

	end 

	function o:AddShake(data)
		self.shake.xMax = self.shake.xMax + data.x
		self.shake.yMax = self.shake.yMax + data.y

		self.shake.reduce = data.reduce or 0.98

	end

	-- shakes the camera based on the current shake table
	function o:UpdateShake()

		-- offset camera
		self.shake.xOffset = love.math.random(-self.shake.xMax, self.shake.xMax)
		self.shake.yOffset = love.math.random(-self.shake.yMax, self.shake.yMax)

		-- reduce shake
		self.shake.xMax = self.shake.xMax * self.shake.reduce
		self.shake.yMax = self.shake.yMax * self.shake.reduce


		-- need to add duration into this
	end 


	-- i dont think this actually does anything
	-- or has been tested yet
	function o:SetMoveNode(data)
		local node = {}
		node.x = data.x or self.pos.x
		node.y = data.y or self.pos.y

		self.targetNodes[#self.targetNodes + 1] = node
	end 

	function o:UpdateMoveNodes()
		if(#self.moveNodes == 0) then
			return 
		end 

		self.pos.x = self.pos.x + (self.moveNodes[self.moveIndex].x - self.pos.x)
		self.pos.y = self.pos.y + (self.moveNodes[self.moveIndex].y - self.pos.y)

	end 


	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Camera" },
			{text = "Camera"},
			{text = "-------------------"},
			{text = "X: " .. self.pos.x},
			{text = "Y: " .. self.pos.y},
			{text = "Zoom: " .. self.zoom.x}
		}
	end 

end -- end of new


----------------------
-- Static Functions
----------------------
function Camera:Update()
	self:UpdateShake()
	self:UpdateMoveNodes()
end 


-----------------
-- Actions
-----------------

function Camera:MoveLeft()
	self.pos.x = self.pos.x + self.moveSpeed
end 

function Camera:MoveRight()
	self.pos.x = self.pos.x - self.moveSpeed
end

function Camera:MoveUp()
	self.pos.y = self.pos.y + self.moveSpeed
end 

function Camera:MoveDown()
	self.pos.y = self.pos.y - self.moveSpeed
end 

function Camera:ZoomIn()
	self.zoom.x = self.zoom.x + self.zoomSpeed
	self.zoom.y = self.zoom.y + self.zoomSpeed
end 

function Camera:ZoomOut()
	self.zoom.x = self.zoom.x - self.zoomSpeed
	self.zoom.y = self.zoom.y - self.zoomSpeed
end

function Camera:RotLeft()
	self.rot = self.rot + self.rotSpeed
end 

function Camera:RotRight()
	self.rot = self.rot - self.rotSpeed
end 

-- not working, not sure why will fix later :P
function Camera:ShakeSoft()
	self:Shake{xMax = 10, yMax= 10}
end


Camera.Input = Input:New
{
	parent = Camera,
	keys =
	{
		{Camera.keys.left, "hold", Camera.MoveLeft},
		{Camera.keys.right, "hold", Camera.MoveRight},
		{Camera.keys.up, "hold", Camera.MoveUp},
		{Camera.keys.down, "hold", Camera.MoveDown},
		{Camera.keys.zoomIn, "hold", Camera.ZoomIn},
		{Camera.keys.zoomOut, "hold", Camera.ZoomOut},
		{Camera.keys.rotLeft, "hold", Camera.RotLeft},
		{Camera.keys.rotRight, "hold", Camera.RotRight},
		{Camera.keys.shakeSoft, "hold", Camera.ShakeSoft}
	}
}



-- draw all objects based on camera transformation
function Camera:Draw()

	local pos = self:CalculatePos()


	local o = 
	{
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2
	}

	love .graphics.push()

	love.graphics.translate(o.x + self.pos.x,o.y + self.pos.y)
	love.graphics.rotate(self.rot)
	love.graphics.scale(self.zoom.x, self.zoom.y)


	love.graphics.translate(-o.x + self.pos.x,-o.y + self.pos.y)

end 


function Camera:AfterDraw()
	---[[
	local o = 
	{
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2
	}
	love.graphics.translate(o.x, o.y)
	--]]

	love.graphics.pop()
end 

-- move camera from current pos
-- {x,y}
function Camera:Move(data)
	self.pos.x = self.pos.x + (data.x or 0)
	self.pos.y = self.pos.y + (data.y or 0)
end


-- set camera pos directly
-- {x,y}
function Camera:SetPos(data)
	self.pos.x = data.x or self.pos.x
	self.pos.y = data.y or self.pos.y
end 

function Camera:CalculatePos()
	local pos = {x=0, y=0}

	pos.x = self.pos.x + self.shake.xOffset
	pos.y = self.pos.y + self.shake.yOffset

	return pos
end 

-- set the shake table
-- should add support for multiple tables
-- {x, y, duration}
function Camera:Shake(data)
	self.shake.xMax = data.xMax or 1
	self.shake.yMax = data.yMax or 1
	self.shake.reduce = data.reduce or 0.98

	self.shake.xOffset = 0
	self.shake.yOffset = 0

end 

function Camera:AddShake(data)
	self.shake.xMax = self.shake.xMax + data.x
	self.shake.yMax = self.shake.yMax + data.y

	self.shake.reduce = data.reduce or 0.98

end

-- shakes the camera based on the current shake table
function Camera:UpdateShake()

	-- offset camera
	self.shake.xOffset = love.math.random(-self.shake.xMax, self.shake.xMax)
	self.shake.yOffset = love.math.random(-self.shake.yMax, self.shake.yMax)

	-- reduce shake
	self.shake.xMax = self.shake.xMax * self.shake.reduce
	self.shake.yMax = self.shake.yMax * self.shake.reduce


	-- need to add duration into this
end 


-- i dont think this actually does anything
-- or has been tested yet
function Camera:SetMoveNode(data)
	local node = {}
	node.x = data.x or self.pos.x
	node.y = data.y or self.pos.y

	self.targetNodes[#self.targetNodes + 1] = node
end 

function Camera:UpdateMoveNodes()
	if(#self.moveNodes == 0) then
		return 
	end 

	self.pos.x = self.pos.x + (self.moveNodes[self.moveIndex].x - self.pos.x)
	self.pos.y = self.pos.y + (self.moveNodes[self.moveIndex].y - self.pos.y)

end 


function Camera:PrintDebugText()
	DebugText:TextTable
	{
		{text = "", obj = "Camera" },
		{text = "Camera"},
		{text = "-------------------"},
		{text = "X: " .. self.pos.x},
		{text = "Y: " .. self.pos.y},
		{text = "Zoom: " .. self.zoom.x},
		{text = "Rot: " .. self.rot}
	}
end 


-- is this commented out for a reason?
-- need to look into it
--ObjectUpdater:AddStatic(Camera)

return Camera





-- Notes
--------------
-- Camera only operates as a static currently
-- the New function is broken and is not even used
-- everything in thats static in this object needs to be moved over to New