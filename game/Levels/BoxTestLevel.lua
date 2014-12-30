--******************************************************************--
-- TestLevel.lua
-- 1st Test Level (attempts to mitigate out scene specifics to a file 
-- seperate from main)
-- writen by Adam Balk, September 2014
--******************************************************************--

-- requirements for this level
local Box = require("Box")
local Guns = require("Guns")
local Map = require("Map")
local Particle = require("Particle")
local Player = require("Player")
local PlayerSkins = require("PlayerSkins")
local ParticleSystem = require("ParticleSystem")
local Sprites = require("Sprites")
local ObjectUpdater = require("ObjectUpdater")
local Shape = require("Shape")
local Polygon = require("Polygon")
local Color = require("Color")
local SinCounter = require("SinCounter")

-- Table to hold Level objects
local BoxTestLevel = {}

-- On Level Start
function BoxTestLevel:Load()
	-------
	-- Objects
	--------------
	local box1 = Box:New
	{
		x = 200,
		y = 200
	}




	
end

-- On Level Update
function BoxTestLevel:Update()

end

-- On Level End
function BoxTestLevel:Exit()

end

return BoxTestLevel