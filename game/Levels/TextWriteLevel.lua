-- TextWriteLevel.lua
-- testing grounds for TextfileWriter to make stuff

-- requirements
local Textfile = require("Textfile")


-- Table to hold Level objects
local TextWriteLevel = {}

-- On Level Start
function TextWriteLevel:Load()

	print("monkey")
	--local file = love.filesystem.newFile("monkey.txt")
	--file:open("w")

	--local f = love.filesystem.write("dildo.txt", "this is a file mother fucker 12345")

	local t = Textfile:New
	{
		filename = "PoopStuff.txt",
		text = "first line bitch"
	}

	t:AddLine("2nd line motherfucker")

	t:Save()

	local readF = Textfile:New
	{
		filename = "readthisfile.txt"
	}



	readF:Read()
	readF:ReadLines() 

	--print(readF.text)
	--print(readF.textTable[1])
	--print(readF.textTable[2])
	--print(readF.textTable[3])



	--ConvertColorTextToNewFormat()
	--StringPatternTest()
	--AddSpaceAfterAllColmas()
end


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

-- On Level Update
function TextWriteLevel:Update()

end

-- On Level End
function TextWriteLevel:Exit()
end

return TextWriteLevel
