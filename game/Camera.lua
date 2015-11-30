-- Camera.lua
-->REFACTOR
-->CLEAN

-- Purpose
----------------------------
-- Camera creator and controller
-- static acts as global access to objects in game
-- but creates camera objects that can be switched between



------------------
-- Requires
------------------

local Input = require("Input")
local Pos = require("Pos")

--------------------------------------------------------------------
-- global
Camera = {}

------------------
-- Static Info
------------------
Camera.Info = Info:New
{
	objectType = "Camera",
	dataType = "Graphics",
	structureType = "Static"
}

------------------
-- Static Vars
------------------

-- list of all cameras in scene
Camera.cameras = {}

Camera.selectedCamera = 1

-- need a system for controlling from other objects

-----------
-- Object
-----------

-- need to make camera an object created by constructor
function Camera:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Camera",
		dataType = "Graphics",
		structureType = "Object"
	}

	----------
	-- Vars
	----------

	o.active = data.active or true

	-- pos
	o.Pos = Pos:New
	{
		x = data.x or 0,
		y = data.y or 0
	}

	o.moveSpeed = 2

	-- rotation
	o.rot = 0
	o.rotSpeed = 0.01

	-- zoom
	o.zoom = {x=1, y=1}
	o.zoomSpeed = 0.01

	
	-- unused as of now I believe
	o.moveNodes = {}
	o.moveIndex = 0
	o.maxShake = 100

	-- doesnt seem to work anymore?
	o.shake =
	{
		xMax = 0,
		yMax = 0,
		xOffset = 0,
		yOffset = 0,
		reduce = 0,
	} 

	-- fine for now but change later
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
		shakeSoft = "n",
	}

	--------------------------
	-- Movement and stuff
	-------------------------

	function o:MoveLeft()
		self.Pos.x = self.Pos.x + self.moveSpeed
	end 

	function o:MoveRight()
		self.Pos.x = self.Pos.x - self.moveSpeed
	end

	function o:MoveUp()
		self.Pos.y = self.Pos.y + self.moveSpeed
	end 

	function o:MoveDown()
		self.Pos.y = self.Pos.y - self.moveSpeed
	end 

	function o:ZoomIn()
		print("balls")
		self.zoom.x = self.zoom.x + self.zoomSpeed
		self.zoom.y = self.zoom.y + self.zoomSpeed
	end 

	function o:ZoomOut()
		self.zoom.x = self.zoom.x - self.zoomSpeed
		self.zoom.y = self.zoom.y - self.zoomSpeed
	end

	function o:RotLeft()
		self.rot = self.rot + self.rotSpeed
	end 

	function o:RotRight()
		self.rot = self.rot - self.rotSpeed
	end 

	-- not working, not sure why will fix later :P
	function o:ShakeSoft()
		self:Shake{xMax = 10, yMax= 10}
	end

	-----------------------
	-- Input
	-----------------------

	o.Input = Input:New
	{
		parent = o,
		keys =
		{
			{o.keys.left, "hold", o.MoveLeft},
			{o.keys.right, "hold", o.MoveRight},
			{o.keys.up, "hold", o.MoveUp},
			{o.keys.down, "hold", o.MoveDown},
			{o.keys.zoomIn, "hold", o.ZoomIn},
			{o.keys.zoomOut, "hold", o.ZoomOut},
			{o.keys.rotLeft, "hold", o.RotLeft},
			{o.keys.rotRight, "hold", o.RotRight},
			{o.keys.shakeSoft, "hold", o.ShakeSoft}
		}
	}



	-- draw all objects based on camera transformation
	function o:Draw()

		local pos = self:CalculatePos()


		local screen = 
		{
			x = love.graphics.getWidth() / 2,
			y = love.graphics.getHeight() / 2
		}

		love .graphics.push()

		love.graphics.translate(screen.x + self.Pos.x, screen.y + self.Pos.y)
		love.graphics.rotate(self.rot)
		love.graphics.scale(self.zoom.x, self.zoom.y)


		love.graphics.translate(-screen.x + self.Pos.x, -screen.y + self.Pos.y)

	end 


	function o:PostDraw()
		
		local screen = 
		{
			x = love.graphics.getWidth() / 2,
			y = love.graphics.getHeight() / 2
		}

		love.graphics.translate(screen.x, screen.y)
		love.graphics.pop()

	end 

	-- move camera from current pos
	-- {x,y}
	function o:Move(data)
		self.Pos.x = self.Pos.x + (data.x or 0)
		self.Pos.y = self.Pos.y + (data.y or 0)
	end


	-- set camera pos directly
	-- {x,y}
	function o:SetPos(data)
		self.Pos.x = data.x or self.Pos.x
		self.Pos.y = data.y or self.Pos.y
	end 

	-- no idea what this is?
	function o:CalculatePos()
		local p = {x=0, y=0}

		p.x = self.Pos.x + self.shake.xOffset
		p.y = self.Pos.y + self.shake.yOffset

		return p
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
	-- hasn't been tested yet
	function o:SetMoveNode(data)
		local node = {}
		node.x = data.x or self.Pos.x
		node.y = data.y or self.Pos.y

		self.targetNodes[#self.targetNodes + 1] = node
	end 

	-- broken for now
	function o:UpdateMoveNodes()

		if(#self.moveNodes == 0) then
			return 
		end 

		-- this actually wont work
		-- it will move the camera instantly to node pos
		-- need to create a vector direction and then normalize it
		-- then scale by a given speed
		self.Pos.x = self.Pos.x + (self.moveNodes[self.moveIndex].x - self.Pos.x)
		self.Pos.y = self.Pos.y + (self.moveNodes[self.moveIndex].y - self.Pos.y)

	end 


	-- info
	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "Camera" },
			{text = "Camera"},
			{text = "-------------------"},
			{text = "X: " .. self.Pos.x},
			{text = "Y: " .. self.Pos.y},
			{text = "Zoom: " .. self.zoom.x},
			{text = "Rot: " .. self.rot}
		}
	end 


	--------------
	-- Functions
	--------------

	function o:Update()
		self:UpdateShake()
		self:UpdateMoveNodes()
	end 


	----------
	-- End 
	----------

	--ObjectUpdater:Add{o}

	return o

