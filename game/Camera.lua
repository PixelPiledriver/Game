-- Camera.lua
-- main camera
-- in the future will be able to create multiple cameras
-- but just work with one for now


local Camera = {}

--------------
-- Create
--------------
Camera.pos = {x=0, y=0}
Camera.rot = 0
Camera.zoom = {x=1, y=1}

Camera.zoomSpeed = 0.01
Camera.moveSpeed = 2


	Camera.keys =
	{
		left = "l",
		right = "'",
		up = "p",
		down = ";",
		zoomIn = "[",
		zoomOut = "o",
		rotLeft = ",",
		rotRight = "/"
	}

--------------
-- Functions
--------------
function Camera:Update()

end 

-- manually control the camera
-- test bullshit
function Camera:RepeatedInput()

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



end

function Camera:Draw()
	love.graphics.rotate(self.rot)
	love.graphics.scale(self.zoom.x, self.zoom.y)
	love.graphics.translate(Camera.pos.x, Camera.pos.y)

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








return Camera