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
local Link = require("Link")
local Box = require("Box")
local Line = require("Line")
local Color = require("Color")

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
Camera.selectedCamera = nil
Camera.selectedCameraIndex = 1

-- need a function interface for controlling selected and non selected cameras
-- from other objects

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
		--x = data.x or -213,
		--y = data.y or 50
		--x = data.x or -200,
		--y = data.y or 100
		x = 0,
		y = 0


	}

	o.moveSpeed = 2

	-- rotation
	o.rot = 0
	o.rotSpeed = 0.01

	-- zoom
	--o.zoom = {x=2, y=2}
	o.zoom = {x=1, y=1}
	o.zoomSpeed = 0.01
	o.useIncreasingZoom = true
	o.increasingZoomSpeed = 0.01

	o.zoomMax = 100
	o.zoomMin = 0


	function o:CreateTestObjects()
		-------------------
		-- Test Objects
		-------------------
		-- objects that help determine values of camera
		o.zoomBox = Box:New
		{
			width = 32,
			height = 32,
			color = Color:Get("yellow")
		}
		
		Link:Simple
		{
			a = {o.zoomBox, "Pos", {"x", "y"}},
			b = {o, "Pos", {"x", "y"}},
		}

		o.centerView = {}
		o.centerView.size = 15
		o.centerView.verticalLine = Line:New
		{
			a = {x = Window.width * 0.5, y = (Window.height * 0.5) - o.centerView.size},
			b = {x = Window.width * 0.5, y = (Window.height * 0.5) + o.centerView.size},
			layer = "Hud"
		}
		
		o.centerView.horizontalLine = Line:New
		{
			a = {x = Window.width * 0.5 - o.centerView.size, y = Window.height * 0.5},
			b = {x = Window.width * 0.5 + o.centerView.size, y = Window.height * 0.5},
			layer = "Hud"
		}
		
		Link:Simple
		{
			a = {o.centerView.verticalLine, "Pos", {"x", "y"}},
			b = {o, "Pos", {"x", "y"}}
		}

		Link:Simple
		{
			a = {o.centerView.horizontalLine, "Pos", {"x", "y"}},
			b = {o, "Pos", {"x", "y"}}
		}

	end

	--------------
	-- Shake
	--------------

	-- doesnt seem to work anymore?
	-->FIX
	o.maxShake = 100
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
	-- Movement and Transforms
	-------------------------

	function o:MoveLeft()
		self.Pos.x = self.Pos.x - self.moveSpeed
	end 

	function o:MoveRight()
		self.Pos.x = self.Pos.x + self.moveSpeed
	end

	function o:MoveUp()
		self.Pos.y = self.Pos.y - self.moveSpeed
	end 

	function o:MoveDown()
		self.Pos.y = self.Pos.y + self.moveSpeed
	end 

	function o:ZoomIn()

		-- zoom faster when close?
		if(self.useIncreasingZoom) then
			-- makes zoom speed almost constant speed even when close up
			self.zoom.x = self.zoom.x + self.zoomSpeed + (self.zoom.x * self.increasingZoomSpeed)
			self.zoom.y = self.zoom.y + self.zoomSpeed + (self.zoom.y * self.increasingZoomSpeed)		
		else
			-- normal zoom, not good for close up tho
			self.zoom.x = self.zoom.x + self.zoomSpeed
			self.zoom.y = self.zoom.y + self.zoomSpeed
		end

		-- min and max
		if(self.zoom.x > self.zoomMax) then
			self.zoom.x = self.zoomMax
		end 

		if(self.zoom.y > self.zoomMax) then
			self.zoom.y = self.zoomMax
		end 


	end 

	function o:ZoomOut()
		if(self.useIncreasingZoom) then
			self.zoom.x = self.zoom.x - self.zoomSpeed - (self.zoom.x * self.increasingZoomSpeed)
			self.zoom.y = self.zoom.y - self.zoomSpeed - (self.zoom.y * self.increasingZoomSpeed)
		else 
			self.zoom.x = self.zoom.x - self.zoomSpeed
			self.zoom.y = self.zoom.y - self.zoomSpeed		
		end 

		if(self.zoom.x < self.zoomMin) then
			self.zoom.x = self.zoomMin
		end 

		if(self.zoom.y < self.zoomMin) then
			self.zoom.y = self.zoomMin
		end 

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


	----------------------
	-- Movement Nodes
	----------------------

	o.moveNodes = {}
	o.moveNodeIndex = 1
	o.moveNodeVector = {x=nil, y=nil}

	-- create a position node for the camera to move towards
	function o:SetMoveNode(data)

		-- create node
		local node = {}

		node.x = data.x or self.Pos.x
		node.y = data.y or self.Pos.y

		-- camera has node table?
		if(self.moveNodes == nil) then
			self.moveNodes = {}
		end 

		-- add node to list
		self.moveNodes[#self.moveNodes + 1] = node

	end 


	function o:TestNodes()
		self:SetMoveNode{x = 100, y = 100}
	end 

	-- fixing
	function o:UpdateMoveNodes()

		-- node control doesnt exist?
		if(self.moveNodes == nil) then
			return
		end 

		-- no nodes in list?
		if(#self.moveNodes == 0) then
			return 
		end 

		-- need to create vector to next node?
		if(self.moveNodeVector.x == nil or self.moveNodeVector.y == nil) then
			local tempVector = 
			{
				x = self.moveNodes[self.moveNodeIndex].x - self.Pos.x,
				y = self.moveNodes[self.moveNodeIndex].y - self.Pos.y
			}

			local tempUnitVector = Math:UnitVector(tempVector)

			self.moveNodeVector.x = tempUnitVector.x * self.moveSpeed
			self.moveNodeVector.y = tempUnitVector.y * self.moveSpeed
		end 

		self.Pos.x = self.Pos.x + self.moveNodeVector.x
		self.Pos.y = self.Pos.y + self.moveNodeVector.y

		printDebug{self.moveNodeVector.x .. ", " .. self.moveNodeVector.y, "Camera"}

	end

	function o:SetDefaultValues()
		self.Pos.x = 0
		self.Pos.y = 0
		self.rot = 0
		self.zoom.x = 1
		self.zoom.y = 1
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
			{o.keys.shakeSoft, "hold", o.ShakeSoft},
			{".", "press", o.SetDefaultValues},
			{"t", "press", o.TestNodes}
		}
	}


	---------------
	-- Graphics
	---------------


	-- apply view transform
	function o:Draw()

		local pos = self:CalculatePos()

		love .graphics.push()

		-- move all objects to apply camera position
		-- this may need to be done last, not sure
		-- not sure if it is reverse order or not like DirectX
		love.graphics.translate(-self.Pos.x, -self.Pos.y)

		-- translate to set screen to center of view
		love.graphics.translate( (love.graphics.getWidth()/2) + self.Pos.x, (love.graphics.getHeight()/2) + self.Pos.y)

		-- zoom
		love.graphics.scale(self.zoom.x, self.zoom.y)

		-- rotate
		love.graphics.rotate(self.rot)

		-- and then untranslate from center of view
		love.graphics.translate( (-love.graphics.getWidth()/2) - self.Pos.x, (-love.graphics.getHeight()/2) - self.Pos.y)

	end 


	-- remove view transform
	function o:PostDraw()
		
		love.graphics.pop()

	end 






	-----------------------------------
	-- Other Transform Functions
	-----------------------------------

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

	-- returns a combined pos of cameras actual position and its shake values
	function o:CalculatePos()
		local p = {x=0, y=0}

		p.x = self.Pos.x + self.shake.xOffset
		p.y = self.Pos.y + self.shake.yOffset

		return p
	end 


	-------------
	-- Shake
	-------------

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

	--ObjectManager:Add{o}

	return o

