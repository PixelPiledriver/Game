--******************************************************************--
-- StudyLevel.lua
-- 1st Test Level (attempts to mitigate out scene specifics to a file 
-- seperate from main)
-- writen by Adam Balk, September 2014
--******************************************************************--


-- Table to hold Level objects
local StudyLevel = {}

-- On Level Start
function StudyLevel:Load()

stuff = [[
whats up
with the
monkey on
your shoulder
]]

print(stuff)
	
end

-- On Level Update
function StudyLevel:Update()
	
end

-- On Level End
function StudyLevel:Exit()

end

return StudyLevel