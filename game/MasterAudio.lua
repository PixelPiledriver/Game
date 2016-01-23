----------------------------------------------------------------------
-- MasterAudio.lua
-- Master Sound Functions (affects all in-game audio)
-- just wrappers around love audio functions that affect global audio
-- Adam Balk, Dec. 2015
----------------------------------------------------------------------

local MasterAudio = {}

-- number value scale of 0.0 (silent) to 1.0 (max volume)
function MasterAudio.GetMasterVolume()
	return love.audio.getVolume();
end

function MasterAudio.SetMasterVolume(newVolume)
	love.audio.setVolume(newVolume)
end

function MasterAudio.StopAllAudio()
	love.audio.stop()
end

function MasterAudio.PauseAllAudio()
	love.audio.pause()
end

return MasterAudio