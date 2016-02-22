-- FightManager.lua


local FightPlayer = require("FightPlayer")
local FightStage = require("FightStage")
local AudioComponent = require("AudioComponent")
--------------------------------------
local FightManager = {}

-----------------
-- Rules
-----------------

-- length of match
FightManager.timeMax = 99
FightManager.time = FightManager.timeMax

-- what the players are able to do
-- ex: during intro movement is active 
-- but attacks are not until FIGHT is announced
FightManager.movementActive = true
FightManager.attacksActive = true


---------------
-- Stage
---------------
FightManager.stage = FightStage

-----------
-- Sound
-----------
FightManager.AudioComponent = AudioComponent:New{parent = FightManager}
FightManager.AudioComponent:CreateSoundData("win.wav")

---------------
-- Players
---------------
FightManager.players = {}
FightManager.players[1] = FightPlayer:New{}
FightManager.players[2] = FightPlayer:New{}

FightManager.players[2].winsText.Pos.x = 200 


-------------
-- Controls
-------------
FightManager.players[1].controls =
{
	left = "a",
	right = "d",
	down = "s",
	punch = "h"	
}

FightManager.players[2].controls =
{
	left = "left",
	right = "right",
	down = "down",
	punch = "n"
}

FightManager.players[1].startX = 200
FightManager.players[2].startX = 400


---------------
-- Functions
---------------
function FightManager:AddCharacter(character, index)
	self.players[index].character = character
end 

-- no collision test attack
-- remove later
function FightManager:AttackOpponent(damage, opponentIndex)
	self.players[opponentIndex].LifeBar:Damage(damage)

	-- player died from last attack? --> search both players because attack could damage user
	for i=1, #self.players do
		if(self.players[i].LifeBar.hitpoints <= 0) then
			self:Victory(self:GetOppositePlayerIndex(i))
			self:StartNewRound()
		end 
	end 

end

function FightManager:StartNewRound()

	for i=1, #self.players do
		self.players[i].character.Pos.x = self.players[i].startX
		self.players[i].LifeBar.hitpoints = self.players[i].LifeBar.max
	end 

	self.time = self.timeMax

end 


function FightManager:Update()
	self:TimeAdvance()
end 

function FightManager:TimeAdvance()
	self.time = self.time - 1
end

-- get other player
function FightManager:GetOppositePlayerIndex(i)

	if(i == 2) then
		return 1
	end

	return 2

end 

function FightManager:Victory(playerIndex)
	print("Player " .. playerIndex .. " wins")

	self.players[playerIndex]:AddWin()

	self.AudioComponent:PlaySFX("win.wav")

end 

return FightManager