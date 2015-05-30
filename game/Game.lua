-- Game
-- shit about the game


local Game = {}

-------------------
-- Static Vars
--------------------

-- object
Game.name = "Game"
Game.oType = "Static"
Game.dataType = "Manager"


-- CollisionLists.lua kinda replaces this shit
-- hrmmmmmmmm :L --> Depricate???
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


ObjectUpdater:AddStatic(Game)

return Game