-- PixelTexture

local Color = require("Color")

local PixelTexture = {}



function PixelTexture:New(data)

	-------------------
	-- Create
	-------------------

	local object = {}

	object.image = love.image.newImageData(data.width, data.height)


	---------------------
	-- Functions
	---------------------

	-- set a single pixel
	function object:SetPixel(data)
		local color = Color:Get(data.color)
		self.image:setPixel(data.x, data.y, color[1], color[2], color[3], color[4])
	end 

	function object:BoxPixels(data)

		for x=1, data.width do
			for y=1, data.height do

				self:SetPixel
				{
					x = data.x + x - 1,
					y = data.y + y - 1,
					color = data.color
				}
			end
		end 

	end

	-- save image to file
	-- defaults to AppData/Love/Game
	function object:Encode(data)
		self.image:encode(data.filename, data.type)
	end 



	return object

end 


-----------------------
-- Test Shit
----------------------

local p = PixelTexture:New
{
	width = 32,
	height = 32
}


p:SetPixel
{
	x = 8,
	y = 8,
	color = "random"
}


p:BoxPixels
{
	x = 8,
	y = 8,
	width = 8,
	height = 8,
	color = "random"
}

p:Encode
{
	filename = "image.png", 
	type = "png"
}




-- return static
return PixelTexture




