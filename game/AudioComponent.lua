--******************************************************************--
-- Sound.lua
-- Love2D Sound System Wrapper
-- Adam Balk, June 2014 (Re-written January, 2016)
--******************************************************************--

---------------------------------------
local AudioComponent = {}

-----------------
-- Static Info 
-----------------
AudioComponent.Info = Info:New
{
	objectType = "AudioComponent",
	dataType = "Audio",
	structureType = "Static"
}

-----------------------
-- Static Functions
-----------------------
function AudioComponent:New(data)
-- Fail Check/Ensure this is being used as a component
	-- if(data.parent == nil) then
	-- 	print("parent required!")
	-- 	return
	-- end

	local o = {}
	o.parent = data.parent
	-- Table of SoundData objects (ID'd by filenames) this AudioComponent contains
	-- key: fileName
	-- data: love2D soundData object
	-- this Audio component will only play sounds found in its SoundData table
	o.SoundData = {}
	-- key: soundSourceName
	-- data: love2D soundSource object
	-- this is where this AudioComponent will store soundSources created with the SoundSource method
	o.SoundSources = {}
	-- o.PrivateSoundSources = {}

	-- How do I make this actually private?
	--Private Table
	o.SoundSourceMasters = {};

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "AudioComponent",
		dataType = "Audio",
		structureType = "Component"
	}

	function o:CreateSoundData(fileName)
		if (o.SoundData[fileName] ~= nil) then			
			printDebug{"Did not create " .. fileName .. " SoundData already exists with that name", "AudioComponent"}
			return --already exists
		end
		-- default to static sound
		-- 
		soundData = love.sound.newSoundData("sounds/" .. fileName)
		o.SoundData[fileName] = soundData 

		soundSource = love.audio.newSource(soundData, stream or "static")
		o.SoundSourceMasters[fileName] = soundSource
	end

	-- Creates new soundsource object to be used by this AudioComponent 
	-- and appends it to the SoundSources table
	-- key: fileName
	-- data: love2D soundData object

	-- NOTE TO SELF WHEN LESS HIGH:
	-- make a comment about the design paradigm of the naming behind the last variable of this function,
	-- and how this naming/design pattern can be future applied in binary "this or that" scenarios
	-- Hah. 
	-- Hmm.
	-- I don't really like this pattern anymore....Maybe the variable should be self evident that it is 
	-- in fact a "this or that" variable
	--streamOR?
	function o:StoreNewSoundSource(fileName, soundSourceName, stream)		
		--if it doesn't exist in the SoundData table
		if (o.SoundData[soundSourceName] ~= nil) then
			printDebug{"Did not create " .. soundSourceName .. " SoundSource already exists with that name", "AudioComponent"}			
			return --already exists
		end
		-- default to static sound
		soundSource = love.audio.newSource(soundData, stream or "static");
		o.SoundSources[soundSourceName] = soundSource;
	end

	--TO DO: Make more robust print methods for AudioComponent
	-- you copy pasta'd this shit from the internet when you were stoned
	-- figure out a better way to do this, ya jackass
	function o:PrintSoundSources()
		for k, v in pairs(o.SoundSources) do
   			print(k, v)
		end
	end
	----------------------------------------------------------------------
	-- Basic Methods for Playing Audio  --
	----------------------------------------------------------------------
	-- Play/Pause/Stop
	-- if you don't care about manipulating the sound, you can just play the sound
	-- using this function and forget about it 
	function o:PlaySFX(fileName)
		if(o.SoundSourceMasters[fileName] == nil) then			
			return
		end		
		soundSourceClone = o.SoundSourceMasters[fileName]:clone()		
		soundSourceClone:play()
	end

	-- For the stop and pause methods to make sense, we need to make sure
	-- we're grabbing a particular soundSource

	-- These functions are only used to manipulate SoundSources
	function o:Play(soundSourceName)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end		
		o.SoundSources[soundSourceName]:play()
	end

	-- Returns whether or not this soundSource is currently playing
	function o:IsPlaying(soundSourceName)
		return o.SoundSources[soundSourceName]:isPlaying()
	end

	function o:Pause(soundSourceName)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end		
		o.SoundSources[soundSourceName]:pause()
	end

	function o:Stop(soundSourceName)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end		
		o.SoundSources[soundSourceName]:stop()
	end

	-- Volume
	function o:SetVolume(soundSourceName, newVolume)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end
		local currVol = o:GetVolume(soundSourceName)
		if ((newVolume) > 1) then
			o.SoundSources[soundSourceName]:setVolume(1)
		elseif ((newVolume) < 0) then
			o.SoundSources[soundSourceName]:setVolume(0)
		else				
			o.SoundSources[soundSourceName]:setVolume(newVolume)
		end
	end

	function o:GetVolume(soundSourceName)
		return o.SoundSources[soundSourceName]:getVolume()
	end

	-- Looping 
	function o:ToggleLooping(soundSourceName)
		o.SoundSources[soundSourceName]:setLooping(not o.SoundSources[soundSourceName]:isLooping()) 
	end

	function o:SetLooping(soundSourceName, isLooping)
		o.SoundSources[soundSourceName]:setLooping(isLooping) 
	end

	function o:isLooping(soundSourceName)
		return o.SoundSources[soundSourceName]:isLooping()
	end

	----------
	-- End
	----------
	ObjectManager:Add{o}

	return o
	
end 


----------------
-- Static End
----------------
ObjectManager:AddStatic(AudioComponent)

return AudioComponent