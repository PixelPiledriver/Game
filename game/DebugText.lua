-- draw text info to screen
-- need to make a console too

local Color = require("Color")

DebugText = {}



-- types
-------------
DebugText.type = 
{
	controller = true,
	player = false,
	generic = true
}


-- text to draw next frame
DebugText.texts = {}

-- position shit
DebugText.xStart = 8
DebugText.yStart = 64
DebugText.xSpace = 16
DebugText.ySpace = 16


----------------
-- Functions
----------------

function DebugText:Text(txt)
	self.texts[#self.texts + 1] = {text = txt}
end 

-- add a new text to be drawn
-- {message, type, color, pos}
function DebugText:TextTable(data)

	local textType = data.type or "generic"

	if(self.type[DebugText.type] == false) then
		return
	end 

	self.texts[#self.texts + 1] = data

end



function DebugText:PrintObject(data)

	self:Text("")
	self:Text("Name: " .. data.name)
	self:Text("X: " .. data.x)
	self:Text("Y: " .. data.y)
end

-- draw all texts
function DebugText:Draw()

	for i=1, #self.texts do
		love.graphics.setColor(self.texts[i].color or Color.white)
		love.graphics.print(self.texts[i].text, self.xStart, self.yStart + (self.ySpace * (i-1) ) )
	end 

	self.ClearTexts()
end 

-- clears all texts
-- per frame
function DebugText:ClearTexts()

	for i=1, #DebugText.texts do
		DebugText.texts[i] = nil
	end 

end 









