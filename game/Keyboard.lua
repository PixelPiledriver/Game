-- Keyboard
-- wrapper for love.keyboard

-- WTF BRO
-- this file does nothing at all
-- >:L

-- lets make this global just for fun

Keyboard = {}


function Key(k)
	return love.keyboard.isDown(k)
end

function Keyboard:key(k)
	return love.keyboard.isDown(k)
end 




