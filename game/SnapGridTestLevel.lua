--******************************************************************--
-- Timer.lua
-- Class for timer objects
-- writen by Adam Balk, August 2014
--*******************************************************************--


-- SnapGridTestLevel.lua


local SnapGrid = require("SnapGrid") 

local SnapGridTestLevel = {}


function SnapGridTestLevel:Load()
	SnapGrid:CreateBoard()
end

function SnapGridTestLevel:Update()

end

function SnapGridTestLevel:Exit()
end

return SnapGridTestLevel 