-- Action.lua

-- an Action is an effect that one object tries to apply to another
-- that object can revceive or ignore the action
-- and then use its own action in response --> a reaction

---------------------------------------------
local Action = {}


------------------
-- Static Info
------------------
Action.Info = Info:New
{
	objectType = "Action",
	dataType = "Interaction",
	structureType = "Static"
}
-------------
-- Object
-------------

function o:New(data)
	local o = {}

	------------
	-- Info
	------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Action",
		dataType = "Interaction",
		structureType = "Object"
	}


	-----------
	-- Vars
	-----------
	o.name = data.name or "unNamed"
	o.func = data.func or nil
	o.arguments = data.argument or nil
	o.argumentIndex = data.argumentIndex or nil --> might not need this

	----------------
	-- Functions
	----------------

	function o:Use()
		o.func(o.arguments)
	end

	function o:Destroy()
		o.name = nil
		o.func = nil
		o.arguments = nil
		o.argumentIndex = nil
	end 

	return o
end 

ObjectUpdater:AddStatic{Action}

return Action

-- Notes
---------------------------
-- very primitive at the moment

-- there should be an ActionManager component to go with this
-- this should be just an action object
-- Action manager should handle 
-- sending and running actions between objects
-- maybe it could be a static and handle submssions much like
-- the graphics or collision managers
-- each object doesn't really need to carry around code that
-- lets it send and run actions

-- Object version of MapObject action code
-- not sure if this is a good idea or not
-- but I want to try and break it down
-- so that any object can use an action