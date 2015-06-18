-- OldCode.lua
-- place to drop off commented out code that might be useful at a later time



-- Create some basic objects
----------------------------------------------------------------------------------------------------------------

local line1 = Line:New
{
	a = {x = 400, y = 400},
	b = {x = 500, y = 420},
	width = 10,
	color = "black",
	life = 200,
	fade = true,
	fadeWithLife = true
}


local point1 = Point:New
{
	pos =
	{
		x = 100,
		y = 100
	},
	color = "blue",
	life = 100,
	fade = true,
	fadeWithLife = true,
	sizeSpeed = 1,
	speed = 
	{
		x = 0.1
	}
}


local point2 = Point:New
{
	color = "black",

	pos =
	{
		x = 200,
		y = 400,
	},

	speed = 
	{
		x = 1,
		y = -1
	},
	--life = 100
}


-- Various graphics stuff
----------------------------------------------------------------------------------------------------------------
pix:Box
{
	x = 0,
	y = 0,
	width = 32,
	height = 32,
	color = "red"
}

for i=1, 100 do
	pix:Brush
	{
		x = love.math.random(0,128),
		y = love.math.random(0,128),
		brush = PixelBrush.happyFace,
	}	
end 


for i=1, 40 do
	pix:Slice
	{
		x = {love.math.random(0,128)}, 
		y = {love.math.random(0,128)}, 
		color="black"
	}		
end 

pix:Brush
{
	x = 10,
	y = 10,
	brush = PixelBrush.smallCircle,
}

pix:Slice
{
	y={0, 10, 20, 30},
	color="red"
}

pix:XSymmetry()
pix:YSymmetry()

for i=1, 50 do
	pix:Brush
	{
		x = love.math.random(0, pix.width),
		y = love.math.random(0, pix.height),
		brush = PixelBrush.x8
	}
end 

pix:Slice
{
	x = {0,5,10,15, 20},
	color = "orange"
}

pix:Pixel
{
	x = 0,
	y = 0,
	color = "blue"
}

pix:Pixel
{
	x = pix.width-1,
	y = pix.height-1,
	color = "blue"
}



-- Palette
----------------------------------------------------------------------------------------------------------------

local pal = Palette:NewRandom{size = 4}






-- App
----------------------------------------------------------------------------------------------------------------
-- App.lua
-- do game application stuff
-- control the window, blah blah blah

local Input = require("Input")

local App = {}

---------------------------
-- Vars
------------------------
-- object
App.name = "App"
App.oType = "Static"
App.dataType = "Manager"

----------------------
-- Components
----------------------
App.Input = Input:New()


---------------------
-- Functions
---------------------

function App:QuitGameInput(key)
	-- exit game
	if(key == "escape") then
		love.event.quit()
	end 

end 

function App:Input(key)
	self:QuitGameInput(key)
end 


ObjectUpdater:AddStatic(App)

return App







-- Camera
-------------------------------------------------------------


-- manually control the camera
-- test stuff
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






-- Collision Manager
-------------------------------------------------------------------------

local obj = objList[a]

repeat

	if(obj.collisionList == nil) then
		break
	end 

	-- for each in collision list of a
	for c=1, #obj.collisionList do
	

		for b=1, #objList[obj.collisionList[c]] do
		
			local B = objList[obj.collisionList[c]][b]
			local A = obj

			if(self:RectToRect(A, B)) then
				A:CollisionWith{other = B}
				B:CollisionWith{other = A}

				printDebug{A.name .. " +collision+ " .. B.name, "Collision"}
			end 

		end

	end

until true

end

end 




-- Levels
-----------------------------------------------------------------------------------------------------
local TestLevel = require("levels/TestLevel")
local SnapGridTestLevel = require("levels/SnapGridTestLevel")
local LerpLevel = require("levels/LerpLevel")
local BoxTestLevel = require("levels/BoxTestLevel")
local SnapGridTestLevel = require("levels/SnapGridTestLevel")
local TextWriteLevel = require("levels/TextWriteLevel")
local BoxLevel = require("levels/BoxLevel")


LerpLevel:Load()
BoxTestLevel:Load()
TextWriteLevel:Load()
BoxLevel:Load()
SnapGridTestLevel:Load() 



--ObjectUpdater
------------------------------------------------------------------------------------------
-- this is def no longer needed ->DELETE
-- out for now
-- hooking up DrawList
ObjectUpdater:Draw()

























-- Unsorted
----------------------------------------------------------------------------------------------------------------

-- checking pixels before and after they are drawn to	
local pixel = {r,g,b,a}

pixel.r, pixel.g, pixel.b, pixel.a = pix.image:getPixel(10,0)
print("Pixel[" .. pixel.r .. "," .. pixel.g .. "," .. pixel.b .. "," .. pixel.a .. "]")




local pal2 = Palette:New
{
	Pos = palPos,
	draw = true
}


pal2:PrintSelf()


pal2:Linear
{
	a = "black",
	b = "green",
	size = 4
}


-- more pixel drawing stuff

	for i = 1, 80, 2 do
		pix:Cluster
		{
			x = 64 + love.math.random(-32, 32),
			y = 20 + i, 
			xRange = love.math.random(0,30),
			yRange = 3,
			color = pal2.colors,
			brush = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4},
			count = 200,
		}
	end 


	pix:XSymmetry()
	pix:YSymmetry()

	pix:LerpStroke
	{
		a = {x=20,y=20},
		b = {x=100, y=100},
		color = pal2.colors,
		brush = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4},
		xCurve = 0.5,
		yCurve = -0.5
	}



	pix:DirectionalStroke
	{
		x = Value:Value(64),
		y = Value:Value(32),
		length = Value:Value(800),
		angle = Value:Value(0),
		rot = Value:Value(1.5),
		rotVelocity = Value:Value(44),
		speed = Value:Value(1),
		color = Value:Value("random"),
		brush = Value:Random{values = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4}},
		fade = Value:Value(0.99)
	}






























