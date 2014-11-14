-- TextfileWriter.lua
-- can read and write text file with simple function calls
-- use for modifying large chunks of similar code and other things etc


local Textfile = {}


function Textfile:New(data)

	local object = {}

	-------------------------------
	-- Create
	-------------------------------

	object.textTable = {}
	object.text = data.text or ""
	object.filename = data.filename or "textFile"

	-------------------------------
	-- Functions
	-------------------------------

	function object:AddLine(txt)
		object.text = object.text .. "\r\n" .. txt 
	end 

	--{text = {...}, spaceBetweenEach = bool}
	function object:AddLineFromTable(data)

		object.text = object.text .. "\r\n"

		for i=1, #data.text do
			object.text = object.text .. data.text[i] .. " "
		end 

	end 

	function object:Save()
		love.filesystem.write(object.filename, object.text)
	end

	-- reads the whole file into a single string
	function object:Read()
		self.text = love.filesystem.read(self.filename)
	end 
	-- reads each line into a seperate index of a table
	function object:ReadLines()
		for line in love.filesystem.lines(self.filename) do
			self.textTable[#self.textTable + 1] = line
		end 
	end 

	return object

end 



return Textfile