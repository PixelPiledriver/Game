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
Shader.scroll = 0


-----------------------
-- Static Functions
-----------------------
function Shader:Get(shaderName)

	local shaderClone = Shader:New(Shader[shaderName])

	return  shaderClone
end


function Shader:Update()
	-- remove this
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

-------------
-- Object
-------------

function Shader:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Shader",
		dataType = "Graphics",
		structureType = "Object"
	}


	o.vertexShader = data.vertexShader
	o.pixelShader = data.pixelShader
	o.shader = love.graphics.newShader(o.pixelShader, o.vertexShader)
	
	-- create independant variables for new object
	o.vars = {}
	--o.vars = data.vars or nil

	-- copy variables from shader to new table for individual use
	if(data.vars) then
		for i=1, #data.vars.index do
			o.vars[data.vars.index[i]] = data.vars[data.vars.index[i]]
		end 

		-- initialize all vars for shader
		for i=1, #data.vars.sendIndex do
			o.shader:send(data.vars.sendIndex[i], o.vars[data.vars.sendIndex[i]])
		end 

	end 

	

	---------------
	-- Functions
	---------------
	o.Update = data.Update

	--function o:Update()
	--	-- this function is redefined by the shader table
	--end 
	

	-----------
	-- End
	-----------
	ObjectManager:Add{o}

	return o


end 


--------------
-- Shaders
--------------


-- Brightness
----------------------------------------------
-- Vertex Shader
-- must have one function named "position"
local vertexShader = 
[[
varying vec4 vpos;


vec4 position(mat4 transform_projection, vec4 vertex_position)
{
	return transform_projection * vertex_position;
}
]]

-- Pixel Shader
-- must have one function named "effect"
local pixelShader = 
[[
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


-- X Scroll
----------------------------------------------
Shader.xScroll = 
{
	vertexShader = 
	[[
	varying vec4 vpos;

	vec4 position(mat4 transform_projection, vec4 vertex_position)
	{
		return transform_projection * vertex_position;
	}
	]],

	pixelShader = 
	[[
	extern number scroll;
	varying vec4 vpos;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{	
		texture_coords.x += scroll;
	  vec4 texColor = Texel(texture, texture_coords); 
	  return texColor;
	}
	]],

	vars =
	{
		speed = 0.000,
		scroll = 0,
		index = {"speed", "scroll"},
		sendIndex = {"scroll"}
	}
}

function Shader.xScroll:Update()
	self.vars.scroll = self.vars.scroll + self.vars.speed

	if(self.vars.scroll > 1) then
		self.vars.scroll = 0 + self.vars.speed
	end 

	self.shader:send("scroll", self.vars.scroll)
end 




-- Blue
------------------------------------------------------------
Shader.blue = 
{
	vertexShader =
	[[
		varying vec4 vpos;


		vec4 position(mat4 transform_projection, vec4 vertex_position)
		{
			return transform_projection * vertex_position;
		}
	]],

	pixelShader = 
	[[
		extern number red;
		varying vec4 vpos;

		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
		{
			return vec4(red, 0, 1, 1);
		}
	]],

	vars = 
	{
		red = 0,
		speed = 0.001,
		index = {"red", "speed"},
		sendIndex = {"red"}
	},
}

function Shader.blue:Update()
	self.vars.red = self.vars.red + self.vars.speed
	self.shader:send("red", self.vars.red)
end 

--	  vec4 texColor = Texel(texture, texture_coords); 
--	  return texColor;


-- Fade
---------------------------------------------------
Shader.test = 
{
	vertexShader =
	[[
		varying vec4 vpos;

		vec4 position(mat4 transform_projection, vec4 vertex_position)
		{
			return transform_projection * vertex_position;
		}
	]],

	pixelShader =
	[[
		varying vec4 vpos;

		vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
		{
			number x = texture_coords.x;
			return vec4(x,x,x,1);
		}
	]],

}


-- Scroller
----------------------------------------------
Shader.scroller = 
{
	vertexShader = 
	[[
	varying vec4 vpos;

	vec4 position(mat4 transform_projection, vec4 vertex_position)
	{
		return transform_projection * vertex_position;
	}
	]],

	pixelShader = 
	[[
	extern number scroll;
	extern number alpha;
	varying vec4 vpos;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
	{	
		texture_coords.x += scroll;
	  vec4 texColor = Texel(texture, texture_coords); 
	  texColor.a = alpha;
	  return texColor;
	}
	]],

	vars =
	{
		speed = 0.000,
		scroll = 0,
		alpha = 1,
		index = {"speed", "scroll", "alpha"},
		sendIndex = {"scroll", "alpha"}
	}
}

-----------------
-- Static End
-----------------

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