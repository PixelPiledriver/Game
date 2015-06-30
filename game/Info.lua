-- Info.lua

-- Purpose
-----------------------------------------
-- holds basic information about objects
-- also tracks all types of objects possible to create
-- and how they interact with each other


------------------------------------------------------------------------------

-- global
Info = {}


------------
-- Vars
------------
Info.AllInfos = {}
Info.objectTypes = {}
Info.objectTypes.index = {}

Info.dataTypes = {}
Info.dataTypes.index = {}




-- data = {name, objectType, dataType, structureType}
function Info:New(data)

	local o = {}

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


function Info:PrintDebugText()

	local text = {}
	text[1] = {text = "Info.lua", obj = "Info"}
	text[2] = {text = "------------"}

	text[3] = {text = "DataTypes"}
	text[4] = {text = "======="}
	for i=1, #self.dataTypes.index do
		text[#text + 1] = {text = self.dataTypes.index[i]}
	end 

	DebugText:TextTable(text)

end

-----------------
-- On Require
-----------------
Info.Info = Info:New
{
	name = "Info",
	objectType = "Static",
	dataType = "Information",
	structureType = "Constructor"
}


-----------------
-- Static End
-----------------

ObjectUpdater:AddStatic(Info)















-- Notes
------------------------------------------
-- add as a component to objects
-- when creating new infos, Info stores information on them in static for later use

-- add structureType for Object/Component type labels
-- and change dataType to Graphics/Physics type labels