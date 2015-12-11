-- Vertex.lua

-- Purpose
-------------------------
-- object that defines a pos
-- graphics objects such as line, polygon, etc can use them to describe their shape
-- object has features to make them easy to work with
-- as well as static funcitions

------------------------------------------------------------

Vertex = {}


----------------
-- Functions
----------------


-- return given table as point to be used with matricies
-- (t = table with .x and .y vars)
function Vertex:AsPoint(t)
	local point = {t.x, t.y, 1}

	return point
end 




ObjectUpdater:AddStatic(Vertex)

return Vertex
