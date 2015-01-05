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

-- current tool to run
-- this is a function pointer and calls whatever it is set to
-- this makes it so only one tool can be run at a time
-- will mess with other solutions but this should work for now
DrawTools.selectedTool = nil
DrawTools.tools =
{
	Draw = false,
	Move = false,
	ColorDrop = false,
	index = {"Draw", "Move", "ColorDrop"}
}


DrawTools.selectedColorBox = Box:New
{
	x = 200,
	y = 100,
	width = 50,
	height = 50,
	color = DrawTools.selectedColor,
}


---------------------------
-- Functions
---------------------------

-- change a tool from in-active to active and back again
function DrawTools:ToggleTool(toolName)

	if(self.tools[toolName] == false) then
		self.tools[toolName] = true
	else
		self.tools[toolName] = false
	end

end 


function DrawTools:Update()

	for i=1, #self.tools.index do
		if(self.tools[self.tools.index[i]]) then
			self[self.tools.index[i]](self)
		end
	end

	--[[
	if(self.selectedTool) then
		self:selectedTool()
	end 
	--]]

	--self:Draw()
	--self:ColorDrop()
	--self:Move()
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

-- Preview Layer
-- should make a preview layer from another pixtex and then mask it ontop of drawing
-- bed time!

-- Duel Wield Tools
-- duel wield tools idea
-- left or right click a tool button to select it for that click
-- that way you can set 2 different tools at all times!
-- wow that's actually a crazy cool idea
-- only downside is that some tools take up both left and right click to work
-- but can be worked around



-- worked on or done
----------------------------------------
-- *this is working well*
-- need icon buttons for selecting tools
-- and icons to use for the tools
-- this means I need to re factor image loading :D weeeeee! seriously excited! not a joke!
-- *this is working well*


-- * improved quite a bit from the super basic setup*
-- super basic shit right now
-- not special or great at all
-- but it works
-- organization is pretty shitty right now