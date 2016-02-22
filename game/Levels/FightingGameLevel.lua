-- FightingGameLevel.lua

-- Description
---------------------------------------
-- fighting game style objects and gameplay
local FightManager = require("FightManager")
local LifeBar = require("LifeBar")
local FightCharacter = require("FightCharacter")
require("FightCharacter_Sprites")
---------------------------------------------------------

local Start = function()
	FightManager.players[1].LifeBar = LifeBar:New
	{
		align = "right",
	}

	FightManager.players[2].LifeBar = LifeBar:New
	{
		align = "left",
		x = 450
	}

	local red = FightCharacter:New
	{
		characterName = "red",
		FightManager = FightManager,
		playerIndex = 1
	}
	
	local blue = FightCharacter:New
	{
		characterName = "blue",
		FightManager = FightManager,
		playerIndex = 2
	}

	FightManager:AddCharacter(red, 1)
	FightManager:AddCharacter(blue, 2)

	FightManager:StartNewRound()

end

local Update = function()
end

local Restart = function()
end 

local Exit = function()
end



local level = Level:New
{
	Start = Start,
	Update = Update,
	Restart = Restart,
	Exit = Exit,

	filename = "FightingGameLevel"
}

return level