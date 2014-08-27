-- use to get colors by name
-- and other stuff

local Random = require("Random")

local Color = {}



Color.red = {255,0,0,255}
Color.darkRed = {100,0,0,255}
Color.blue = {0,0,255,255}
Color.darkBlue = {0,0,100,255}
Color.green = {0,255,0,255}
Color.white = {255,255,255,255}
Color.black = {0,0,0,255}
Color.purple = {128, 0, 255, 255}
Color.index = {"red", "darkRed", "blue", "darkBlue", 
							 "green", "white", "black", "purple"}


function Color:Get(name)

	if(name == "random") then
		name = Random:ChooseRandomlyFrom(Color.index)
	end 

	local copy =
	{
		Color[name][1],
		Color[name][2],
		Color[name][3],
		Color[name][4]
	}
	
	return copy
end

-- compare two colors for equality
function Color:Equal(a,b)
	
	if(a[1] ~= b[1]) then
		return false
	end 

	if(a[2] ~= b[2]) then
		return false
	end 

	if(a[3] ~= b[3]) then
		return false
	end 

	return true
end 

-- add two colors together
-- {a, b}
function Color:Add(data)
	local newColor = {}

	newColor[1] = data.a[1] + data.b[1]
	newColor[2] = data.a[2] + data.b[2]
	newColor[3] = data.a[3] + data.b[3]

	if(data.loop == false) then

		if(newColor[1] > 255) then
			newColor[1] = 255
		end 

		if(newColor[2] > 255) then
			newColor[2] = 255
		end 

		if(newColor[3] > 255) then
			newColor[3] = 255
		end 

	end 

	return newColor
end 

-- subtracct color b from color a
-- {a, b, loop}
function Color:Sub(data)
	local newColor = {}

	newColor[1] = data.a[1] - data.b[1]
	newColor[2] = data.a[2] - data.b[2]
	newColor[3] = data.a[3] - data.b[3]

	if(data.loop == false) then
		
		if(newColor[1] < 0) then
			newColor[1] = 0
		end 

		if(newColor[2] < 0) then
			newColor[2] = 0
		end 

		if(newColor[3] < 0) then
			newColor[3] = 0
		end 


	end 

	return newColor
end 


--{color, min, max}
function Color:Clamp(data)

	-- min 	
	if(data.color[1] < data.min) then
		data.color[1] = data.min
	end 

	if(data.color[2] < data.min) then
		data.color[2] = data.min
	end 

	if(data.color[3] < data.min) then
		data.color[3] = data.min
	end 

	-- max
	if(data.color[1] > data.max) then
		data.color[1] = data.max
	end 

	if(data.color[2] > data.max) then
		data.color[2] = data.max
	end 

	if(data.color[3] > data.max) then
		data.color[3] = data.max
	end 


end 

--{a, b, p}
function Color:Lerp(data)

	local newColor = {}

	newColor[1] =  data.a[1] + ((data.b[1] - data.a[1]) * p)
	newColor[2] =  data.a[2] + ((data.b[2] - data.a[2]) * p)
	newColor[3] =  data.a[3] + ((data.b[3] - data.a[3]) * p)

	-- alpha
	if(data.alpha ) then
		newColor[4] =  data.a[4] + ((data.b[4] - data.a[4]) * p)
	else
		newColor[4] =  data.a[4]
	end 

	return newColor

end 











-- done
return Color
