-- ComponentManager.lua

-- add this object to an object that you want to use components
-- it contains and calls update on all components an object owns
-- this make it so parents run children and not the other way around
-- however even just adding components at this dev in the engine --> components will update themselves
-- because they are added to the object updater
-- it might be wise to seperate objects and components
-- a simpler version is to just have a table