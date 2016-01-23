----------------------------------------------------------------------
-- MasterAudio.lua
-- Master Sound Functions (affects all in-game audio)
-- just wrappers around love audio functions that affect global audio
-- Adam Balk, Dec. 2015
----------------------------------------------------------------------

local MasterAudio = {}

MasterAudio.paused = false

-- number value scale of 0.0 (silent) to 1.0 (max volume)
function MasterAudio:GetMasterVolume()
	return love.audio.getVolume();
end

function MasterAudio:SetMasterVolume(newVolume)
	love.audio.setVolume(newVolume)
end

function MasterAudio:MasterVolumeUp(volIncrement)
	local currMasterVol = MasterAudio:GetMasterVolume()
	if ((currMasterVol+volIncrement) > 1) then
		love.audio.setVolume(1)
	else		
		love.audio.setVolume(currMasterVol + volIncrement)
	end
end

function MasterAudio:MasterVolumeDown(volDecrement)
	local currMasterVol = MasterAudio:GetMasterVolume()
	if ((currMasterVol-volDecrement) < 0) then
		love.audio.setVolume(0)
	else		
		love.audio.setVolume(currMasterVol-volDecrement)
	end
end

function MasterAudio:StopAllAudio()
	love.audio.stop()
end

function MasterAudio:PauseAllAudio()
	MasterAudio.paused = true
	love.audio.pause()
end

function MasterAudio:ResumeAllAudio()
	MasterAudio.paused = false
	love.audio.resume()
end

function MasterAudio:ToggleAllAudio()
	if(MasterAudio.paused) then
		MasterAudio:ResumeAllAudio()
	else
		MasterAudio:PauseAllAudio()
	end
end

return MasterAudio