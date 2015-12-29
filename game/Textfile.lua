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

	-- add a new line to the text table
	-- txt = string
	function o:AddLine(text)
		
		-- no first line?
		if(o.text == "") then
			o.text = o.text .. text 

		-- else add new line as normal
		else 
			o.text = o.text .. "\r\n" .. text 
		end 

	end

	function o:AddLineCode(text)
		o.text = o.text .. text
	end 

	--{text = {string, string, ...}}
	function o:AddLineFromTable(data)

		o.text = o.text .. "\r\n"

		for i=1, #data.text do
			o.text = o.text .. data.text[i] .. " "
		end 

	end

	-- adds the vars named in .index of given table to text in a line by line format
	-- file --
	--------------
	-- varName
	-- varValue
	-- varName
	-- ...
	--------------
	-- simple but might be slow, will need to be tested
	function o:AddAllTableVars(data)

		for i=1, #data.index do
			self:AddLine(data.index[i])
			self:AddLine(data[data.index[i]])
		end 

	end

	-- adds table as lua code to text
	-- (t = table) 
	function o:AddTable(t)

		-- must contain .index
		if(t.index == nil) then
			printDebug{"Table does not contain .index", "Textfile"}
			return
		end 

		self:AddLine("local " .. t.name .. " = {")

		local indexTable = "index = {"

		for i=1, #t.index do
			self:AddLine("  " .. t.index[i] .. " = " .. t[t.index[i]] .. ",")
			indexTable = indexTable .. t.index[i] .. ","
		end

		indexTable = indexTable .. "}"
		self:AddLine(indexTable)


		self:AddLine("}")
		self:AddLine("return " .. t.name)

	end 


	-- sets the directory to save in
	-- this will be moved to FileManager so that all file types may use it
	-- I dont mind files storing a var where they want to be saved tho
	function o:SetDirectory()

		-- directory defined for reading/writing?
		if(self.directory) then

			print(self.directory)
			-- last directory used is same as this object's?
			-- do nothing
			if(self.directory == Textfile.currentDirectory) then
				print("already at this directory")
				return
			end 

			-- set the directory
			Textfile.currentDirectory = self.directory
			love.filesystem.setIdentity(self.directory)
			print(love.filesystem.getIdentity())

		-- no directory defined?
		else
			-- set to default game directory -->turn into var
			love.filesystem.setIdentity("game")
		end
		
	end 

	-- (dir = string --> directory name)
	function o:Save(dir)

		--[[
		-- no directory given?
		if(dir == nil) then

			-- use self.directory
			self:SetDirectory()

		-- directory was given as argument
		else 
			love.filesystem.setIdentity(dir)
		end
		--]]

		-- write text to file
		love.filesystem.write(self.filename, self.text)
		EventLog:Add{"Save: " .. self.filename}

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