end

----------------------
-- Static Functions
----------------------

-- update the selected camera
-- in the future other cameras may need to be updated as well
function Camera:Update()
	self.cameras[self.selectedCamera]:Update()
	self.cameras[self.selectedCamera]:PrintDebugText()
end 

function Camera:InputUpdate(key, inputType)
	self.cameras[self.selectedCamera].Input:InputUpdate(key, inputType)
end

function Camera:RepeatedInput()
	self.cameras[self.selectedCamera].Input:RepeatedInputUpdate()
end 

-- draw the selected camera
function Camera:Draw()
	self.cameras[self.selectedCamera]:Draw()
end

-- draw the selected camera
function Camera:PostDraw()
	self.cameras[self.selectedCamera]:PostDraw()
end 


------------------------------
-- Create Default Camera
------------------------------
Camera.cameras[1] = Camera:New{}


---------------
-- Static End
---------------

return Camera



-- Notes
--------------
-- re working Camera
-- gonna be broken for a bit

-- scrolling up down left right is messed up while rotated
-- need to fix this

-- Camera only operates as a static currently
-- the New function is broken and is not even used
-- everything in thats static in this object needs to be moved over to New

-- needs a massive cleanup bad
-- the static vs object needs to be sorted
-- Camera Static should create Camera Objects -->FIX

-- Camera doesnt work with the new drawing system
-- needs to be integrated somehow -->DONE





-- Junk
-----------------------------------


-- this is commented out for now because Camera is the only camera
-- acts as a static
-- but is updated like an object
-- that needs to change
-- working on it
--ObjectUpdater:AddStatic(Camera)