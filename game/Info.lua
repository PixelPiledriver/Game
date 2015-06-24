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

	o.name = data.name
	o.objectType = data.objectType
	o.dataType = data.dataType
	o.structureType = data.structureType

	self:AddDataType(data)


	----------
	-- End
	----------
	return o

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
	text[1] = {text = "Info:", obj = "Info"}

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