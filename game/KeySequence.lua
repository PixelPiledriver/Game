-- KeySequence.lua


-- Purpose
-------------------
-- list of keys
-- press in order to run function
-- can be used for double taps, fighting game moves, etc

-----------------------------------------------
local KeySequence = {}


function KeySequence:New(data)

	local o = {}

	o.list = data.list
	o.func = data.func
	o.index = 1

	o.resetAllOnComplete = true

	-- can player get key wrong? --> resets sequence to beginning
	o.fail = Bool:DataOrDefault(data.fail, false)

	o.timed = true
	o.timerMax = 15
	o.timer = 0


	---------------
	-- Functions
	---------------
	function o:Update()
		if(o.timer > 0) then
			o.timer = o.timer - 1
		end 

		-- time over, failed to do sequence fast enough
		if(o.timer == 1) then
			o:ResetIndex()
			o.timer = 0
		end 
	end 

	function o:TestKey(key)

		-- key is next in sequence?
		if(self.list[self.index] == key) then
			self.index = self.index + 1

			self.timer = self.timerMax


			-- sequence complete?
			if(self.index > #self.list) then
				print("KeySequence Complete! <3")
				self:func()
				self.index = 1

				-- end timer
				self.timer = 0

				if(self.resetAllOnComplete) then
					return true
				end

			end

		else 
			if(self.fail) then
				self:ResetIndex()
			end
		end 

	end 

	function o:ResetIndex()
		self.index = 1
	end 

	-----------
	-- End
	-----------

	ObjectManager:Add{o}

	return o
end


-----------------
-- Static End
-----------------


return KeySequence


-- Notes
-----------------
-- need
-- timer based --> counts down and resets itself
-- strict --> if you get the next input wrong it resets itself
