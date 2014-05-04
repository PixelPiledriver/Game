
Math = {}


-- rounds down a decimal to a whole number
function Math.floor(number)
	return number - number % 1
end 


return Math