end

----------------------
-- Static Functions
----------------------

-- update the selected camera
-- in the future other cameras may need to be updated as well
function Camera:Update()
	self.cameras[self.selectedCameraIndex]:Update()

	if(self.cameras.moveNodes) then
		self:UpdateMoveNodes()
	end 

	self.cameras[self.selectedCameraIndex]:PrintDebugText()
end 

function Camera:InputUpdate(key, inputType)
	self.cameras[self.selectedCameraIndex].Input:InputUpdate(key, inputType)
end

function Camera:RepeatedInput()
	self.cameras[self.selectedCameraIndex].Input:RepeatedInputUpdate()
end 

-- draw the selected camera
function Camera:Draw()
	self.cameras[self.selectedCameraIndex]:Draw()
end

-- draw the selected camera
function Camera:PostDraw()
	self.cameras[self.selectedCameraIndex]:PostDraw()
end 


------------------------------
-- Create Default Camera
------------------------------
Camera.cameras[1] = Camera:New{}
Camera.selectedCamera = Camera.cameras[Camera.selectedCameraIndex]


---------------
-- Static End
---------------

return Camera



-- Notes
--------------
-->FIX
-- moving camera up, down, left, right is messed up while rotated
-- need to create vectors based on the angle of rotation
-- that are vertical and horizontal relative to the angle of the camera
-- should be easy enough with subtraction I think?
-- will have to test it


-->DONE
-- need to fix zoom
-- removed it to fix some other code

-- re working Camera
-- gonna be broken for a bit

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
--[[

-- this is commented out for now because Camera is the only camera
-- acts as a static
-- but is updated like an object
-- that needs to change
-- working on it
--ObjectManager:AddStatic(Camera)



-- this actually wont work
-- it will move the camera instantly to node pos
-- need to create a vector direction and then normalize it
-- then scale by a given speed



	function o:PostDrawOld()
		
		local screen = 
		{
			x = love.graphics.getWidth() / 2,
			y = love.graphics.getHeight() / 2
		}

		love.graphics.translate(screen.x, screen.y)
		love.graphics.pop()

	end 


	-- draw all objects based on camera transformation
	function o:DrawOld()

		local pos = self:CalculatePos()


		-- this is used to correct zooming, but does not actually work
		-- need to find a better solution for it
		-- gonna take this out for now until I figure out the other shit
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



--]]