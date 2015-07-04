-- draw text info to screen
-- need to make a console too

local Color = require("Color")

DebugText = {}

-- on or off
DebugText.active = true

-- types
-------------
DebugText.type = 
{
	Player = false,
	Bullet = false,
	Block = false,
	Controller = false,
	Window = false,
	ObjectUpdater = false,
	CollisionManager = false,
	Map = false,
	ParticleSystem = false,
	Particle = false,
	Camera = true,
		
	Generic = true,
}


-- all text messages that need to be drawn on the next frame
DebugText.texts = {}

-- position shit
DebugText.xStart = 8
DebugText.yStart = 64
DebugText.xSpace = 16
DebugText.ySpace = 16


----------------
-- Functions
----------------

function DebugText:Update()
	-- nuthin to do here for now I guess :P
end 

-- add a single line
function DebugText:Text(txt)
	self.texts[#self.texts + 1] = { {text = txt, color = Color.white} }
end 

-- add a new text to be drawn
-- { {text ,color,obj}, {text,color}, ... } 
function DebugText:TextTable(data)

	local textType = data[1].obj or "Generic"

	if(self.type[textType] == false) then
		return
	end 

	self.texts[#self.texts + 1] = data

end

-- generic object print
-- this function isnt really needed anymore
function DebugText:PrintObject(data)
	self:Text("")
	self:Text("Name: " .. data.name)
	self:Text("X: " .. data.x)
	self:Text("Y: " .. data.y)
end

-- draw all texts
function DebugText:Draw()

	-- use index for sub items in text tables
	local index = 1

	-- for each text item
	for i=1, #self.texts do

		-- for each text message in item
		for t=1, #self.texts[i] do
			love.graphics.setColor(self.texts[i][t].color or Color.white)
			love.graphics.print(self.texts[i][t].text, self.xStart, self.yStart + (self.ySpace * (index-1) ) )

			index = index + 1
		end 

	end 

	-- remove all texts for next frame
	self.ClearTexts()
end 

-- clears all texts
function DebugText:ClearTexts()

	for i=1, #DebugText.texts do
		DebugText.texts[i] = nil
	end 

end 




-- Notes
-------------
-- need to add button for scrolling up and down text
-- since lots of objects overflows vertically




