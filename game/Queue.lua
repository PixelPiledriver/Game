-- Queue.lua
----------------
-- basic FIFO Queue data structure
------------------------------------------------------------------------------------------------
local Queue = {}

--Create new queue
function Queue:New()
	
	local o = {}

	o.first = 0;
	o.last = -1;

	-- Insert item in Queue:
	function o:Push (value)
		local last = self.last + 1
		self.last = last
		self[last] = value
		print(self[last]);
	end

	-- Remove item from Queue
	function o:Pop ()
		local first = self.first
		if (first > self.last) then 
			error("queue is empty") 
		end

		local value = self[first]
		self[first] = nil  -- to allow garbage collection
		self.first = first + 1
		return value
	end

	-- Returns the First item in the queue:
	function o:Peek ()
		local retVal = self[self.first]
		return retVal
	end

	return o;    
end

return Queue;