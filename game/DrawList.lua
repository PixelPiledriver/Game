-- DrawList.lua

-- manages draw order of objects submitted to it


DrawList = {}

DrawList.mode = {}
DrawList.mode.options = {"static", "submit", "sort"}
DrawList.mode.selected = "submit"

DrawList.objects = {}
DrawList.objects.layerIndex = {}
DrawList.objects.lastLayerIndex = nil

DrawList.layers = 
{
	Skybox = {value = 1, active = false},
	Backdrop = {value = 2, active = false},
	Objects = {value = 3, active = true},
	Collision = {value = 4, active = false},
	Hud = {value = 5, active = false},
	DebugText = {value = 6, active = false},

	index = 
	{
		"Skybox", "Backdrop", "Objects", "Collision", "Hud", "DebugText"
	}
}


function DrawList:Update()
	self:UpdateMode()
end 

function DrawList:UpdateMode()
	if(self.mode.selected == "submit") then
		self:Clear()
	end 
end 


function DrawList:GetLayer(name)
	return DrawList.layers[name].value
end 

function DrawList:CreateLayer(layer)

	if(self.objects[layer] == nil) then
		self.objects[layer] = {}
	end 

end 

function DrawList:CreateDepth(layer, depth)

	self:CreateLayer(layer)

	if(self.objects[layer][depth] == nil) then
		self.objects[layer][depth] = {}
	end 

end 

-- add an object to be drawn at given depth
function DrawList:Submit(data)

	local layer = data.layer
	local depth = data.depth

	self:CreateLayer(depth)
	self.objects[depth][#self.objects[depth] + 1] = data.o

	-- store depths in use
	self.objects.layerIndex[#self.objects.layerIndex + 1] = depth

	--print(self.objects[self.objects.layerIndex[1]][1].oType)
end 

-- removes all objects
-- used for per frame submit style draw list
function DrawList:Clear()

	local layerIndex = TableSort:UniqueVars(self.objects.layerIndex)

	-- remove each depth
	for i=1, #layerIndex do

		-- remove each object
		
		for j=1, #self.objects[layerIndex[i]] do
			self.objects[layerIndex[i]][j] = nil
		end 

		self.objects[layerIndex[i]] = nil
	end 

	self.objects.lastLayerIndex = nil
	self.objects.lastLayerIndex = self.objects.layerIndex
	self.objects.layerIndex = nil
	self.objects.layerIndex = {}
end

function DrawList:SortLayerIndex()
	TableSort:SortByString(self.objects.layerIndex)
end 

function DrawList:Draw()

	local layerIndex = TableSort:UniqueVars(self.objects.layerIndex)
	TableSort:SortByString(layerIndex)

	for i=1, #layerIndex do
		
		repeat

			-- is this layer/depth active?
			if(self.layers[self.layers.index[layerIndex[i]]].active == false) then

				break
			end

			-- draw each object in this layer
			for j=1, #self.objects[layerIndex[i]] do
				
				-- currently just calls DrawCall directly
				-- but should probly go thru Draw component
				--self.objects[layerIndex[i]][j]:DrawCall() 
				self.objects[layerIndex[i]][j].Draw:Draw()

				

			end 

		until true
	end

end 


function DrawList:PrintDebugText()

	local layerIndexString = ""

	for i=1, #self.objects.lastLayerIndex do
		if(i == 1) then
			layerIndexString = layerIndexString .. self.objects.lastLayerIndex[i]
		else
			layerIndexString = layerIndexString .. ", " .. self.objects.lastLayerIndex[i]
		end 
	end



	DebugText:TextTable
	{
		{text = "", obj = "DrawList" },
		{text = "Draw"},
		{text = "---------------------"},
		{text = "Depth Index:"},
		{text = layerIndexString}
	}
end

ObjectUpdater:AddStatic(DrawList)


-- Notes
-------------------- 
-- send objects and and layering value to draw them at during Update
-- when Draw calls back, sort the order of draws
-- then draw them all

-- objects with lower numbers are drawn first

-- try a couple different variations of draw order structure
-- I'd like to do an indexed version that uses no sorting

-- there should maybe be a way to make sure you cant submit an object more than once.... 
-- or should there? I dunno

-- need to hook this up to ObjectUpdater and get draw calls based on this and nothing else
-- actually I might just call this directly from the call back
-- no need to even go thru ObjectUpdater

-- what to do when an object is deleted?
-- how will it be removed from the list?

-- I want to do 2 variations of DrawList:

-- static DrawList
-- 	objects submit once and are drawn
-- 	nil objects are removed from drawList
-- 	makes it so a new list does not need to be reformed
-- 	but also makes updating sorting a bit weird

-- per frame DrawList
-- 	all objects submit to be drawn EVERY frame
-- 	draw all objects
-- 	then clear the draw list
-- 	this ensures that sorting is always up to date
-- 	but will probly take more processing -> perhaps not a big deal tho


-- WORKS - but is annoying to add a submit function to each object
-- not that big of a deal I guess
-- might create a draw component to handle shit like that
-- but most draw funcitions are fairly different
-- so maybe I wont make a universal component for that

-- also I just realized that the index method I've created doesnt work
-- for 0 or negative values :|
-- maybe not the worst thing in the world but its def weird

-- NEEDED
-- "layering" seperate from "depth"
-- the current implementation is actually layering and does not sort by a
-- depth value
-- objects could submit their y or z value
-- that would actually work with what I already have but I want to have
-- a layering structure on top as well for different draw spaces and object types
-- hud, debug, text, sprites, skybox, etc

-- NEEDED
-- convert layer names to value interally instead of having to call GetLayer from the outside

-- DONE - sorta
-- toggleable layers and depths to draw or not draw
-- mostly for debug purposes

-- DONE
-- predefined layer values as names

-- NEEDED
-- a LAST slot to draw a selected object on top of all others in its layer
-- also a FIRST for the opposite end, just cuz I might need it
-- last is way more important and useful tho

