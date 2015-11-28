-- MapWorld.lua

-- Purpose
--------------------------------
-- a map where objects can be and interact
-- on a tile to tile basis --> similar to a roguelike

--------------
-- Requires
--------------
local MapTable = require("MapTable")
local Draw = require("Draw")
local Color = require("Color")
local MapObject = require("MapObject")

local MapWorld = {}


------------------
-- Static Info
------------------
MapWorld.Info = Info:New
{
	objectType = "MapWorld",
	dataType = "Game",
	structureType = "Static"
}

-----------------
-- Static Vars
-----------------


------------
-- Object
------------

function MapWorld:New(data)

	local o = {}

	o.map = MapTable:New
	{
		emptySlotDefault =
		{
			type = "empty",
			name = "empty Space",
			x = 0,
			y = 0,
			reactions = 
			{
				walk = {able = true}
			}
		},

		defaultIndex = {"type", "name", "x", "y", "reactions"}
	}

	if(data.size) then
		o.map:SetSize
		{
			width = data.size.width,
			height = data.size.height
		}
	end 

	------------
	-- Info
	------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "MapWorld",
		dataType = "Game",
		structureType = "Object"
	}

	-----------
	-- Vars
	-----------
	o.x = 100
	o.y = 100

	o.tileWidth = 32
	o.tileHeight = 32


	----------------
	-- Components
	----------------
	local defaultDraw =
	{
		parent = o,
		layer = "Objects",
		GetDepth = o.GetDepth,
		first = data.first or false,
		last = data.last or false,
	}

	o.Draw = Draw:New(data.Draw or defaultDraw)


	--------------
	-- Functions
	--------------

	function o:Add(data)
		o.map:Add(data)
	end

	function o:Get(x, y)
		return self.map:Get{x = x, y = y}
	end 

	function o:IsPosEmpty(x, y)
		return self.map:IsPosEmpty(x,y)

	end 

	function o:Update()

	
	end 


	function o:DrawCall()

		for x=1, self.map.width do
			for y=1, self.map.height do

				repeat
					if(self.map.map[x][y].sprite) then
						break
					end 

					local char = nil

					if(self.map.map[x][y].Info) then
						char = self.map.map[x][y].name
					else
						char = "x" -- self.map.map[x][y].x .. "," .. self.map.map[x][y].y --"x" --self.map.map[x][y] -- "o"
					end 

					LovePrint
					{
						text = char,
						x = self.x + (x * self.tileWidth),
						y = self.y + (y * self.tileHeight),
						color = Color:AsTable(Color:Get("black"))
					}
				until true

			end 
		end 

	end 


	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
		ObjectUpdater:Destroy(self.map)
		ObjectUpdater:Destroy(self.Draw)
	end 


	---------------
	-- End
	---------------

	ObjectUpdater:Add{o}

	return o

end 


----------------------
-- Static Functions
----------------------


ObjectUpdater:AddStatic(MapWorld)

return MapWorld


-- Notes
--------------------------
-- camera could be tied to mapWorld

-- needs to have at least 2 maps
-- one for objects - top layer
-- and one for terrain - bottom layer
-- other map layers may be needed