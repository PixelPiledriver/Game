--******************************************************************--
-- AudioTestLevel.lua
-- A place for storing my stuffty Love2D audio test code
-- writen by Adam Balk, September 2014
--******************************************************************--

-------------
-- Requires
--------------
local AudioComponent = require("AudioComponent")
local MasterAudio = require("MasterAudio")
local Input = require("Input")

local Start = function()
	
	local gameObject = {}
	ObjectManager:Add{gameObject}

	gameObject.AudioComponent = AudioComponent:New
	{
		parent = gameObject
	}

	gameObject.Input = Input:New{}

	gameObject.AudioComponent:CreateSoundData("WilhelmScream.ogg")
	gameObject.AudioComponent:CreateSoundData("SuperMarioWorld.mp3")
	gameObject.AudioComponent:StoreNewSoundSource ("SuperMarioWorld.mp3", "BGMusic", "stream")
	gameObject.AudioComponent:StoreNewSoundSource ("WilhelmScream.ogg", "Wilhelm")

	-- select action
	local PlayBGMusic =
	{
		" ", "press",
		function() 
			gameObject.AudioComponent:TogglePlay("BGMusic")
			if(gameObject.AudioComponent:IsPlaying("BGMusic")) then
				print("PLAY background music")			
			else
				print("PAUSE background music")			
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
		"up", "hold",
		function()
			gameObject.AudioComponent:VolumeUp("BGMusic", 0.01)
			print("Current Volume: " .. gameObject.AudioComponent:GetVolume("BGMusic"))
		end 
	}

	local VolumeDown =
	{
		"down", "hold",
		function()
			gameObject.AudioComponent:VolumeDown("BGMusic", 0.01)
			print("Current Volume: " .. gameObject.AudioComponent:GetVolume("BGMusic"))			
		end 	
	}

	local PlayWilhelm =
	{
		"f", "press",
		function()				
			gameObject.AudioComponent:Play("Wilhelm")
			print("PLAY Wilhelm soundSource")			
		end 	
	}	

	local ToggleLoop =
	{
		"d", "press",
		function()				
			gameObject.AudioComponent:ToggleLooping("Wilhelm")
			print(gameObject.AudioComponent:isLooping("Wilhelm"))			
		end 	
	}

	local MasterDown =
	{
		"left", "press",
		function()				
			MasterAudio:MasterVolumeDown(0.1)
			print("Master Volume: " .. MasterAudio:GetMasterVolume())
		end 	
	}

	local MasterUp =
	{
		"right", "press",
		function()				
			MasterAudio:MasterVolumeUp(0.1)
			print("Master Volume: " .. MasterAudio:GetMasterVolume())			
		end 	
	}

	local MasterPlayPause =
	{
		"v", "press",
		function()				
			MasterAudio:ToggleAllAudio()
			if(MasterAudio.paused) then
				print("PAUSE Master Volume")
			else
				print("RESUME Master Volume")
			end
		end 	
	}

	local MasterStop =
	{
		"b", "press",
		function()				
			MasterAudio:StopAllAudio()
			print("STOP Master Volume")
		end 	
	}
	
	gameObject.Input:AddKeys
	{
		PlaySFX,     PlayBGMusic, StopBGMusic, VolumeUp, VolumeDown, 
		PlayWilhelm, ToggleLoop,  MasterDown,  MasterUp, MasterPlayPause,
		MasterStop 
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