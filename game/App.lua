
local App = {}



function App:QuitGameInput(key)
	-- exit game
	if(key == "escape") then
		love.event.quit()
	end 

end 

function App:Input(key)
	self:QuitGameInput(key)
end 







return App