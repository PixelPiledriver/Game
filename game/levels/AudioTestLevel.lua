--******************************************************************--
-- AudioTestLevel.lua
-- A place for storing my shitty Love2D audio test code
-- writen by Adam Balk, September 2014
--******************************************************************--


-- NOTE: Adam, you need to change these sounds to use Clone() 
--       instead of creating new ones. C'mon man. Get your shit together.

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