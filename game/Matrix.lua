-- Matrix.lua

-- Purpose
----------------------------------
-- do matrix math on objects and create matricies


--------------------------------------------------------
-- global
Matrix = {}


--------------
-- 2D - 3x3
--------------
Matrix.x3 = {}


Matrix.x3.identity = 
{
	{1,0,0},
	{0,1,0},
	{0,0,1}	
}

---------------
-- Create
---------------

-- create translation matrix
function Matrix.x3:Translation(x, y)

	local m = 
	{
		{1,0,x},
		{0,1,y},
		{0,0,1},
	}

	return m

end 

-- create scale matrix
function Matrix.x3:Scale(x, y)

	local m = 
	{
		{x,0,0},
		{0,y,0},
		{0,0,1},
	}

	return m

end 

-- create rotation matrix
function Matrix.x3:Rotation(angle)
	
	-- convert angle to radians
	local rad = math.rad(angle)

	-- creat matrix
	local m = 
	{
		{math.cos(rad), -math.sin(rad),0},
		{math.sin(rad), math.cos(rad),0},
		{0,0,1},
	}

	return m 

end 


------------------
-- Operations
------------------

-- multiply a matrix with a point
-- will also be included in matrix object as a personal
-- (m = matrix, p = point)
function Matrix.x3:MulPoint(m, p)
	local result = {}

	result[1] = (m[1][1] * p[1]) + (m[1][2] * p[2]) + (m[1][3] * p[3])
	result[2] = (m[2][1] * p[1]) + (m[2][2] * p[2]) + (m[2][3] * p[3])
	result[3] = (m[3][1] * p[1]) + (m[3][2] * p[2]) + (m[3][3] * p[3])

	return result

end 


-- rotate pos B around pos B
function Matrix.x3:RotateAround(a, b, angle)

	local toOrigin = Matrix.x3:Translation(-b.x, -b.y)
	local toPos = Matrix.x3:Translation(b.x, b.y)
	local rot = Matrix.x3:Rotation(angle)

	local A = Vertex:AsPoint(a)
	local B = Vertex:AsPoint(b)

	A = Matrix.x3:MulPoint(toOrigin, A)
	A = Matrix.x3:MulPoint(rot, A)
	A = Matrix.x3:MulPoint(toPos, A)

	a.x = A[1]
	a.y = A[2]

end 

-- multiply 2 matricies together
function Matrix:Multiply(a, b)
	
	-- fail
	if(#a[1] ~= #b) then
		printDebug{"Matrix: columns and rows not the same size", "Matrix"}
		return
	end 


end 



-- Notes
-----------------------------------

-- just realized that 4x4 matricies wont be needed
-- unless we add some 3D features
-- which probly wont happen for a long time
-- so I may removed the .x3 category and just have everything as
-- part or Matrix

-->NEED
-- rotate point A around point B function
-- so I dont have to code it into other objects
-- its just always usuabel here

-->NEED
-- function in point object that can return its values in a 1x3 or 1x4 format

-->NEED
-- Matrix static can create a Transform object
-- that contrain matricies, tranforms, and cool features

-- Matrix static supports 2d and 3d matricies



-- Junk
---------------------------------------
--[[

---------------
-- 3D - 4x4
---------------
Matrix.x4 = {}

Matrix.x4.indentity = 
{
	{1,0,0,0},
	{0,1,0,0},
	{0,0,1,0},
	{0,0,0,1}
}


-- multiply matrix with a line
-- this function is not needed
-- remove it
-- (m = matrix, l = line)
function Matrix.x3:MulLine(m, p)
	local result = {0,0,0}

	result[1] = (m[1][1] * point[1]) + (m[1][2] * point[2]) + (m[1][3] * point[3])
	result[2] = (m[2][1] * point[1]) + (m[2][2] * point[2]) + (m[2][3] * point[3])
	result[3] = (m[3][1] * point[1]) + (m[3][2] * point[2]) + (m[3][3] * point[3])

	return result

end



--]]