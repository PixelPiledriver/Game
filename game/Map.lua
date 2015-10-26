-- Map.lua

-- Purpose
-----------------
-- base test map with tiles that show terrain 
-- and respond to player movement

--------------
-- Requires
---------------
local Box = require("Box")
local Color = require("Color")

------------------------------------------------------------

local Map = {}

-----------------
-- Static Info
-----------------
Map.Info = Info:New
{
	objectType = "Map",
	dataType = "Level",
	structureType = "Static"
}

-----------------
-- Static Vars
-----------------

Map.tileWidth = 64
Map.tileHeight = 32

Map.width = 10
Map.height = 6

Map.opacity = 150

Map.x = Map.tileWidth * 2
Map.y = Map.tileHeight * 5
Map.z = 0

Map.xStart = ((Map.x - (Map.x % Map.tileWidth)) / Map.tileWidth) + 1
Map.yStart = ((Map.y - (Map.y % Map.tileHeight)) / Map.tileHeight) + 1


Map.tiles = 
{ 
	x = {}, 
}


--------------------------
-- Static Functions
--------------------------

-- create a single tile
-- this should be its own type -->FIX
function Map:MakeTile(data)

	local o = {}

	o.Info = Info:New
	{
		name = data.name or "???",
		objectType = "Tile",
		dataType = "Level",
		stuctureType = "Object"
	}

	o.box = Box:New
	{
		x = data.x,
		y = data.y,
		width = data.width,
		height = data.height,
		color = Color:Get("white"),
		fill = false
	}

	o.box.color[4] = self.opacity


	--------------
	-- Variables
	--------------

	o.x = data.x
	o.y = data.y
	o.z = data.z
	o.startZ = data.z
	
	o.objectOnTop = false
	o.cushion = 4
	o.cushionSpeed = 0.2


	--------------
	-- Functions
	--------------

	function object:VerticalCushion()
		if(o.objectOnTop) then
			self.z = self.z + self.cushionSpeed

			if(self.z > self.startZ + self.cushion) then
				self.z = self.startZ + self.cushion
			end 

		else			

			if(self.z > self.startZ) then
				self.z = self.z * 0.9
			end 

		end



		self.objectOnTop = false

	end

	function object:Offset()
		self.box.y = self.y + self.z
	end 

	--------------
	-- Manage
	--------------

	-- space in map doesnt exist? --> create it
	if(self.tiles.x[data.xIndex] == nil) then
		self.tiles.x[data.xIndex] = {}

		if(self.tiles.x[data.xIndex].y == nil) then
			self.tiles.x[data.xIndex].y = {}			
		end 

	end 

	-- add to Map
	self.tiles.x[data.xIndex].y[data.yIndex] = object

	-- add to object manager
	ObjectUpdater:Add{object}

	return object
end


-- create the base test map
function Map:Create()

	for x=1, self.width do
		for y=1, self.height do

			self:MakeTile
			{
				x = (self.x + (x-1) * Map.tileWidth + (1 * x)) ,
				y = (self.y + (y-1) * Map.tileHeight + (1 * y)),
				z = x * -2,
				width = Map.tileWidth - 1,
				height = Map.tileHeight - 1,
				xIndex = x,
				yIndex = y,

			}

		end 	
	end 

function Map:GetTile(x,y)
	return self.tiles.x[x].y[y]
end 

function Map:ToggleMapDraw()
	for x=1, #self.tiles.x do
		for y=1, #self.tiles.x[x].y do
 			Map:GetTile(x,y).box.draw = not Map:GetTile(x,y).box.draw
		end 
	end  
end

function Map:ObjectInTile(obj)

	local x = obj.mapX - self.xStart + 1
	local y = obj.mapY - self.yStart + 1


	--print(x .. " " .. y)

	if(x < 1 or y < 1 ) then
	
		return nil
	end 

	if(x > self.width or y > self.height) then
	
		return nil
	end

	local tile = self:GetTile(x, y)
	
	tile.box.color = Color:Get(obj.playerColor)
	tile.box.color[4] = self.opacity
	tile.objectOnTop = true

	return tile

end 


end 


function Map:PrintDebugText()	
	DebugText:TextTable
	{
		{text = ""},
		{text = "Map"},
		{text = "---------"},
		{text = #self.tiles.x},
		{text = #self.tiles.x[1].y},

		{text = self.xStart .. " "  .. self.yStart}


	}
end



function Map:Update()

	self:PrintDebugText()

	for x=1, #self.tiles.x do
		for y=1, #self.tiles.x[x].y do

			local tile = Map:GetTile(x,y)
			
			tile:VerticalCushion()
			tile:Offset()

		end 
	end 

end 

-- Map is currently set to be created and draw
-- To toggle the map draw, require Map.lua and call 
-- Map:ToggleMapDraw() in your level file

return Map


-- Notes
------------------------------
-- Tile type is part of this file and not broken off into its own thing
-- that needs to be fixed

-- this file is OLD
-- and needs to be broken down and repurposed
-- Depricate soon