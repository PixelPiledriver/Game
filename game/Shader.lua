-- Shader.lua

-- Purpose
---------------------
-- no idea how to do shaders in love 2d
-- so lets figure this stuff out

-- play with canvases tomorrow too and get a basic full screen shader going
-- then work on an canvas swapping pipeline

-- stop shaders from working on machines that cant use them
local deactivateShaders = false

if(deactivateShaders) then
	return
end 

---------------------------------------------------------------------

local Shader = {}

----------------
-- Static Info
----------------
Shader.Info = Info:New
{
	objectType = "Shader",
	dataType = "Graphics",
	structureType = "Static"
}



-------------------
-- Static Vars
-------------------
Shader.brightness = 1


-----------------------
-- Static Functions
-----------------------
function Shader:Update()
	Shader.britShader:send("brightness", Shader.brightness)
end 


function Shader:PrintDebugText()
	DebugText:TextTable
	{
		{text = "", obj = "ShaderStatic"},
		{text = "Shader Static"},
		{text = "-------------------------"},
		{text = "Brit: " .. Shader.brightness}
	}
end 


--------------
-- Shaders
--------------

-- Vertex Shader
-- must have one function named "position"
local vertexShader = [[
extern number b;
varying vec4 vpos;


vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	return transform_projection * vertex_position;
}
]]

-- Pixel Shader
-- must have one function named "effect"
local pixelShader = [[
extern number brightness;
varying vec4 vpos;


vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	
  vec4 texColor = Texel(texture, texture_coords);
  number a = texColor.a;
  texColor = texColor * brightness;
  texColor.a = a;
  return texColor * color;
}
]]

-- create a shader object
-- (pixel shader filename or string, vertex shader filename or string)
Shader.britShader = love.graphics.newShader(pixelShader, vertexShader)


-- add to statics --> needs to update
ObjectManager:AddStatic(Shader)

return Shader






-- Notes
--------------------------------------------------------------

-- Vertex Shader
------------------------------
-- must have one function named "position"
--vec4 position(mat4 transform_projection, vec4 vertex_position)
--{
--	return transform_projection * vertex_position; --> transform vert to world position
--}

-- Pixel Shader
-------------------------
-- must have one function named "effect"
-- Basic Shader
--vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
--{
--	return color; --> returns vertex color
--}


-- Sending data to the shader
-----------------------------------
-- use the 'extern' keyword
-- extern number brightness;
-- remember the var MUST be used to affect the final color
-- otherwise it throws an error and says the variable does not exist


-- Passing data from Vertex to Pixel shader
-----------------------------------------------
-- use the 'varying' keyword
-- varying vec4 vpos;
-- just set the var you created in the function
-- no need to pass it inside a vertex struct like HLSL

-- this file is only an example and not organized well at all
-- need to create a static for shader creation and managing


-- use [[ ]] to make a string across multiple lines