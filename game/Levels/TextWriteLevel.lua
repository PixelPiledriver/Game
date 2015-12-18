-- TextWriteLevel.lua

-- Description
-------------------------
-- testing grounds for TextfileWriter to make stuff

--------------
-- Requires
--------------
local Textfile = require("Textfile")

-----------------------------------------------

--------------------
-- Level Functions
--------------------


local Start = function()

	local saveTest = Textfile:New
	{
		filename = "cookies.txt",
		directory = "Mega Cookie",
		text = "omg I love cookies"
	}

	saveTest:Save()


	local writeStuff = Textfile:New
	{
		filename = "Apples.txt",
		text = "Make apple pie"
	}

	writeStuff:Save()

		
	local readTest = Textfile:New
	{
		filename = "readthisfile.txt",
		directory = "game"
	}

	readTest:Read()

	print(readTest.text)

	local text = readTest:ReadLinesToTable()

	for i=1, #text do
		print(text[i])
	end

	print("poop")



	


end


local Update = function()

end


local Exit = function()

end


local Restart = function()

end 


--------------
-- Object
--------------

local level = Level:New
{
	Start = Start,
	Update = Update,
	Exit = Exit,
	Restart = Restart,

	filename = "TextWriteLevel"
}

-----------
-- End 
-----------

return level



-- Test Code
-------------------
--[[

	--local file = love.filesystem.newFile("monkey.txt")
	--file:open("w")

	--local f = love.filesystem.write("dildo.txt", "this is a file bro 12345")

	local t = Textfile:New
	{
		filename = "PoopStuff.txt",
		text = "first line dawg"
	}

	t:AddLine("2nd line yo")

	t:Save()

	local readF = Textfile:New
	{
		filename = "readthisfile.txt"
	}

	readF:Read()
	readF:ReadLines()

--]]


-----------------------
-- Other Functions
-----------------------


--[==[
-- using lua string patterns to find 
-- the name and each value channel of a color
-- represented as a string
function StringPatternTest()
	
	local words = "Color.orange	=	{255, 165, 0, 255}"
	local name, r, g, b, a = words:match("(.+%s).(%d+%p).(%d+%p).(%d+%p).(%d+)")

	print(name)
	print(r)
	print(g)
	print(b)
	print(a)

end 

function AddSpaceAfterAllColmas()

	local colorFileOld = Textfile:New
	{
		filename = "Color_old.txt"
	}	
	colorFileOld:ReadLines()

	local colorFileNew = Textfile:New
	{
		filename = "Color_new.txt"
	}

	for i=1, #colorFileOld.textTable do
		local a, b, c, d = colorFileOld.textTable[i]:match("(.-%,)(.-%,)(.-%,).(.-%})")

		colorFileNew:AddLineFromTable
		{
			text = {a,b,c,d}
		}

		--print(colorFileNew.text)
	end 

	colorFileNew:Save()

end 

-- rewrites all the colors in Color.lua
-- to a new and better format
function ConvertColorTextToNewFormat()

	local colorFileOld = Textfile:New
	{
		filename = "Color_old.txt"
	}

	-- get all the colors from the file
	-- into a table <-- each line
	colorFileOld:ReadLines()

	-- the file that we will save the new format in
	local colorFileNew = Textfile:New
	{
		filename = "Color_new.txt"
	}

	
	for i=1, #colorFileOld.textTable do

		local name, r, g, b, a = colorFileOld.textTable[i]:match("(.+%s).(%d+%p).(%d+%p).(%d+%p).(%d+)")

		print(name)
		
		colorFileNew:AddLine(name)
		colorFileNew:AddLine("{")
		colorFileNew:AddLine("	r = " .. r)
		colorFileNew:AddLine("	g = " .. g)
		colorFileNew:AddLine("	b = " .. b)
		colorFileNew:AddLine("	a = " .. a .. ",")
		local nameStart, nameEnd = name:find("%p.-%s")
		colorFileNew:AddLine('	name = "' .. name:sub(nameStart + 1, nameEnd - 1) .. '"')
		colorFileNew:AddLine("}")
		colorFileNew:AddLine("")

	end 

	colorFileNew:Save()

end

--]==]

-- Junk
------------------------------------------
--[=[ 

	--print(readF.text)
	--print(readF.textTable[1])
	--print(readF.textTable[2])
	--print(readF.textTable[3])



	--ConvertColorTextToNewFormat()
	--StringPatternTest()
	--AddSpaceAfterAllColmas()

==]=]
