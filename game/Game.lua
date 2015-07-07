-- Game.lua
-->OLD

-- Purpose
----------------------------
-- Manages higher concepts of the game


-------------------------------------------------------------------------------

local Game = {}


-------------------
-- Static Info
-------------------
Game.Info = Info:New
{
	objecType = "Game",
	dataType = "Manager",
	structureType = "Static"
}

-------------------
-- Static Vars
-------------------

Game.playersInPlay = {"redRobot", "blueRobot"}


function Game:GetAllOtherPlayers(playerName)
	local temp = {}

	for i=1, #self.playersInPlay do
		if(self.playersInPlay[i] ~= "playerName") then
			temp[#temp + 1] = self.playersInPlay[i]
		end 
	end 

	return temp
end 


---------------
-- Static End
---------------

ObjectUpdater:AddStatic(Game)

return Game



-- Notes
---------------------------------------
-- This file is very incomplete and needs to be refactored
-- may have very little to do with the new game engine