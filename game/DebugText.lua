-- draw text info to screen
-- need to make a console too

local DebugText = {}



-- types
-------------
DebugText.type = 
{
	controller = true
	player = false	
}


-- text to draw next frame
DebugText.texts = {}

-- position shit
DebugText.xStart = 16
DebugText.yStart = 16
DebugText.xSpace = 16
DebugText.ySpace = 16


----------------
-- Functions
----------------

-- add a new text to be drawn
-- {message, type, color, pos}
function DebugText:Text(data)

	if(self.type[data.type] == false)
		return
	end 

	self.texts[#self.texts + 1] = data

end

-- draw all texts
function DebutText:Draw()

	for i=1, #self.texts do
		love.graphics.setColor(self.texts[i].color)
		love.graphics.print("LoveFPS:" .. love.timer.getFPS(), self.xStart, self.yStart + (self.ySpace * (i-1) ) )
	end 

end 

-- clears all texts
-- per frame
function DebugText:ClearTexts()

	for i=1, #DebugText.texts do
		DebugText.texts[i] = nil
	end 

end 










return DebugText