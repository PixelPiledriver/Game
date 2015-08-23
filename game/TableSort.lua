-- TableSort.lua


-- Purpose
----------------------------
-- Functions for sorting tables


----------------------------------------------------------------------------

-- global
TableSort = {}

------------------
-- Static Info
------------------
TableSort.Info = Info:New
{
	objectType = "TableSort",
	dataType = "Utility",
	structureType = "Static"
}

---------------------
-- Static Functions
---------------------

-- sort a table of objects by a variable name they all have in common
-- data = {t, var}
function TableSort:SortByVar(data)

	local function tempCompare(a,b)
		return a[data.var] < b[data.var]
	end 

	table.sort(data.t, tempCompare)

end

-- sorts the given table using afunction name they all have in common
-- data = {t, func}
function TableSort:SortByFunc(data)

	local function tempCompare(a,b)
		return a[data.func](a) < b[data.func](b)
	end 

	table.sort(data.t, tempCompare)

end

-- sorts a table of strings
-- honestly this is a pointlessly named function
-- it should just be sort a table of values
-- and should work for any hard values, not just strings -->CHANGE
-- {index table of strings}
function TableSort:SortByString(t)

	local function tempCompare(a,b)
		return a < b
	end

	table.sort(t, tempCompare)

end 


-- returns a new indexed table that consists only of the unique values
-- contained in the given index table
function TableSort:UniqueVars(t)
	
	local tempTable = {}

	for i=1, #t do

		local unique = true

		for j=1, #tempTable do
			if(t[i] == tempTable[j]) then
				unique = false
			end 
		end

		if(unique) then
			tempTable[#tempTable + 1] = t[i]
		end

	end 

	return tempTable

end

function TableSort:AddIndexIfUnique(data)

	if(data.t[data.add] == nil) then
		data.t[data.add] = true
		data.t.index[#data.t.index + 1] = data.add
	end 

end 



-- Notes
-----------------------------------------------------------------
-- I want to be able to sort a table by any of its variables
-- so here we go
--- yep just need to write a compare function
-- woot


-- BUT
-- it would be cool to be able to pass in a name and sort a table
-- by inner table names



-- Test Sort by Function
-------------------------------------
--[[
local cow = {name = "cow"}
local chicken = {name = "chicken"}
local dog = {name = "dog"}
local cat = {name = "cat"}

function cow:Monkey()
	return 1
end 

function chicken:Monkey()
	return 2
end 

function dog:Monkey()
	return 3
end 

function cat:Monkey()
	return 4
end 


local contain = 
{
	cat,
	dog,
	chicken, 
	cow
}

TableSort:SortByFunc
{
	t = contain,
	func = "Monkey"
}

for i=1, #contain do
	print(contain[i].name)
end 
--]]




-- notes

-- test compare function stuff :D

--[[ 

-- Test Sort by Var
----------------------------------------
local stuff = 
{
	{
		r = 2,
		g = 12
	},

	{
		r = 6,
		g = 3,
	},

	{
		r = 3,
		g = 9,

	},

	{
		r = 1,
		g = 6
	}
}


TableSort:Sort
{
	t = stuff,
	var = "r"
}
for i=1, #stuff do 
	print(stuff[i].r)
end 






local function CompareStuff1(a,b)
	return a["g"] < b["g"]
end


table.sort( stuff, CompareStuff1)

for i=1, #stuff do 
	print(stuff[i].g)
end 




local stringSort = 
{
	11, 123, 4, 6, 9, 1, 20, 50, 55 ,2020, 0, 292, 3, 8, 6, 6, 7
}

TableSort:SortByString(stringSort)

for i=1, #stringSort do
	print(stringSort[i])
end 



--]]