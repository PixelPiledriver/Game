-- ScrollerSystem.lua
 
-- Purpose
----------------------------
-- controls images and sprites on paralax planes
-- use to demo scrolling level designs
-- tool built for artists to test backdrop art

------------------
-- Requires
------------------
local Scroller = require("Scroller")
local Link = require("Link")

---------------------------------------------------------------------------

local ScrollerSystem = {}


-------------------
-- Static Info
-------------------
ScrollerSystemInfo = Info:New
{
	objectType = "ScrollerSystem",
	dataType = "",
	structureType = "Static"
}




function ScrollerSystem:New(data)

	local o = {}

	------------------
	-- Info
	------------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "ScrollerSystem",
		dataType = "Level",
		structureType = "Object"
	}

	---------------------
	-- Prime Functions -- defined early
	---------------------
	function o:CalculateY(percent)
		return o.y + (Window.height - (Window.height * percent))
	end 


	----------------
	-- Vars
	----------------
	-- y location for the system
	o.y = data.y or 200

	--o.useGlobalSpeed = Bool:DataOrDefault(data.useGlobalSpeed or true)
	o.globalSpeed = data.speed or 0

	o.layers = {}

	-- creates test layers used to build this file
	function o:DefaultLayers()

		print("create default layers")

		o.layers[1] = 
		{
			speed = 0,
			scrollSpeed = 0,
			files = {"3_Ocean1.png", "food1.png", "food2.png", "food3.png", "food4.png"},
			index = 1,
			ready = true,
			y = o:CalculateY(1),
			currentScroller = nil,
			--destroy = false,
			--loop = false
		}

		o.layers[2] = 
		{
			speed = 0,
			scrollSpeed = 0,
			files = {"7_DistantClouds.png", "woman1.png", "woman2.png", "woman3.png", "woman4.png"},
			index = 1,
			ready = true,
			--y = o:CalculateY(0.9),
			y = o:CalculateY(1),
			currentScroller = nil,
			--destroy = false,
			--loop = false
		}

		o.layers[3] = 
		{
			speed = 0,
			scrollSpeed = 0,
			files = {"2_FireClouds.png", "cat1.png", "cat2.png", "cat3.png", "cat4.png"},
			index = 1,
			ready = true,
			--y = o:CalculateY(0.8),
			y = o:CalculateY(1),
			currentScroller = nil,
			--destroy = false,
			--loop = false
		}
	end

	function o:CustomLayers(folder)
		local filenames = love.filesystem.getDirectoryItems(folder)

		local expo = -4

		for i=1, #filenames do

			repeat
				
				if(love.filesystem.isDirectory(folder .. "/" .. filenames[i])) then
					print("yes")
					break
				else
					print("no")
				end 

				o.layers[#o.layers + 1] =
				{
					speed = 0,
					scrollSpeed = 0 + (i * 0.0015),
					files = {filenames[i]},
					index = 1,
					ready = true,
					--y = o:CalculateY(0.8),
					y = o:CalculateY(1),
					currentScroller = nil,
					folder = folder
					--destroy = false,
					--loop = false		
				}
			until true
		end 

	end 


	local customSystem = false

	if(data.folder) then
		o:CustomLayers(data.folder)
		customSystem = true
	else
		o:DefaultLayers()
	end 

	




	
	------------------
	-- Functions
	------------------

	function o:AddLayer()
		o.layers[#o.layers + 1] = {}
	end 

	function o:Update()
		o:Run()
	end 

	function o:Run()
		
		for i=1, #self.layers do


			if(self.layers[i].ready) then
				self.layers[i].currentScroller = Scroller:New
				{
					filename = self.layers[i].files[self.layers[i].index],
					y = self.layers[i].y,					
					speed = -self.layers[i].speed,
					parent = self,
					layer = i,
					start = 0,
					folder = self.layers[i].folder or nil,
					destroy = Bool:DataOrDefault(self.layers[i].destroy, nil),
					loop = Bool:DataOrDefault(self.layers[i].loop, nil),
					stop = Bool:DataOrDefault(self.layers[i].stop, nil),
					hide = Bool:DataOrDefault(self.layers[i].hide, nil)
				}

				self.layers[i].ready = false
			end 
		end 

	end 


	function o:Next(layerIndex)
		self.layers[layerIndex].ready = true
		self.layers[layerIndex].index = self.layers[layerIndex].index + 1

		-- loop index back to start?
		if(self.layers[layerIndex].index > #self.layers[layerIndex].files) then
			self.layers[layerIndex].index = 1
		end 
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

ObjectManager:AddStatic(ScrollerSystem)

return ScrollerSystem






-- Notes
---------------------------------------



--[==[ 
--Test Code
------------------

-- create scrollers for this layer

		if(self.layers[1].ready) then
			Scroller:New
			{
				filename = self.layers[1].files[self.layers[1].index],
				y = 200,
				parent = self,
				layer = 1,
				speed = -self.layers[1].speed
			}

			self.layers[1].ready = false
		end 



	o.layers[1] = 
	{
		speed = 0,
		scrollSpeed = 0,
		files = {"8_Ocean5.png", "food1.png", "food2.png", "food3.png", "food4.png"},
		index = 1,
		ready = true,
		y = o:CalculateY(1),
		currentScroller = nil,
		--destroy = false,
		--loop = false
	}

	o.layers[2] = 
	{
		speed = 0,
		scrollSpeed = 0,
		files = {"7_DistantClouds.png", "woman1.png", "woman2.png", "woman3.png", "woman4.png"},
		index = 1,
		ready = true,
		--y = o:CalculateY(0.9),
		y = o:CalculateY(1),
		currentScroller = nil,
		--destroy = false,
		--loop = false
	}

	o.layers[3] = 
	{
		speed = 0,
		scrollSpeed = 0,
		files = {"2_FireClouds.png", "cat1.png", "cat2.png", "cat3.png", "cat4.png"},
		index = 1,
		ready = true,
		--y = o:CalculateY(0.8),
		y = o:CalculateY(1),
		currentScroller = nil,
		--destroy = false,
		--loop = false
	}

	


--]==]