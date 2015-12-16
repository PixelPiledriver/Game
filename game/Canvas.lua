-- Canvas.lua
-->EMPTY

-- Purpose
----------------------------
-- off screen render target


-------------------------------------------------------------------------

local Canvas = {}

------------------
-- Static Info
------------------
Canvas.Info = Info:New
{
	objectType = "Canvas",
	dataType = "Graphics",
	structureType = "Static"	
}

----------------
-- Static Vars
----------------

-- check for Canvas support of graphics card
Canvas.supported = love.graphics.isSupported("canvas")

-- not supported?
-- then no need to build the rest of this static
if(Canvas.supported == false) then
	return Canvas
end 


---------------------
-- Static Functions
---------------------
function Canvas:New(data)

	local o = {}

	------------------
	-- Create
	-------------------
	-- object
	o.Info = Info:New
	{
		name = "...",
		objectType = "Canvas",
		dataType = "Graphics",
		structureType = "Object"
	}


	---------------
	-- Functions
	---------------
	function o:Destroy()
		ObjectManager:Destroy(self.Info)
	end 

	----------
	-- End
	----------

	ObjectManager:Add{o}

	return o
end 


---------------
-- Static End
---------------

ObjectManager:AddStatic(Canvas)

return Canvas






-- Notes
-----------------------------------------------
-- currently unused
-- but will be good to implement



-- Usage
-----------------------------
--	Create a canvas with:
--	love.graphics.newCanvas()
-- 	by default creates a canvas of the window size

--	Draw the canvas with:
-- 	love.graphics.draw(canvas) or (canvas, x, y)