-- TextfileWriter.lua

-- Purpose
---------------------
-- can read and write text file with simple function calls
-- use for modifying large chunks of similar code and other things etc

-----------------------------------------------------------

local Textfile = {}

-----------------
-- Static Info
-----------------
Textfile.Info = Info:New
{
	objectType = "Textfile",
	dataType = "File IO",
	structureType = "Static"
}


------------
-- Object
------------
function Textfile:New(data)

	local o = {}

	------------
	-- Info
	------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Textfile",
		dataType = "File IO",
		structureType = "Object"
	}

	------------
	-- Vars
	------------

	o.textTable = {}
	o.text = data.text or ""
	o.filename = data.filename or "textFile"

	-------------------------------
	-- Functions
	-------------------------------

	function o:AddLine(txt)
		o.text = o.text .. "\r\n" .. txt 
	end 

	--{text = {...}, spaceBetweenEach = bool}
	function o:AddLineFromTable(data)

		o.text = o.text .. "\r\n"

		for i=1, #data.text do
			o.text = o.text .. data.text[i] .. " "
		end 

	end 

	function o:Save()
		love.filesystem.write(o.filename, o.text)
	end

	-- reads the whole file into a single string
	function o:Read()
		self.text = love.filesystem.read(self.filename)
	end 
	
	-- reads each line into a seperate index of a table
	function o:ReadLines()
		for line in love.filesystem.lines(self.filename) do
			self.textTable[#self.textTable + 1] = line
		end 
	end 

	function o:Destroy()
		ObjectManager:Destroy()
	end 

	-----------
	-- End
	-----------

	return o

end 



return Textfile