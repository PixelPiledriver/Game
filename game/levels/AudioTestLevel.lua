--******************************************************************--
-- AudioTestLevel.lua
-- A place for storing my stuffty Love2D audio test code
-- writen by Adam Balk, September 2014
--******************************************************************--

-------------
-- Requires
--------------
local AudioComponent = require("AudioComponent")
local Input = require("Input")

local Start = function()
	
	local gameObject = {}
	ObjectManager:Add{gameObject}

	gameObject.AudioComponent = AudioComponent:New
	{
		parent = gameObject
	}

	gameObject.Input = Input:New
	{
		parent = gameObject
	}

	gameObject.AudioComponent:CreateSoundData("WilhelmScream.ogg")
	gameObject.AudioComponent:CreateSoundData("SuperMarioWorld.mp3")
	gameObject.AudioComponent:StoreNewSoundSource ("SuperMarioWorld.mp3", "BGMusic", "stream")

	-- select action
	local PlayBGMusic =
	{
		" ", "press",
		function() 
			if(gameObject.AudioComponent:IsPlaying("BGMusic")) then
				gameObject.AudioComponent:Pause("BGMusic")
				print("PAUSE background music")			
			else
				gameObject.AudioComponent:Play("BGMusic")
				print("PLAY background music")			
			end
		end 
	}

	local PlaySFX =
	{
		"a", "press",
		function()
			gameObject.AudioComponent:PlaySFX("WilhelmScream.ogg")
			print("Play SFX")			
		end 
	}

	local StopBGMusic =
	{
		"s", "press",
		function()
			gameObject.AudioComponent:Stop("BGMusic")
			print("STOP background music")			
		end 
	}

	local VolumeUp =
	{
		"up", "press",
		function()
			local currVol = gameObject.AudioComponent:GetVolume("BGMusic")
			currVol = currVol + 0.1
			gameObject.AudioComponent:SetVolume("BGMusic", currVol)
			print("Current Volume: " .. currVol)
		end 
	}

	local VolumeDown =
	{
		"down", "press",
		function()
			local currVol = gameObject.AudioComponent:GetVolume("BGMusic")
			currVol = currVol - 0.1
			gameObject.AudioComponent:SetVolume("BGMusic", currVol)
			print("Current Volume: " .. currVol)			
		end 	
	}

	-- Looping 
	-- function o:ToggleLooping(soundSourceName)
	-- function o:SetLooping(soundSourceName, isLooping)
	-- function o:isLooping(soundSourceName)


	gameObject.Input:AddKeys
	{
		PlaySFX, PlayBGMusic, StopBGMusic, VolumeUp, VolumeDown
	}

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