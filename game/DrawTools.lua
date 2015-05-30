-- DrawTools.lua
-- draw stuff on pixel textures


local Color = require("Color")
local Box = require("Box")
local Mouse = require("Mouse")


local DrawTools = {}

DrawTools.name = "DrawTools"
DrawTools.oType  = "Static"
DrawTools.dataType = "Graphics Tools"

DrawTools.monkey = false


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
	Zoom = false,
	index = {"Draw", "Move", "ColorDrop", "Zoom"}
}

-- displays the current selected color
-- gonna ignore this shit for a min
DrawTools.selectedColorBox = Box:New
{
	x = 200,
	y = 0,
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

	self:UpdateTools()

	--[[
	if(self.selectedTool) then
		self:selectedTool()
	end 
	--]]

	--self:Draw()
	--self:ColorDrop()
	--self:Move()
end

function DrawTools:UpdateTools()

	if(self.selectedPixelTexture == nil) then
		return
	end

	for i=1, #self.tools.index do
		if(self.tools[self.tools.index[i]]) then
			self[self.tools.index[i]](self)
		end
	end

end 

function DrawTools:MousePos()
	local x = (love.mouse.getX() - self.selectedPixelTexture.Pos.x) /	self.selectedPixelTexture.Scale.x
	local y = (love.mouse.getY() - self.selectedPixelTexture.Pos.y) / self.selectedPixelTexture.Scale.y

	return x,y
end

-- simple draw onto pixTex --> does not have solid lines :P
function DrawTools:Draw()


	if(love.mouse.isDown("l")) then

		local x,y = self:MousePos()


		self.selectedPixelTexture:Pixel
		{
			x = x,
			y = y,
			color = self.selectedColor
		}

		self.selectedPixelTexture:RefreshTexture()
	end

end

-- move pixel texture around screen --> pretty ghetto at the moment :P
function DrawTools:Move()

	if(love.mouse.isDown("r")) then
		self.selectedPixelTexture.Pos.x = love.mouse.getX()
		self.selectedPixelTexture.Pos.y = love.mouse.getY()
	end 

end 


-- scale the object for more or less view
-- this tool will be changed to something different called scale
-- however a basic version it will just be called zoom for right now :P
function DrawTools:Zoom()

	if(Mouse:SingleClick("l")) then
		self.selectedPixelTexture.Scale.x  = self.selectedPixelTexture.Scale.x + 1
		self.selectedPixelTexture.Scale.y  = self.selectedPixelTexture.Scale.y + 1
	end 

	if(Mouse:SingleClick("r")) then
		self.selectedPixelTexture.Scale.x  = self.selectedPixelTexture.Scale.x - 1
		self.selectedPixelTexture.Scale.y  = self.selectedPixelTexture.Scale.y - 1
	end 


end 

function DrawTools:SetSelectedColor(color)
	self.selectedColor = color
	self.selectedColorBox.color = color
end

-- grab a color from pixel texture that mouse is hovering over
function DrawTools:ColorDrop()
	
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
		{text = Bool:ToString(self.tools.Draw)},
		{text = Bool:ToString(self.tools.Move)},
		{text = Bool:ToString(self.tools.ColorDrop)},
		{text = Bool:ToString(self.tools.Zoom)},
		{text = Bool:ToString(self.monkey)}
	}
end 


ObjectUpdater:AddStatic(DrawTools)



return DrawTools


-- notes
-------------------------------------------------

-- Basic Tools
--------------------
-- zoom --> show larger pixels but within same canvas size --> slightly difficult but meh
-- scale --> change scale of object directly --> works but not exactly the cleanest way to do it
-- selection --> box an area of pixels and then move it

-- palette tools --> color drop from palette, re order etc

-- Tool features
-------------------------
-- solid line drawing --> fill in speed gaps

-- Brush tools --> this will take some time and will be sort of its own thing -- but writing about it here
-------------------------
-- brush selection --> small previews, click and draw
-- brush creation --> draw a new brush and then use it

-- flip --> x, y and selection
-- rotate




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