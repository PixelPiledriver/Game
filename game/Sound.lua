-- Sound objects
-- writen by Adam Balk
-- on this day, the sixth day of May
-- in the two-thousand and fourteenth year
-- of our Lord and Savior Jesus Christ

-- new empty table
local Sound = {}

-- Used for larger audio files, like music
function Sound:NewStream(fileName)
	return love.audio.newSource("sounds/" .. fileName, "stream")
end

-- Used for smaller audio files, like sfx
function Sound:NewSFX(fileName)
	return love.audio.newSource("sounds/" .. fileName, "static")
end

return Sound