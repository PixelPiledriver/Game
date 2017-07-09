-- Image.lua

-- Requires
---------------------
local Pos = require("Pos")
local Draw = require("Draw")
local Shader = require("Shader")
--------------------------------------------

local Image = {}

-------------------
-- Static Info
-------------------
Image.Info = Info:New
{
	objectType = "Image",
	dataType = "Graphics",
	structureType = "Static"
}

-----------------
-- Static Vars
-----------------

-- grab images from graphics folder
Image.readFromFolder = false
Image.folder = "graphics/"

-------------
-- Object
-------------

function Image:New(data)
	
	local o = {}

	o.shit = 1
	----------
	-- Info
	----------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Image",
		dataType = "Graphics",
		structureType = "Object"
	}


	----------
	-- Vars
	----------
	o.hide = false
	o.filename = nil

	if(Image.readFromFolder) then
		o.filename = Image.folder .. (data.filename or data[1])
	else
		o.filename = data.filename or data[1]
	end 

	---------------
	-- Components
	---------------
	o.Pos = Pos:New
	{
		x = data.x or 0,
		y = data.y or 0
	}

	---------------
	-- Functions
	---------------

	function o:Update()
	end 

	-------------
	-- Draw
	-------------

	function o:GetDepth()
		return self.Pos.y
	end 

	local defaultDraw =
	{
		parent = o,
		layer = data.layer or "Objects",
		GetDepth = o.GetDepth,
		first = data.first or false,
		last = data.last or false,
	}

	o.Draw = Draw:New(data.Draw or defaultDraw)
	--o.shader = Shader:Get("test")
	o.shader = data.shader and Shader:Get(data.shader) or Shader:Get("xScroll")

	-- load image from file
	o.image = love.graphics.newImage(o.filename)

	o.image:setWrap("repeat", "repeat")
	o.image:setFilter("nearest", "nearest")


	function o:DrawCall()

		-- dont draw?
		if(self.hide) then
			return 
		end 
		

		if(self.image == nil) then
			return
		end 


		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.image, self.Pos.x, self.Pos.y)

	end


	-- remove this object from the game permanently
	function o:Destroy()
		printDebug{"image destroyed", "Image"}
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.Pos)
		ObjectManager:Destroy(self.Draw)
		ObjectManager:Destroy(self.shader)
		self.image = nil
	end 


	------------
	-- End
	------------

	ObjectManager:Add{o}

	return o

end 


return Image



-- Notes
-------------------------

-- create image
-- local pic = Image:New{filename = "image.png"}