-- SpriteSheet.lua

-- load a single image
-- frames can be displayed from it
-- or the entire image
-- might need to change the name

local ObjectUpdater = require("ObjectUpdater")


local SpriteSheet = {}

SpriteSheet.loadPath = "graphics/"

--{image}
function SpriteSheet:New(data)

	local o = {}

	-------------------
	-- Create
	-------------------

	FailNew
	{
		table = data,
		members = {"image"}
	}

	-- image
	o.image = love.graphics.newImage(SpriteSheet.loadPath .. data.image)
	o.image:setFilter("nearest", "nearest")

	-- vars
	o.width = o.image:getWidth()
	o.height = o.image:getHeight()

	o.spriteWidth = data.spriteWidth or 32
	o.spriteHeight = data.spriteHeight or 32


	------------------
	-- Functions
	------------------

	-- sprite sheets do not need to draw
	-- if you want to draw the whole sheet as a single image
	-- then create a sprite from it that is the entire size
	-- this way there is always a sprite sheet and a sprite
	-- that are seperate, so that the original image data is not changed

	return o

end 



SpriteSheet.noImage = SpriteSheet:New
{
	image = "NoImage.png"	
}


ObjectUpdater:AddStatic(SpriteSheet)

return SpriteSheet