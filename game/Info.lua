-- Info.lua

-- Purpose
-----------------------------------------
-- holds basic information about objects
-- also tracks all types of objects possible to create
-- their funciton, type, etc


------------------------------------------------------------------------------

-- global
Info = {}


----------------
-- Static Vars
----------------
Info.AllInfos = {}
Info.AllInfos.index = {}

Info.objectTypes = {}
Info.objectTypes.index = {}

Info.dataTypes = {}
Info.dataTypes.index = {}

Info.structureTypes = {}
Info.structureTypes.index = {}

-----------
-- Object
-----------

-- data = {name, objectType, dataType, structureType}
function Info:New(data)

	local o = {}

	-----------
	-- Info
	-----------
	-- defined as just a table for this object type
	-- to avoid recurring calls to Info
	o.Info = 
	{
		name = "...",
		objectType = "Info",
		dataType = "Information",
		structureType = "Object"
	}

	--------------
	-- Vars
	--------------

	-- name of object 
	-- personal string to call an individual object by
	-- most objects will not have a name
	-- for statics this is the same as their objectType
	o.name = data.name or "..."

	-- the name of the static that created this object or the static itself
	o.objectType = data.objectType or "___"

	-- the kind of stuff this object provides, Graphics, Collision, Constructor, Game, etc
	o.dataType = data.dataType or "???"

	-- the build of the object, Static, Object or Table
	o.structureType = data.structureType or "***"

	self:AddInfo(data)

	self:AddDataType(data)
	self:AddObjectType(data)
	self:AddStructureType(data)

	function o:Destroy()
		self.Info = nil
	end 

	----------
	-- End
	----------
	return o

end 

-- data = data from New
function Info:AddInfo(data)
	self.AllInfos[#self.AllInfos + 1] = data
end 

-- data = data from New
function Info:AddDataType(data)

	if(self.dataTypes[data.dataType] == nil) then
		self.dataTypes[data.dataType] = true
		self.dataTypes.index[#self.dataTypes.index + 1] = data.dataType
	end 

end

function Info:AddObjectType(data)

	if(self.objectTypes[data.objectType] == nil) then
		self.objectTypes[data.objectType] = true
		self.objectTypes.index[#self.objectTypes.index + 1] = data.objectType
	end 

end 

function Info:AddStructureType(data)
	if(self.structureTypes[data.structureType] == nil) then
		self.structureTypes[data.structureType] = true
		self.structureTypes.index[#self.structureTypes.index + 1] = data.structureType
	end 
end 


-- this needs some work
-- only 1 list is printed
-->FIX
function Info:PrintDebugText()

	local text = {}
	text[1] = {text = "Info.lua", obj = "Info"}
	text[2] = {text = "------------"}

	text[3] = {text = "ObjectTypes"}
	text[4] = {text = "-------------"}

	--[[
	for i=1, #self.objectTypes.index do
		text[#text + 1] = {text = self.objectTypes.index[i]}
	end 
	--]]

	DebugText:AppendTableToText
	{
		t = self.objectTypes.index,
		text = text
	}

	text[#text + 1] = {text = ""}
	text[#text + 1] = {text = "DataTypes"}
	text[#text + 1] = {text = "------------"}

	DebugText:AppendTableToText
	{
		t = self.dataTypes.index,
		text = text
	}

	text[#text + 1] = {text = ""}
	text[#text + 1] = {text = "StructureTypes"}
	text[#text + 1] = {text = "-----------------------"}

	DebugText:AppendTableToText
	{
		t = self.structureTypes.index,
		text = text
	}

	DebugText:TextTable(text)
	

end

-- adds an Info to the Object of given Static
-- saves time typing since only structure type is different
-- may not need this anymore
-- {static, o, data, structureType = "Object"}
function Info:ObjectOf(data)
	data.o.Info = Info:New
	{
		name = data.data.name or "...",
		objectType = data.static.Info.objectType,
		dataType = data.static.Info.dataType,
		structureType = data.structureType or data.static.Info.structureTypes
	}
end 

-----------------
-- On Require
-----------------
Info.Info = Info:New
{
	name = "Info",
	objectType = "Info",
	dataType = "Information",
	structureType = "Static"
}


-----------------
-- Static End
-----------------

ObjectUpdater:AddStatic(Info)









-- Notes
------------------------------------------
-- add as a component to objects
-- when creating new infos, Info stores information on them in static for later use

-->DONE
-- add structureType for Object/Component type labels
-- and change dataType to Graphics/Physics type labels