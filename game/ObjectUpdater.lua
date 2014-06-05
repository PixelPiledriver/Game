-- ObjectUpdater.lua
-- holds all objects in a table and updates them


local ObjectUpdater = {}
ObjectUpdater.objects = {}

-------------
--Functions
-------------

-- add a new object to the list
function ObjectUpdater:Add(object)
	self.objects[#self.objects+1] = object
end 

-- update all objects
function ObjectUpdater:Update()
	for i=1, #self.objects do

		if(self.objects[i].Update) then
			self.objects[i]:Update()
		end 

	end 
end

function ObjectUpdater:RepeatedInput()
	for i=1, #self.objects do

		if(self.objects[i].RepeatedInput) then
			self.objects[i]:RepeatedInput()
		end 

	end 
end 

function ObjectUpdater:Input(key)
	for i=1, #self.objects do

		if(self.objects[i].Input) then
			self.objects[i]:Input(key)
		end 

	end 
end 

function ObjectUpdater:Draw()
	for i=1, #self.objects do

		if(self.objects[i].Draw) then
			self.objects[i]:Draw()
		end 

	end 
end 




return ObjectUpdater