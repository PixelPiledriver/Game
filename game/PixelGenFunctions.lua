-- PixelGenFunctions.lua

-- Purpose
--------------------
-- different funcitons that Ive used in the past to generate pixels
-- a place to store old interesting code 


--------------------------------------------------------------

local PixelGenFunctions = {}

----------------
-- Static Info
----------------

PixelGenFunctions.Info = Info:New
{
	objectType = "PixelGenFunctions",
	dataType = "Create",
	structureType = "Static"
}

----------------------
-- Static Functions
----------------------

-- (PixelTexture)
-- should probly pass in the brush for this too
-- or just use the selected brush for the pixel texture ---> :|
function PixelGenFunctions:SomeLines(pix)

	for i=1, 15 do
		pix:DirectionalStroke
		{
			x = Value:Range{min = 0, max = pix.width},
			y = Value:Range{min = 0, max = pix.height},
			length = Value:Range{min = 5, max = 900},
			angle = Value:Range{min = 0, max = 360},
			rot = Value:Range{min = -1, max = 1},
			rotVelocity = Value:Range{min = -20, max = 20},
			speed = Value:Value(1),
			--color = Value:Value("random"),
			color = Value:Random{values = {"blue"}},
			brush = Value:Random{values = {PixelBrush.x2}},
			--fade = Value:Value(0.99)
		}
	end 

end

function PixelGenFunctions:SomeCluster(pix)

	for i = 1, 80, 2 do
		pix:Cluster
		{
			x = pix.width/2 + love.math.random(-pix.width/4, pix.width/4),
			y = pix.height/16 + i, 
			xRange = love.math.random(0,30),
			yRange = 3,
			color = selectedPalette.colors,
			brush = {PixelBrush.x1, PixelBrush.x2, PixelBrush.x4},
			count = 200,
		}
	end 

end 

