-- Game
-- shit about the game


local Game = {}



-- CollisionLists.lua kinda replaces this shit
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

return Game