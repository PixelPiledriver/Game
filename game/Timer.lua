--******************************************************************--
-- Timer.lua
-- Class for timer objects
-- writen by Adam Balk, August 2014
--*******************************************************************--

------------------------------------------------------

local Timer = {}

----------------
-- Static Info
----------------

Timer.Info = Info:New
{
	objectType = "Timer",
	dataType = "Time",
	structureTe = "Static"
}


-------------
-- Object
-------------

function Timer:New(data)
	
	local o = {}	

	-------------
	-- Info
	-------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Timer",
		dataType = "Time",
		structureType = "Object"
	}

	function o:GetDeltaTimeSec()
		return love.timer.getTime() - self.StartTime
	end

	function o:GetDeltaTimeMs()
		return love.timer.getTime() * 1000 - self.StartTime * 1000 
	end

	function o:StartTimer()
		self.StartTime = love.timer.getTime()	
	end

	function o:ResetTimer()
		self.StartTime = love.timer.getTime()
	end

	-- return x amount of time has passed (in seconds)
	function o:TimeElapsedSec(numofSeconds)
		if(GetDeltaTimeSec >= numofSeconds) then
			return true
		end
	end

	-- return x amount of time has passed (in milliseconds)
	function o:TimeElapsedMs(numofMilliseconds)
		if(o:GetDeltaTimeMs() >= numofMilliseconds) then
			return true
		end
	end

	o:StartTimer()


	function o:Destroy()
		ObjectUpdater:Destroy(o.Info)
	end 

	-------------
	-- End
	-------------

	return o

end


return Timer


-- Notes
--------------------
-- old