-- Keyboard
-- wrapper for love.keyboard

-- lets make this global just for fun

Keyboard = {}


function Key(k)
	return love.keyboard.isDown(k)
end

function Keyboard:key(k)
	return love.keyboard.isDown(k)
end 




