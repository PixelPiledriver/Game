
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- Requires
require("DeltaTime")
require("ConsoleSetup")
local FrameCounter = require("FrameCounter")
local App = require("App")
local Box = require("Box")
local Player = require("Player")


-- sprites

local pawnSprite = love.graphics.newImage("graphics/pawn.png")
local pawnSheet = love.graphics.newImage("graphics/pawnSheet.png")
pawnSprite:setFilter("nearest","nearest")
pawnSheet:setFilter("nearest", "nearest")


local function MakeFrame(data)
	local f = {}

	f.x = data.x or 0
	f.y = data.y or 0
	f.width = data.width or 1
	f.height = data.height or 1
	f.imageWidth = data.imageWidth or 128
	f.imageHeight = data.imageHeight or 128

	return love.graphics.newQuad(f.x, f.y, f.width, f.height, f.imageWidth, f.imageHeight)
end 


local idleFrame = MakeFrame
{
	x = 0,
	y = 0,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128
}

local attackFrame = MakeFrame
{
	x = 0,
	y = 64,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128
}

local walkFrame = MakeFrame
{
	x = 64,
	y = 0,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128
}

local damageFrame = MakeFrame
{
	x = 64,
	y = 64,
	width = 64,
	height = 64,
	imageWidth = 128,
	imageHeight = 128	
}


-- objects
local pawn = Player:New
{
	sprite = pawnSheet,
	x = 200,
	y = 300,
	useFrame = true,
	frame = attackFrame,
	sheet = pawnSheet,
	color = {255,255,255,255}
}
local pawn2 = Player:New
{
	sprite = pawnSprite,
	x = 300,
	y = 300,
	color = {255, 100, 100, 255},
	sheet = pawnSheet,
	frame = damageFrame,
	useFrame = true,
	xScale = -1,

	keys = 
	{
		left = "left",
		right = "right",
		up = "up",
		down = "down"
	}

}







-- game start
-- runs only once
function love.load()
	-- graphics setup
	love.window.setFullscreen(false, "desktop")
	love.graphics.setBackgroundColor(100,100,100)

	require("MathTest")




end 


-- frame step
function love.update(dt)
	deltaTime = dt
	FrameCounter:Update(dt)

	pawn:RepeatedInput()
	pawn2:RepeatedInput()
end 


-- input
function love.keypressed(key)
	App:Input(key)
	pawn:Input(key)
	pawn:Input(key)
end


-- draw call
function love.draw()
	FrameCounter:Draw()

	pawn2:Draw()
	pawn:Draw()
	
	
end 


