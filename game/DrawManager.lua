-- DrawManager.lua


-- Purpose
----------------------------
-- handles drawing operations for the entire game
-- acts as the top layer for rendering
-- this includes calling DrawList and applying the current camera transform


------------------
-- Requires
------------------
local Camera = require("Camera")
local FrameCounter = require("FrameCounter")

------------------------------------------------------------------------

-- global
DrawManager = {}

------------------
-- Static Info
------------------
DrawManager.name = "DrawManager"
DrawManager.oType = "Static"
DrawManager.dataType = "Manager" -- the function of this static


---------------------
-- Static Vars
---------------------
DrawManager.currentCamera = nil


---------------------
-- Static Funcitons
---------------------

function DrawManager:Draw()
	
	FrameCounter:Draw()
	DebugText:Draw()
	Camera:Draw()
	DrawList:Draw()

end


-- anything that needs to happen after all rendering is done
-- but still within the draw callback
function DrawManager:PostDraw()
	Camera:PostDraw()
end


-- Notes
---------------------------------------
-- very light file for now
-- creates a place for tranforms to happen and in what order
-- instead of stuffing everything in main