-- Canvas.lua

-- Purpose
----------------------------
-- off screen render target


-------------------------------------------------------------------------

local Canvas = {}

------------------
-- Static Info
------------------
Canvas.name = "Canvas"
Canvas.oType = "Static"
Canvas.dataType = "Graphics Constructor"


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
	o.name = "..."
	o.oType = "Canvas"
	o.dataType = "Graphics"

	-- done

	ObjectUpdater:Add{o}

	return o
end 

ObjectUpdater:AddStatic(Canvas)



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