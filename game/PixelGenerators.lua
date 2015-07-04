-- PixelGenerators.lua
-- different funcitons that Ive used in the past to generate pixels
-- really just a place to store old code



--[[
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
	--]]

