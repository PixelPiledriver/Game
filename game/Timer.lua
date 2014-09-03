 --******************************************************************--
-- Timer.lua
-- Class for timer objects
-- writen by Adam Balk, August 2014
--************************************************************l******--

local Timer = {}

function Timer:New(data)
	
	local object = {}	

	function object:GetDeltaTimeSec()
		return love.timer.getTime() - self.StartTime
	end

	function object:GetDeltaTimeMs()
		return love.timer.getTime() * 1000 - self.StartTime * 1000 
	end

	function object:StartTimer()
		self.StartTime = love.timer.getTime()	
	end

	function object:ResetTimer()
		self.StartTime = love.timer.getTime()
	end

	-- return x amount of time has passed (in seconds)
	function object:TimeElapsedSec(numofSeconds)
		if(GetDeltaTimeSec >= numofSeconds) then
			return true
		end
	end

	-- return x amount of time has passed (in milliseconds)
	function object:TimeElapsedMs(numofMilliseconds)
		if(object:GetDeltaTimeMs() >= numofMilliseconds) then
			return true
		end
	end

	object:StartTimer()
	
	return object
end
return Timer