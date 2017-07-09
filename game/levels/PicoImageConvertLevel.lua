-- PicoImageConvertLevel.lua

-- Description
-------------------------
-- convert png images into tokens for use with PICO-8: PixelCompress.p8
-- this file and the token format is changing to be better and smaller
-- so try to keep it clean

--------------
-- Requires
--------------
local Color = require("Color")
local Textfile = require("Textfile")

-----------------------------------------------

--------------------
-- Level Functions
--------------------

local Start = function()

	
	-- pixels in pairs for pico8 PXDRAW
	local hatGuy = love.graphics.newImage("graphics/hatGuy.png")
	print(hatGuy)
	local hatGuyData = hatGuy:getData()

	local hatGuyFile = Textfile:New
	{
		filename = "hatGuyPixels.txt"
	}

	local picoPalette =
	{
		{0,0,0}, -- 1
		{29,43,83}, -- 2
		{126,37,83}, -- 3
		{0,135,81}, -- 4
		{171,82,54}, -- 5
		{95,87,79}, -- 6
		{194,195,199}, -- 7
		{255,241,232}, -- 8

		{255,0,77}, -- 9
		{255,163,0}, -- 10
		{255,236,39}, -- 11
		{0,228,54}, -- 12
		{41,173,255}, -- 13
		{131,118,156}, -- 14
		{255,119,168}, -- 15
		{255,204,170}, -- 16
	}

	local lastColor = {0,0,0,0}
	local colorLength = 0
	for y=1, hatGuyData:getHeight() do
		for x=1, hatGuyData:getWidth() do
			-- get color of this pixel
			local thisColor = {hatGuyData:getPixel(x-1,y-1)}

			-- has color changed?
			if(Color:Equal(thisColor, lastColor)) then
				colorLength = colorLength + 1
			else
				local colorIndex = 0

				for i=1, #picoPalette do
					if(Color:Equal(lastColor, picoPalette[i])) then
						colorIndex = i-1
					end 
				end 

				hatGuyFile:AddLine(colorIndex .. "," .. colorLength .. ",")
				colorLength = 1
			end 

			print(Color:Equal(thisColor, lastColor))
			print(hatGuyData:getPixel(x-1,y-1))

			-- save this color for next loop
			lastColor[1], lastColor[2], lastColor[3] = hatGuyData:getPixel(x-1,y-1)
		end 
	end 

	hatGuyFile:Save()



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


	local saveTest = Textfile:New
	{
		filename = "cookies.txt",
		--directory = "Mega Cookie",
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
	}

	readTest:Read()

	--print(readTest.text)

	local text = readTest:ReadLinesToTable()

	--[[
	for i=1, #text do
		print(text[i])
	end
	--]]



--]=]
