-- ObjectUpdater.lua
-- holds all objects in a table and updates them
-- objects, statics, special types

--------------
-- Requires
--------------
local CollisionManager = require("CollisionManager")


ObjectUpdater = {}

---------------
-- Create
---------------

-- object
ObjectUpdater.name = "ObjectUpdater"
ObjectUpdater.otype = "Static"
ObjectUpdater.dataType = "Manager"

-- tables
ObjectUpdater.statics = {}
ObjectUpdater.objects = {}
ObjectUpdater.cameras = {}

-- flags
ObjectUpdater.destroyObjects = false

-- debug text options
ObjectUpdater.printAllObjectsInDebugText = false
ObjectUpdater.printAllStaticsInDebugText = true
ObjectUpdater.printTotalObjectTypes = false

-------------
--Functions
-------------

function ObjectUpdater:AddStatic(staticObject)
	self.statics[#self.statics + 1] = staticObject

end 

-- add a new object to the list
-- {a,b,c,...} --> table of objects
function ObjectUpdater:Add(objects)

	for i=1, #objects do
		self.objects[#self.objects+1] = objects[i]
	end 

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
		else
			if(temp[i].collision) then
		
				CollisionManager:Destroy(temp[i].collision)
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

			local objectType = self.objects[i].oType or "unknown"
			
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
			local sOType = self.statics[i].oType or "___"
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
			local oType = self.objects[i].oType or "___"
			local oDataType = self.objects[i].dataType or "***"


			objectNames[#objectNames + 1] = {}
			objectNames[#objectNames].text = oName .. "| " .. oType .. " | " .. oDataType
			
		end 

		DebugText:TextTable(objectNames)
			
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

	end 

	-- print debug text for Object updater
	if(DebugText.active) then
		self:PrintDebugText()
	end

end

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

function ObjectUpdater:InputUpdate(key, inputType)

	-- statics
	for i=1 , #self.statics do

		-- update
		if(self.statics[i].Input) then
			self.statics[i].Input:InputUpdate(key, inputType)
		end

	end

	-- objects
	for i=1, #self.objects do

		if(self.objects[i].Input) then
			self.objects[i].Input:InputUpdate(key, inputType)
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

	for i=1, #self.cameras do
		self.cameras[i]:AfterDraw()
	end  


end 




--	Notes
----------------------
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


-- Junk code
-----------------
--DebugText:Text((self.objects[i].name or "*no .name*") .. " -- " .. (self.objects[i].otype or "*no .otype*"))	
