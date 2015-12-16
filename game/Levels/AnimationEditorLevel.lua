-- AnimationEditorLevel.lua

-- Description
----------------------------------------
-- testing out the animation editor

----------------
-- Requires
----------------
local AnimationEditor = nil
local SpriteSheet = require("SpriteSheet")

---------------------------------------------------

local mouse = nil

local Start = function()

	mouse = Mouse:New{name = "mouse"}

	AnimationEditor = require("AnimationEditor")

	local pawnSheet = SpriteSheet:New
	{
		image = "pawnSheet.png",
		spriteWidth = 64,
		spriteHeight = 64
	}

	AnimationEditor:Setup()
	AnimationEditor:LoadSpriteSheet(pawnSheet)



end 

local Update = function()
end

local Exit = function()
	AnimationEditor:Exit()
end

local Restart = function()
	ObjectManager:Destroy(mouse)
end 


local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "AnimationEditorLevel"
}

return level
