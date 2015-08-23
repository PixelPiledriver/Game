-- Sprites.lua


-- Purpose
----------------------------
-- load sprites here


local Animation = require("Animation")

local Sprites = {}

Sprites.Info = Info:New
{
	objectType = "Sprites",
	dataType = "Content",
	structureTe = "Static"
}

-----------------------------
-- Vars
-----------------------------

-- stops all sprites from drawing
-- I don't this works with the new Draw process -->FIX
Sprites.drawNone = false 

---------------------------------------------
--New Code -- needs to be refactored
---------------------------------------------

-----------------------
-- Static Functions
-----------------------

-- make a single frame
local function MakeFrame(data)

	local f = {}

	------------
	-- Vars
	------------

	f.x = data.x or 0
	f.y = data.y or 0
	f.width = data.width or 1
	f.height = data.height or 1
	f.imageWidth = Sprites.currentSheet.width
	f.imageHeight = Sprites.currentSheet.height
	f.sheet = Sprites.currentSheet.object

	f.draw = data.draw or true

	f.frame = love.graphics.newQuad(f.x, f.y, f.width, f.height, f.imageWidth, f.imageHeight)

	-------------
	-- Functions
	-------------

	function f:Draw(objectData)

		if(Sprites.drawNone) then
			return
		end 

		if(self.draw == false) then
			return
		end 

		if(objectData.color) then
			love.graphics.setColor(objectData.color)
		else
			love.graphics.setColor({255,255,255,255})
		end 

		love.graphics.draw(self.sheet, self.frame, objectData.x, objectData.y - (objectData.z or 0), objectData.angle, objectData.xScale, objectData.yScale)

	end 

	return f
end



-- adds a sprite to the given table
-- smooths the process of creating sprites


local function MakeSprites(data)
	local vertical = data.vertical or false

	-- add sprites to existing obj?
	-- create object name if it doesnt exist
	if(data.objName) then
		if(Sprites[data.objName] == nil) then
			Sprites[data.objName] = {}
		end 
	end

	-- create sprite data for each name given
	for i=1, #data.spriteNames do

		local x
		local y

		if(vertical) then
			x = data.x
			y = data.y + (i-1) * data.height
		else
			x = data.x + (i-1) * data.width
			y = data.y
		end 

		-- create the sprite data

		-- add the sprite data as frame data to the sprite table
				
		if(data.objName) then
			--Sprites[data.bundle][#Sprites[data.bundle]+1] = data.names[i]
			Sprites[data.objName][data.spriteNames[i]] = MakeFrame
			{
				x = x,
				y = y,
				width = data.width,
				height = data.height,
			}
		end 

	end 

end


-- sprite sheet load

-- sheet
Sprites.sheet = {}
Sprites.sheet.object = love.graphics.newImage("graphics/dude.png")
Sprites.sheet.width = 640
Sprites.sheet.height = 640
Sprites.sheet.object:setFilter("nearest", "nearest")
Sprites.currentSheet = Sprites.sheet

MakeSprites
{
	vertical = true,
	t = sheetFrames,
	x = 0,
	y = 16,
	width = 32,
	height = 16,
	spriteNames = 
	{
		"testPink", "testGreen", "testOrange", "granite", "blotchy", "icy", "icy2", "icy3"
	},
	objName = "bricks"
}


------------------
-- Robot dude
------------------
-- objects
Sprites.dude = {}
Sprites.dude.red = {}
Sprites.dude.blue = {}
Sprites.bullet = {}


-- sheet
Sprites.dude.sheet = {}
Sprites.dude.sheet.object = love.graphics.newImage("graphics/dude.png")
Sprites.dude.sheet.width = 640
Sprites.dude.sheet.height = 640
Sprites.dude.sheet.object:setFilter("nearest", "nearest")
Sprites.currentSheet = Sprites.dude.sheet

-- frames
Sprites.dude.red.idle = MakeFrame
{
	x = 0,
	y = 0,
	width = 32,
	height = 32,
}

Sprites.dude.blue.idle = MakeFrame
{
	x = 32,
	y = 0,
	width = 32,
	height = 32,
	imageWidth = 128,
	imageHeight = 128,	
}

-------------
-- Bullet
-------------

Sprites.bullet.red = MakeFrame
{
	x = 0,
	y = 32,
	width = 32,
	height = 32,
	imageWidth = 128,
	imageHeight = 128
}

Sprites.bullet.blue = MakeFrame
{
	x = 32,
	y = 32,
	width = 32,
	height = 32,
}

------------
-- Block
------------
Sprites.block = {}
Sprites.block.red = MakeFrame
{
	x = 0,
	y = 96,
	width = 32,
	height = 32
}

Sprites.block.blue = MakeFrame
{
	x = 32,
	y = 96,
	width = 32,
	height = 32
}



return Sprites





--Notes
-------------------------------

-- need to integrate the stuff I made in Corona into this
-- need to clean this file up at some point



--------------------
--[[ Test Code
--------------------

-- Animation example
Sprites.pawn.animation1 = Animation:New
{
	name = "stuff",

	sheet = Sprites.pawn.sheet,
	frames =	{
							-- multiple frames all in one table
							--Sprites.pawn.multi[1],
							--Sprites.pawn.multi[2],
							--Sprites.pawn.multi[3],
							--Sprites.pawn.multi[4]

							-- individual frames in seperate variables
							Sprites.pawn.walk, 
							Sprites.pawn.damage, 
							Sprites.pawn.attack, 
							Sprites.pawn.idle
						},

	delays = {10, 10, 10, 10},
	speed = 1,
}


--]]















