-- FightCharacter.lua

-- Description
------------------------
-- fight game type character

local Pos = require("Pos")
local Box = require("Box")
local SpriteBank = require("SpriteBank")
local Input = require("Input")
local AnimationComponent = require("AnimationComponent")
local Collision = require("Collision")
local AudioComponent = require("AudioComponent")
------------------------------------------------

local FightCharacter = {}

-------------------
-- Static Info
-------------------
Box.Info = Info:New
{
	objectType = "FightCharacter",
	dataType = "FightObject",
	structureType = "Static"
}


function FightCharacter:New(data)
	
	local o = {}

	-----------
	-- Info
	-----------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "FightCharacter",
		dataType = "FightingObject",
		structureType = "Object"
	}

	-----------
	-- Vars
	-----------
	o.moveSpeed = 3
	o.dashSpeed = 12
	o.playerIndex = data.playerIndex or 1
	o.characterName = data.characterName or "blue"


	o.opponentIndex = nil
	if(o.playerIndex == 1) then
		o.opponentIndex = 2
	else
		o.opponentIndex = 1
	end 

	o.direction = {}


	---------------
	-- Graphics
	---------------
	--o.sprite = FightCharacter.SpriteBank:Get("blueIdle")
	--o.sprite.parent = o

	o.AnimationComponent = AnimationComponent:New{parent = o}

	-- add animations
	o.AnimationComponent:Add
	{
		name = "idle",
		animation = FightCharacter.Sprites[o.characterName]:GetAnimation("idle")
	}

	o.AnimationComponent:Add
	{
		name = "punch",
		animation = FightCharacter.Sprites[o.characterName]:GetAnimation("punch")
	}

	o.AnimationComponent:Add
	{
		name = "fireball",
		animation = FightCharacter.Sprites[o.characterName]:GetAnimation("fireball")
	}

	o.AnimationComponent:Add
	{
		name = "spinKick",
		animation = FightCharacter.Sprites[o.characterName]:GetAnimation("spinKick")
	}

	--o.sprite.draw = false

	------------
	-- Audio
	------------
	o.AudioComponent = AudioComponent:New{parent = o}
	o.AudioComponent:CreateSoundData("punch.wav")
	o.AudioComponent:CreateSoundData("fireball.wav")
	o.AudioComponent:CreateSoundData("spinKick.wav")

	-----------------
	-- Components
	-----------------
	o.FightManager = data.FightManager

	o.Pos = Pos:New
	{
		x = o.FightManager.stage.playerStart[o.playerIndex].x,
		y = o.FightManager.stage.playerStart[o.playerIndex].y,
		--gravity = 0.1
	}

	-----------------
	-- Input
	-----------------

	o.controls = o.FightManager.players[o.playerIndex].controls
	--[[
	o.controls.direction = 
	{
		left = 
		{
			left = o.controls.right,
			right = o.controls.left
		},

		right =
		{
			left = o.controls.left,
			right = o.controls.right
		}
	}
	--]]

	o.Input = Input:New{}

	---[[
	o.Input:AddConvertKey
	{
		mode = "left",
		key = "a",
		keyConvertsTo = "d"
	}

	o.Input:AddConvertKey
	{
		mode = "left",
		key = "d",
		keyConvertsTo = "a"
	}

	--]]

	local moveRight =
	{
		o.controls.right, "hold",
		function()
			o.Pos:Move{x = o.moveSpeed}

			-- edge of screen stop
			if(o.Pos.x > o.FightManager.stage:RightEdge()) then
				o.Pos.x = o.FightManager.stage:RightEdge()
			end 

		end 
	}

	local moveLeft =
	{
		o.controls.left, "hold",
		function()
			o.Pos:Move{x = -o.moveSpeed}

			-- edge of screen stop
			if(o.Pos.x < o.FightManager.stage:LeftEdge()) then
				o.Pos.x = o.FightManager.stage:LeftEdge()
			end 

		end 
	}

	local punch =
	{
		o.controls.punch, "press",
		function()
			
			if(o.FightManager.attacksActive == false) then
				return
			end 

			o.AnimationComponent:State("punch")
			o.FightManager:AttackOpponent(5, o.opponentIndex)
			o.AudioComponent:PlaySFX("punch.wav")
		end 
	}

	o.Input:AddKeys
	{
		moveRight, moveLeft, punch,
		dashRight
	}

	--------------------
	-- Key Sequences
	--------------------
	local dashRight = 
	{
		list = {o.controls.right, o.controls.right},
		func = function()
			o.Pos.dash.right = o.dashSpeed
		end 	
	}

	local dashLeft = 
	{
		list = {o.controls.left, o.controls.left},
		func = function()
			o.Pos.dash.left = o.dashSpeed
		end 	
	}

	local fireball =
	{
		list = {o.controls.down, o.controls.right, o.controls.punch},
		func = function()

			if(o.FightManager.attacksActive == false) then
				return
			end 

			o.AnimationComponent:State("fireball")
			o.FightManager:AttackOpponent(20, o.opponentIndex)
			o.AudioComponent:PlaySFX("fireball.wav")
		end
	}

	local spinKick = 
	{
		list = {o.controls.down, o.controls.left, o.controls.punch},

		func = function()
			if(o.FightManager.attacksActive == false) then
				return
			end 

			o.AnimationComponent:State("spinKick")
			o.FightManager:AttackOpponent(20, o.opponentIndex)
			o.AudioComponent:PlaySFX("spinKick.wav")
		end

	}

	o.Input:AddSequences{dashLeft, dashRight, fireball, spinKick}

	------------------
 	-- Functions
 	------------------

 	function o:SetDirection(direction)
 		
 		if(self.playerIndex == 1) then
	 		--print(self.controls.left)
	 	end

 		self.direction = direction
 		
 		if(self.direction == "left") then
 			self.Input.convert.mode = "left"
 		else
 			self.Input.convert.mode = "right"
 		end

 		

 	end 


	-------------
	-- End
	-------------
	ObjectManager:Add{o}

	return o

end 

---------------
-- Static End
---------------

ObjectManager:AddStatic(FightCharacter)


return FightCharacter



-- Notes
----------------------
-- too tired
-- need
-- priority for input actions
-- put in buckets and take first and ignore rest
-- something like that