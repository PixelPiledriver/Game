-- TestShit.lua
-- scratch file for testing simple code stuff
-- is only run once upon require
-- this is not meant to be a complex place for testing objects
-- just for raw lua code dealing with tables and shit


local thing = {}
thing.a = 10
thing.name = "thing"
function thing:Get()
	return self.a
end
function thing:Add()
	self.a = self.a + 5
end 
function thing:PrintSelf()
	print(self.a)
end 


local monkey = {}
monkey.a = 1
monkey.name = "monkey"
function monkey:Get()
	return self.a
end 
function monkey:Add()
	self.a = self.a + 5
end 
function monkey:PrintSelf()
	print(self.a)
end 

local contain =
{
	thing,
	monkey
}

function contain:PrintSelf()
	for i=1, #self do
		print(self[i].name)
	end
end 

--[[

TableSort:SortByFunc
{
	t = contain,
	func = "Get"
}

contain:PrintSelf() 


thing:PrintSelf()
thing["Add"](thing)
thing["PrintSelf"](thing)
--]]


