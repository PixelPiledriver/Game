--******************************************************************--
-- AudioTestLevel.lua
-- A place for storing my stuffty Love2D audio test code
-- writen by Adam Balk, September 2014
--******************************************************************--


-- NOTE: Adam, you need to change these sounds to use Clone() 
--       instead of creating new ones. C'mon man. Get your stuff together.

-- audio testing
--[[	source = Sound.CreateSoundSource("WilhelmScream.ogg")
	Sound.SetVolume(source, 0.5)
	print(Sound.GetVolume(source))
	Sound.ToggleLooping(source)
	Sound.PlaySource(source)
]]


-- if(love.keyboard.isDown("1")) then
-- 	Sound.PlayStreamLoop("SuperMarioWorld.mp3")
-- end


local Start = function()
end 

local Update = function()
end

local Exit = function()
end

local Restart = function()
end 


local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "AudioTestLevel"
}

return level



-- Notes
--------------------------
-- not sure if this level has any value anymore
-- but will leave it for now until I take another look at audio