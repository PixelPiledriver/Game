--******************************************************************--
-- Sound.lua
-- Love2D Sound System Wrapper
-- writen by Adam Balk, June 2014
--******************************************************************--

local Sound = {}

----------------------------------------------------------------------
-- Basic Methods for Playing Audio (probably main thing you'll use) --
----------------------------------------------------------------------
-- Used for larger audio files, like music
function Sound.PlayStream(fileName)
	sd = love.sound.newSoundData("sounds/" .. fileName)
	love.audio.newSource(sd, "stream"):play()
end

function Sound.PlayStreamLoop(fileName)
	sd = love.sound.newSoundData("sounds/" .. fileName)
	source = love.audio.newSource(sd, "stream")
	source:setLooping(true)
	source:play()
end

-- Used for typical audio files, like sfx
function Sound.Play(fileName)
	sd = love.sound.newSoundData("sounds/" .. fileName)
	love.audio.newSource(sd, "static"):play()
end

----------------------------------------------------------------------
-- Master Sound Functions (affects all in-game audio)
----------------------------------------------------------------------
-- number value scale of 0.0 (silent) to 1.0 (max volume)
function Sound.GetMasterVolume()
	return love.audio.getVolume();
end

function Sound.SetMasterVolume(newVolume)
	love.audio.setVolume(newVolume)
end

function Sound.StopAllAudio()
	love.audio.pause()
end

function Sound.PauseAllAudio()
	love.audio.stop()
end

----------------------------------------------------------------------
-- Individual Sound Source Function 
-- (allows for manipulation of sound before playing it)
-- example: playing a sound at a certain volume
----------------------------------------------------------------------
-- Create sound sound sources to manipulate
function Sound.CreateSoundSource(fileName)
	sd = love.sound.newSoundData("sounds/" .. fileName)
	return love.audio.newSource(sd, "static")
end

function Sound.CreateSoundSourceStream(fileName)
	sd = love.sound.newSoundData("sounds/" .. fileName)
	return love.audio.newSource(sd, "stream")
end

--Play/Pause/Stop
function Sound.PlaySource(soundSource)
	soundSource:play()
end
function Sound.PauseSource(soundSource)
	soundSource:pause()
end
function Sound.StopSource(soundSource)
	soundSource:stop()
end

-- Volume
function Sound.SetVolume(soundSource, newVolume)
	soundSource:setVolume(newVolume)
end

function Sound.GetVolume(soundSource)
	return soundSource:getVolume()
end

-- Looping 
function Sound.ToggleLooping(soundSource)
	soundSource:setLooping(not soundSource:isLooping()) 
end

function Sound.SetLooping(soundSource, isLooping)
	soundSource:setLooping(isLooping) 
end

function Sound.isLooping(soundSource)
	return soundSource:isLooping()
end

return Sound