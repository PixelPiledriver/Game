-- ObjectUpdater.lua
-->CLEAN

-- Purpose
----------------------------
-- holds all objects in a table and updates them
-- objects, statics, special types


------------------------------------------------------------------------------

-- global
ObjectUpdater = {}

-----------------
-- Static Info
-----------------
ObjectUpdater.Info =
{
	objectType = "ObjectUpdater",
	dataType = "Manager",
	structureType = "Static"
}


-----------------
-- Static Vars
-----------------

-- tables
ObjectUpdater.statics = {}
ObjectUpdater.objects = {}
ObjectUpdater.cameras = {}
ObjectUpdater.postUpdateObjects = {} -- temporary
ObjectUpdater.dataTypes = {}

ObjectUpdater.componentTypes = {}
ObjectUpdater.componentTypes.index = {}

-- flags
ObjectUpdater.destroyObjects = false

-- debug text options
ObjectUpdater.printAllObjectsInDebugText = false
ObjectUpdater.printAllStaticsInDebugText = false
ObjectUpdater.printTotalObjectTypes = false
ObjectUpdater.printComponents = true

----------------------
-- Static Functions
----------------------

-- add a new static to the static list
function ObjectUpdater:AddStatic(staticObject)
	self.statics[#self.statics + 1] = staticObject

end 

-- add a new object to the object list
-- use table even if theres only 1 object
-- data = {objectA, objectB, objectC, ...}
function ObjectUpdater:Add(objects)

	for i=1, #objects do
		self.objects[#self.objects+1] = objects[i]

		if(objects[i].dataType == "Component") then
			self:AddComponentType(objects[i])
		end
	end 

end 

function ObjectUpdater:AddComponentType(object)
	if(self.componentTypes[object.objectType] == nil) then
		self.componentTypes[object.objectType] = true
		self.componentTypes.index[#self.componentTypes.index + 1] = object.objectType
	end 
end 



-- flag an object to be destroyed on the next ClearDestroyedObjects call
function ObjectUpdater:Destroy(obj)
	
	if(obj.Destroy) then
		obj:Destroy()
	end 

	obj.destroy = true
	self.destroyObjects = true

	-- flag the collision of this object
	-- this needs to be done for other components as well -->FIX
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
		else
			
			if(temp[i].collision) then
				CollisionManager:Destroy(temp[i].collision)
			end 

			-- need to clear all components -->FIX
			-- this code didnt work
			-- figure out why
			
			if(temp[i].Draw) then
				temp[i].Draw = nil
			end 



		end 


	end

	CollisionManager:ClearDestroyedObjects()

	temp = nil

	self.destroyObjects = false

end 

function ObjectUpdater:AddCamera(cam)
	self.cameras[#self.cameras+1] = cam
end 



function ObjectUpdater:PrintDebugText()
	if(DebugText.messageType["ObjectUpdater"] == false) then
		return
	end 

	-- print basic information
	DebugText:TextTable
	{
		{text = "", obj = "ObjectUpdater"},
		{text = "ObjectUpdater"},
		{text = "------------------"},
		{text = "Total Statics: " .. #self.statics},
		{text = "Total Objs: " .. #self.objects},
		{text = "------------------"},
	}

	-- print all Object totals by type
	if(ObjectUpdater.printTotalObjectTypes) then
		local objectTypesTemp = {}
		objectTypesTemp.index = {}

		for i=1, #self.objects do

			local objectType = self.objects[i].objectType or "unknown"
			
			if(objectTypesTemp[objectType] == nil) then
				objectTypesTemp[objectType] =
				{
					name = objectType,
					total = 1
				}

				local nameFound = false

				for j=1, #objectTypesTemp.index do
					if(objectType == objectTypesTemp.index[j]) then
						nameFound = true 
					end 
				end
	
				if(nameFound == false) then
					objectTypesTemp.index[#objectTypesTemp.index + 1] = objectType
				end 

			else
				objectTypesTemp[objectType].total = objectTypesTemp[objectType].total + 1
			end 

		end 


		local totalsTextTable = {}
		totalsTextTable[1] = {text = "", obj = "ObjectUpdater"}
		totalsTextTable[2] = {text = "Object Totals"}
		totalsTextTable[3] = {text = "----------------------"}

		for i=1, #objectTypesTemp.index do
			totalsTextTable[#totalsTextTable+1] = {text = objectTypesTemp[objectTypesTemp.index[i]].name .. ": " .. objectTypesTemp[objectTypesTemp.index[i]].total }
		end

		DebugText:TextTable(totalsTextTable)

	end 



	-- print all Statics as list
	if(ObjectUpdater.printAllStaticsInDebugText) then
		local staticNames = {}
		staticNames[1] = {text = "", obj = "ObjectUpdater"}
		staticNames[2] = {text = "Statics"}
		staticNames[3] = {text = "------------"}

		for i=1, #self.statics do
			local sName = self.statics[i].name or "..."
			local sOType = self.statics[i].objectType or "___"
			local sDataType = self.statics[i].dataType or "***" 

			staticNames[#staticNames+1] = {}
			staticNames[#staticNames].text = sName .. " | " .. sOType .. " | " .. sDataType

		end 

		DebugText:TextTable(staticNames)

	end 

	-- print all Objects as list
	if(ObjectUpdater.printAllObjectsInDebugText) then
		local objectNames = {}
		objectNames[1] = {text = "", obj = "ObjectUpdater"}

		for i=1, #self.objects do

			local oName = self.objects[i].name or "..."
			local objectType = self.objects[i].objectType or "___"
			local oDataType = self.objects[i].dataType or "***"


			objectNames[#objectNames + 1] = {}
			objectNames[#objectNames].text = oName .. "| " .. objectType .. " | " .. oDataType
			
		end 

		DebugText:TextTable(objectNames)
			
	end 

	-- print 
	if(ObjectUpdater.printComponents) then 
		local componentNames = {}
		componentNames[1] = {text = "Component Types", obj = "ObjectUpdater"}
		componentNames[2] = {text = "-----------------"}
		
		for i=1, #self.componentTypes.index do

			componentNames[#componentNames + 1] = {}
			componentNames[#componentNames].text =  self.componentTypes.index[i]

		end 

		DebugText:TextTable(componentNames)

	end 


end 

-- update all objects
function ObjectUpdater:Update()

	-- destroy
	self:ClearDestroyedObjects()

	-- cameras
	for i=1, #self.cameras do
		self.cameras[i]:Update()

		if(self.cameras[i].PrintDebugText) then
			self.cameras[i]:PrintDebugText()
		end
	end  

	-- statics
	for i=1 , #self.statics do

		-- update
		if(self.statics[i].Update) then
			self.statics[i]:Update()
		end 

		-- debug text
		if(self.statics[i].PrintDebugText) then
			self.statics[i]:PrintDebugText()
		end

	end
	
	-- objects
	for i=1, #self.objects do

		-- update
		if(self.objects[i].Update) then
			self.objects[i]:Update()
		end 

		-- debug text per object
		if(DebugText.active) then

			if(self.objects[i].PrintDebugText) then
					self.objects[i]:PrintDebugText()
			end 

		end 

		if(self.objects[i].PostUpdate) then
			self:AddToPostUpdate(self.objects[i])
		end 

	end 

	-- print debug text for Object updater
	if(DebugText.active) then
		self:PrintDebugText()
	end

end

function ObjectUpdater:AddToPostUpdate(postObject)
	self.postUpdateObjects[#self.postUpdateObjects + 1] = postObject
end 

function ObjectUpdater:ClearPostUpdate()
	for i=1, #self.postUpdateObjects do
		self.postUpdateObjects[i] = nil
	end 

	self.postUpdateObjects = nil
	self.postUpdateObjects = {}
end 

function ObjectUpdater:PostUpdate()

	for i=1, #self.postUpdateObjects do

		if(self.postUpdateObjects[i].PostUpdate) then 
			self.postUpdateObjects[i]:PostUpdate()
		end 

	end

	self:ClearPostUpdate()

end 

-- is this function even needed anymore?
function ObjectUpdater:RepeatedInput()

	-- cameras
	for i=1, #self.cameras do
		self.cameras[i].Input:RepeatedInputUpdate()
	end

	-- statics
	for i=1 , #self.statics do

		-- update
		if(self.statics[i].RepeatedInput) then
			self.statics[i]:RepeatedInput()
		end 

		-- debug text
		if(self.statics[i].ControllerInput) then
			self.statics[i]:ControllerInput()
		end

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

-- this is all good and fine
-- but after the update loop objects with input components should be added
-- to an input list, and then only those objects are part of this input update
-- much like draw list -->FIX
function ObjectUpdater:InputUpdate(key, inputType)

	for i=1, #self.cameras do

		if(self.cameras[i].Input) then
			self.cameras[i].Input:InputUpdate(key, inputType)
		end 

	end 

	-- Statics
	for i=1 , #self.statics do

		if(self.statics[i].Input) then
			self.statics[i].Input:InputUpdate(key, inputType)
		end

	end

	-- Objects
	for i=1, #self.objects do

		if(self.objects[i].Input) then
			self.objects[i].Input:InputUpdate(key, inputType)
		end 

	end 

end 






--	Notes
----------------------
-- destroy needs to check objects for components and run destroy on them properly

-- operations on lists of objects needs to be generic
-- so that if a new list of objects is added ObjectUpdater can
-- perform all tasks on it just like any other list
-- such as updating and clearing dead objects
-- this comes up because I need to add a postObjects list
-- but would need to add exact duplcates of existing functions
-- that call on the new lists -->REDUNDANT


-- Global
-- changed ObjectUpdater to a global
-- since so many files use it
-- need to remove all require calls to it

-- Working --> Draw List
-- Need to have priority lists that update in order
-- also need to have something that controls draw order
-- a seperate list that pulls from object updater but in a different order
-- maybe when objects update they should submit their draw order

-- Working
-- should probly update this to create
-- updater objects that you can add objects to
-- that way they all run the same and just have different lists
--> :D






-- Old Code
-----------------

--DebugText:Text((self.objects[i].name or "*no .name*") .. " -- " .. (self.objects[i].otype or "*no .otype*"))	


--[[


-- replaced by Draw component
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

	for i=1, #self.cameras do
		self.cameras[i]:AfterDraw()
	end  


end 










--]]