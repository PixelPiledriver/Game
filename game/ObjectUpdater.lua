-- ObjectUpdater.lua
-- holds all objects in a table and updates them


local ObjectUpdater = {}
ObjectUpdater.objects = {}
ObjectUpdater.cameras = {}

-------------
--Functions
-------------

-- add a new object to the list
-- {a,b,c,...} --> table of objects
function ObjectUpdater:Add(objects)
	for i=1, #objects do
		self.objects[#self.objects+1] = objects[i]
	end 
end 

function ObjectUpdater:AddCamera(cam)
	self.cameras[#self.cameras+1] = cam
end 

-- update all objects
function ObjectUpdater:Update()
	
	-- cameras
	for i=1, #self.cameras do
		self.cameras[i]:Update()
	end  
	

	-- objects
	for i=1, #self.objects do

		if(self.objects[i].Update) then
			self.objects[i]:Update()
		end 

	end 

end

function ObjectUpdater:RepeatedInput()

	-- cameras
	for i=1, #self.cameras do
		self.cameras[i]:RepeatedInput()
	end  

	-- objects
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
	
	-- cameras
	for i=1, #self.cameras do
		self.cameras[i]:Draw()
	end  

	-- objects
	for i=1, #self.objects do

		if(self.objects[i].Draw) then
			self.objects[i]:Draw()
		end 

	end 


end 




return ObjectUpdater