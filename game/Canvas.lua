-- Canvas.lua
-- off screen render target

local ObjectUpdater = require("ObjectUpdater")


local Canvas = {}


Canvas.name = "Canvas"
Canvas.oType = "Static"
Canvas.dataType = "Graphics Constructor"




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
-------------------
--	Create a canvas with:
--	love.graphics.newCanvas()
-- 	by default creates a canvas of the window size

--	Draw the canvas with:
-- 	love.graphics.draw(canvas)(canvas, x, y)