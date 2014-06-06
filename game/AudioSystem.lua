-- Audio Interface file (pretty much just a lite wrapped around love.audio at the moment)
-- written by Adam Balk

-- Creat empty audio table to store functions
local AudioSystem = {}

function AudioSystem:Play(audioSource)
	if(audioSource == nil) then
		print("Specified sound is not valid", audioSource)
	end	
	love.audio.play(audioSource)
end

function AudioSystem:Pause(audioSource)
	-- if no params are specified, pause all audio
	if (audioSource == nil) then
		love.audio.pause()
	else
		love.audio.pause(audioSource)
	end
end

return AudioSystem

