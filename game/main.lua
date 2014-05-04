
-- dis iz the main file nigga!!
-- dont be fuckin round wit my mainz!!!!!


-- add shit to the stuff
require("ConsoleSetup")


-- game start
function love.load()
	-- load shit
	-- build shit
	-- take a shit --> no really --> go take a shit
end 


local time = 0
local frameCount = 0
local fps = 0
local updateRate = 4


function love.update(dt)
	frameCount = frameCount + 1
	time = time + dt

	if(time > 1/updateRate) then
		fps = frameCount / dt
		frameCount = 0
		time =  time - (1/updateRate)
	end 

	printDebug{"shit is nutz", "stuff"}

end 



-- draw call
-- draw your stuff
-- make the pretties
function love.draw()
	love.graphics.print(fps, 100, 100)
end 


