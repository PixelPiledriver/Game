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

Textfile.currentDirectory = "game"

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
	o.directory = data.directory or nil

	-------------------------------
	-- Functions
	-------------------------------

	function o:AddLine(txt)
		
		-- no first line?
		if(o.text == "") then
			o.text = o.text .. txt 

		-- else add new line as normal
		else 
			o.text = o.text .. "\r\n" .. txt 
		end 

	end 

	--{text = {...}, spaceBetweenEach = bool}
	function o:AddLineFromTable(data)

		o.text = o.text .. "\r\n"

		for i=1, #data.text do
			o.text = o.text .. data.text[i] .. " "
		end 

	end 

	function o:SetDirectory()

		-- directory defined for reading/writing?
		if(self.directory) then

			-- last directory used is same as this object's?
			-- do nothing
			if(self.directory == Textfile.currentDirectory) then
				return
			end 

			-- set the directory
			Textfile.currentDirectory = self.directory
			love.filesystem.setIdentity(self.directory)

		-- no directory defined?
		else
			-- set to default game directory -->turn into var
			love.filesystem.setIdentity("game")
		end
		
	end 

	function o:Save()
		self:SetDirectory()
		love.filesystem.write(self.filename, self.text)
	end

	-- reads the whole file as a single string
	function o:Read()
		self:SetDirectory()
		self.text = love.filesystem.read(self.filename)
	end

	function o:GetRead()
		return love.filesystem.read(self.filename)
	end 
	
	-- reads file into indexed table
	function o:ReadLines()
		for line in love.filesystem.lines(self.filename) do
			self.textTable[#self.textTable + 1] = line
		end
	end

	-- return file as indexed table
	function o:ReadLinesToTable()
		local tempTable = {}

		for line in love.filesystem.lines(self.filename) do
			tempTable[#tempTable+1] = line
		end 

		return tempTable
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


-- Notes
--------------------------------------
-->NEED
-- lua file writing/reading features 
-- such as tables, functions, vars etc


-- Text Commands
--[[

\a	bell
\b	back space
\f	form feed
\n	newline
\r	carriage return
\t	horizontal tab
\v	vertical tab
\\	backslash
\"	double quote
\'	single quote
\[	left square bracket
\]	right square bracket

--]]
