-- DrawTools.lua
-- draw stuff on pixel textures


local ObjectUpdater = require("ObjectUpdater")
local Color = require("Color")
local Box = require("Box")


local DrawTools = {}

DrawTools.name = "DrawTools"
DrawTools.oType  = "Static"
DrawTools.dataType = "Graphics Tools"

DrawTools.selectedPixelTexture = nil

DrawTools.selectedColor = Color:Get("red")


DrawTools.selectedColorBox = Box:New
{
	x = 200,
	y = 100,
	width = 50,
	height = 50,
	color = DrawTools.selectedColor,
}


function DrawTools:Update()
	self:Draw()
	self:ColorDrop()
	self:Move()
end

function DrawTools:MousePos()
	local x = (love.mouse.getX() - self.selectedPixelTexture.Pos.x) /	self.selectedPixelTexture.Scale.x
	local y = (love.mouse.getY() - self.selectedPixelTexture.Pos.y) / self.selectedPixelTexture.Scale.y

	return x,y
end

function DrawTools:Move()
	if(self.selectedPixelTexture == nil) then
		return
	end 

	if(love.mouse.isDown("r")) then
		self.selectedPixelTexture.Pos.x = love.mouse.getX()
		self.selectedPixelTexture.Pos.y = love.mouse.getY()
	end 

end 

-- simple draw onto pixTex
function DrawTools:Draw()

	if(self.selectedPixelTexture == nil) then
		return
	end

	if(love.mouse.isDown("l")) then

		local x,y = self:MousePos()


		self.selectedPixelTexture:Pixel
		{
			--x = love.mouse.getX() % 32,
			--y = love.mouse.getY() % 32,
			x = x,
			y = y,
			color = self.selectedColor
		}

		--print(self.selectedPixelTexture.width)
		--print(x .. " | " .. y)



		self.selectedPixelTexture:CreateTexture()
	end

end

function DrawTools:SetSelectedColor(color)
	self.selectedColor = color
	self.selectedColorBox.color = color
end

function DrawTools:ColorDrop()
	
	if(self.selectedPixelTexture == nil) then
		return
	end

	if(love.mouse.isDown("r")) then
		local x,y = self:MousePos()

		local r,g,b,a = self.selectedPixelTexture:GetPixel{x = x, y = y}
		self:SetSelectedColor(Color:New
		{
			r = r,
			g = g,
			b = b,
			a = a
		})

	end 

end 

function DrawTools:PrintDebugText()	
	DebugText:TextTable
	{
		{text = "", obj = "DrawTools"},
		{text = "DrawTools Static"},
		{text = "-------------------------"},
	}
end 




ObjectUpdater:AddStatic(DrawTools)



return DrawTools


-- notes
-------------------------------------------------

-- super basic shit right now
-- not special or great at all
-- but it works
-- organization is pretty shitty right now

-- need icon buttons for selecting tools
-- and icons to use for the tools
-- this means I need to re factor image loading :D weeeeee! seriously excited! not a joke!


-- should make a preview layer from another pixtex and then mask it ontop of drawing
-- bed time!