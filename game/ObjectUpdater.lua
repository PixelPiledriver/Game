-- ObjectUpdater.lua
-- holds all objects in a table and updates them


local CollisionManager = require("CollisionManager")

local ObjectUpdater = {}
ObjectUpdater.objects = {}
ObjectUpdater.cameras = {}
ObjectUpdater.destroyObjects = false

-------------
--Functions
-------------

-- add a new object to the list
-- {a,b,c,...} --> table of objects
function ObjectUpdater:Add(objects)
	for i=1, #objects do
		self.objects[#self.objects+1] = objects[i]
	end 

	-- need to put in a real object counter
	-- use the fuckin in game print component
	print(#self.objects)
end 

-- destroy a single object
-- also adds collision of object to destroy list if it has one
function ObjectUpdater:Destroy(obj)
	
	if(obj.Destroy) then
		obj:Destroy()
	end 

	
	obj.destroy = true
	self.destroyObjects = true

	if(obj.collision) then
		obj.collision.destroy = true
		CollisionManager.destroyObjects = true
	end

	printDebug{obj.name or "Thing" .. " destroyed", "Collision"}
end 

function ObjectUpdater:ClearDestroyedObjects()

	if(self.destroyObjects == false) then
		return
	end 

	local temp = self.objects
	self.objects = nil
	self.objects = {}

	for i=1, #temp do

		if(temp[i].destroy == nil or temp[i].destroy == false) then
			self:Add{temp[i]}
		end 

	end

	CollisionManager:ClearDestroyedObjects()

	temp = nil

	self.destroyObjects = false

end 

function ObjectUpdater:AddCamera(cam)
	self.cameras[#self.cameras+1] = cam
end 

-- update all objects
function ObjectUpdater:Update()

	-- destroy
	self:ClearDestroyedObjects()

	
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

		-- keyboard input
		if(self.objects[i].RepeatedInput) then
			self.objects[i]:RepeatedInput()
		end 

		-- controller input
		if(self.objects[i].ControllerInput) then
			self.objects[i]:ControllerInput()
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