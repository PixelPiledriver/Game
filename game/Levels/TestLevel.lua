--******************************************************************--
-- TestLevel.lua
-- 1st Test Level (attempts to mitigate out scene specifics to a file 
-- seperate from main)
-- writen by Adam Balk, September 2014
--******************************************************************--
-- modified: for new level format

----------------
-- Requires
----------------
local Box = require("Box")
local Guns = require("Guns")
local Map = require("Map")
local Particle = require("Particle")
local Player = require("Player")
local PlayerSkins = require("PlayerSkins")
local ParticleSystem = require("ParticleSystem")
local Sprites = require("Sprites")
local Shape = require("Shape")
local Polygon = require("Polygon")
local Color = require("Color")
local SinCounter = require("SinCounter")

-------------------------------------------------

local Start = function()

	--------------
	-- Objects
	--------------
	local box1 = Box:New
	{
		name = "BoxBuddy",
		x = 100,
		y = 100
	}

	local box2 = Box:New
	{
		x = 200,
		y = 200,
		xScale = 1,
		yScale = 1,

		spin = 0
	}


	--local cross = Shape:New(Shape.cross)

	local fireBall = ParticleSystem:New(ParticleSystem.systems.fire1)

	ObjectUpdater:AddCamera(Camera)

	--local sc = SinCounter:New{speed = 0.01}


	local lerpTest = Math:Lerp
	{
		a = -10,
		b = 10,
		t = 0.75
	}

	print(lerpTest)
	
end


local Update = function()

end

local Exit = function()

end

local Restart = function()

end 

----------
-- End
----------

local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "TestLevel"
}

return level





-- Notes
-------------------
-- this file is garbage
-->DELETE




-- Junk
--------------------------------------
--[[

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
			jump = "rctrl"
		},

		gun = Guns.laserRifle
	}

	local rotBox = Box:New
	{
		x = 200, 
		y = 50,
		width = 32,
		height = 32,
		rotatable = true,
		angle = 45
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



	local explosion = ParticleSystem:New
	{
		x = 100,
		y = 100,
		delay = 10
	}
	

--[[
	local poly = Polygon:New
	{
		color = Color:Get("darkBlue"),
		fill = false,
		verts =
		{
			{x=0, y=0},
			{x=32, y=0},
			{x=32, y=32},
			{x=100, y=100},
			{x=23, y=0}
		}
	}
--]]

--]]