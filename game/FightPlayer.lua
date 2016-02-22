-- FightPlayer.lua


----------------
-- Requires
----------------
local Text = require("Text")

----------------------------------------------------
local FightPlayer = {}



-----------------
-- Object
-----------------

function FightPlayer:New(data)

	local o = {}

	o.LifeBar = nil
	o.controls = nil

	o.wins = 0
	o.winsText = Text:New
	{
		text = 0,
		x = 100,
		y = 300	
	}

	o.character = nil

	--------------------
	-- Functions 
	--------------------
	function o:AddWin()
		self.wins = self.wins + 1
		o.winsText.text = self.wins
	end 



	return o
end 



-----------------
-- Static End 
-----------------

ObjectManager:AddStatic(FightPlayer)

return FightPlayer