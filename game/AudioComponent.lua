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
	if(data.parent == nil) then
		print("AudioComponent requires a parent!")
		return
	end

	local o = {}
	o.parent = data.parent	
	-- Table of SoundData objects (ID'd by filenames) this AudioComponent contains
	-- key: audio fileName
	-- data: love2D soundData object
	-- this Audio component will only play sounds found in its SoundData table
	o.SoundData = {}

	-- key: soundSourceName
	-- data: love2D soundSource object
	-- this is where this AudioComponent will store soundSources created with the StoreNewSoundSource method
	o.SoundSources = {}

	-- TODO: How do I make this actually private?
	-- Private Table DO NOT ACCESS
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

	-- key: fileName
	-- data: love2D soundData object
	-- The AudioComponent will only play sounds listed in its SoundData table
	function o:CreateSoundData(fileName)
		if (o.SoundData[fileName] ~= nil) then			
			printDebug{"Did not create " .. fileName .. " SoundData already exists with that name", "AudioComponent"}
			return --already exists
		end
		soundData = love.sound.newSoundData("sounds/" .. fileName)
		o.SoundData[fileName] = soundData 
		-- default to static sound
		soundSource = love.audio.newSource(soundData, stream or "static")
		o.SoundSourceMasters[fileName] = soundSource
	end

	-- Creates new soundsource object to be used by this AudioComponent 
	-- and appends it to the SoundSources table
	-- key: fileName
	-- data: love2D soundData object
	function o:StoreNewSoundSource(fileName, soundSourceName, stream)		
		--if it doesn't exist in the SoundData table
		if (o.SoundData[fileName] == nil) then
			printDebug{"Could not create " .. soundSourceName .. ". Did you call  CreateSoundData(" .. fileName .. ")?", "AudioComponent"}			
			return --already exists
		end
		soundData = o.SoundData[fileName]
		-- default to static sound
		soundSource = love.audio.newSource(soundData, stream or "static");
		o.SoundSources[soundSourceName] = soundSource;
	end

	----------------------------------------------------------------------
	-- Basic Methods for Playing Audio  --
	----------------------------------------------------------------------

	-- if you don't care about manipulating the sound, you can just play the sound
	-- using this function and forget about it 
	function o:PlaySFX(fileName)
		if(o.SoundSourceMasters[fileName] == nil) then			
			return
		end		
		soundSourceClone = o.SoundSourceMasters[fileName]:clone()		
		soundSourceClone:play()
	end

	function o:Play(soundSourceName)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end		
		o.SoundSources[soundSourceName]:play()
	end

	function o:IsPlaying(soundSourceName)
		return o.SoundSources[soundSourceName]:isPlaying()
	end

	function o:Pause(soundSourceName)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end		
		o.SoundSources[soundSourceName]:pause()
	end

	-- Toggles between Play/Pause for a soundSource
	function o:TogglePlay(soundSourceName)
		if(o.SoundSources[soundSourceName] == nil) then
			--TODO: Add messages so these sort of things don't fail silently			
			return
		end				
		if(o:IsPlaying(soundSourceName)) then
			o:Pause(soundSourceName)
		else
			o:Play(soundSourceName)
		end
	end



	function o:Stop(soundSourceName)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end		
		o.SoundSources[soundSourceName]:stop()
	end

	-- Volume for SoundSources 
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

	function o:VolumeUp(soundSourceName, volIncrement)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end
		local currVol = o:GetVolume(soundSourceName)
		if ((currVol+volIncrement) > 1) then
			o.SoundSources[soundSourceName]:setVolume(1)
		else
			o.SoundSources[soundSourceName]:setVolume(currVol+volIncrement)
		end
	end

	function o:VolumeDown(soundSourceName, volIncrement)
		if(o.SoundSources[soundSourceName] == nil) then			
			return
		end
		local currVol = o:GetVolume(soundSourceName)
		if ((currVol-volIncrement) < 0) then
			o.SoundSources[soundSourceName]:setVolume(0)
		else
			o.SoundSources[soundSourceName]:setVolume(currVol-volIncrement)
		end
	end

	-- Looping for SoundSources 
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