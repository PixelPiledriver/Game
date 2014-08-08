
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires --> load and run shit in other files
require("DeltaTime")
require("PrintDebug")
require("DebugText")
local FrameCounter = require("FrameCounter")
local ObjectUpdater = require("ObjectUpdater")
local Window = require("Window")
local App = require("App")
local Box = require("Box")

local Map = require("Map")

local Player = require("Player")
local Sprites = require("Sprites")
local Camera = require("Camera")
local Sound = require("Sound")
local Controller = require("Controller")
local PlayerSkins = require("PlayerSkins")
local Color = require("Color")
local Collision = require("Collision")
local CollisionManager = require("CollisionManager")
local CollisionLists = require("CollisionLists")
local Guns = require("Guns")

--------------
-- Objects
--------------

-- will move object loader to own file soon :P
local redRobot = Player:New
{
	name = "redRobot",
	x = 200,
	y = 300,
	
	frame = Sprites.dude.red.idle,
	skin = PlayerSkins.red,
	
	playerColor = "darkRed",
	gun = Guns.laserRifle
}



local blueRobot = Player:New
{
	name = "blueRobot",
	x = 400,
	y = 300,
	
	frame = Sprites.dude.blue.idle,
	skin = PlayerSkins.blue,
	playerColor = "blue",

	xShootPos = -25,
	shootDirection = -1,

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down",
		shoot = "=",
		build = "-",
	},

	gun = Guns.laserRifle
}







local Greg = Collision:New
{
	x = 100,
	y = 100,
	width = 32,
	height = 32,
	shape = "rect",
	mouse = true,
	name = "Greg",
	collisionList = {"Steve"},
	draw = false
}



ObjectUpdater:AddCamera(Camera)


--------------------------
-- Functions / Callbacks
--------------------------

-- runs once on startup
function love.load()
	-- graphics setup
	love.window.setFullscreen(false, "desktop")
	love.graphics.setBackgroundColor(100,100,100)

-- audio testing
--[[	source = Sound.CreateSoundSource("WilhelmScream.ogg")
	Sound.SetVolume(source, 0.5)
	print(Sound.GetVolume(source))
	Sound.ToggleLooping(source)
	Sound.PlaySource(source)
]]
	require("MathTest") --> wtf?
end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)

	ObjectUpdater:Update()
	ObjectUpdater:RepeatedInput()

	if(love.keyboard.isDown("1")) then
		Sound.PlayStreamLoop("SuperMarioWorld.mp3")
	end

	Controller.Update()

	CollisionManager:Update()

	Map:Update()

end 


-- input
function love.keypressed(key)
	App:Input(key)
	ObjectUpdater:Input(key)
end


-- draw call
function love.draw()
	FrameCounter:Draw()
	DebugText:Draw()
	ObjectUpdater:Draw()

end 




-- Notes
---------------------------------------


--[[
local pawn2 = Player:New
{
	x = 400,
	y = 400,
	color = {1,1,1,1}, 
	animation = Sprites.pawn.animation1,

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down"
	}

}

--]]

--[[
local box1 = Box:New
{
	x = 200,
	y = 200
}
--]]





--[[

local Steve = Collision:New
{
	x = 200,
	y = 200,
	width = 32,
	height = 32,
	shape = "rect",
	color = Color.blue,
	name = "Steve",
	collisionList = {"Greg"}
}


local box1 = Box:New
{
	x = 150,
	y = 150,
	color = Color.green
}


--]]