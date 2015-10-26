-- FrameCounter.lua

-- Purpose
----------------------------
-- calculates and displays FPS

------------------------------------------------------------------

local FrameCounter = {}


------------------
-- Static Info
------------------
FrameCounter.Info = Info:New
{
	objectType = "FrameCounter",
	dataType = "Debug",
	structureType = "Static"
}

----------------
-- Static Vars
----------------

-- switches
FrameCounter.active = true
FrameCounter.printDeltaTime = false
FrameCounter.printLoveFPS = true

-- variables
FrameCounter.x = 10
FrameCounter.y = 10
FrameCounter.color = {0, 0, 0, 255}
FrameCounter.font = love.graphics.newFont(10)

local time = 0
local frameCount = 0
local fps = 0
local updateRate = 4

---------------------
-- Static Functions
---------------------

function FrameCounter:Update(dt)

	if(self.active == false) then
		return
	end

	frameCount = frameCount + 1
	time = time + dt

	if(time > 1/updateRate) then
		fps = frameCount / dt
		frameCount = 0
		time =  time - (1/updateRate)
	end 

end 


-- draw the fps to screen
function FrameCounter:Draw()
	if(self.active == false) then
		return
	end 

	love.graphics.setFont(self.font)
	love.graphics.setColor(self.color)
	love.graphics.print("FPS:" .. math.floor(fps), self.x, self.y)

	if(self.printDeltaTime) then
		love.graphics.print("DT:" .. deltaTime, self.x, self.y + 32)
	end 

	if(self.printLoveFPS) then
		love.graphics.print("LoveFPS:" .. love.timer.getFPS(), self.x, self.y + 16)
	end 

end 


---------------
-- Static End
---------------

return FrameCounter



-- Notes
-------------
-- should pipe this thru Debug Text
-- but meh, will move it later
-- :P
