-- DrawList.lua

-- manages draw order of objects submitted to it


DrawList = {}

DrawList.mode = {}
DrawList.mode.options = {"static", "submit", "sort"}
DrawList.mode.selected = "submit"

DrawList.objects = {}
DrawList.objects.depthIndex = {}
DrawList.objects.lastDepthIndex = nil


function DrawList:Update()
	DrawList:Clear()
end 

function DrawList:CreateDepth(depth)

	if(self.objects[depth] == nil) then
		self.objects[depth] = {}
	end 

end 

-- add an object to be drawn at given depth
function DrawList:Submit(data)
	self:CreateDepth(data.depth)
	self.objects[data.depth][#self.objects[data.depth] + 1] = data.o

	-- store depths in use
	self.objects.depthIndex[#self.objects.depthIndex + 1] = data.depth

	--print(self.objects[self.objects.depthIndex[1]][1].oType)
end 

-- removes all objects
-- used for per frame submit style draw list
function DrawList:Clear()

	local depthIndex = TableSort:UniqueVars(self.objects.depthIndex)

	-- remove each depth
	for i=1, #depthIndex do

		-- remove each object
		
		for j=1, #self.objects[depthIndex[i]] do
			self.objects[depthIndex[i]][j] = nil
		end 

		self.objects[depthIndex[i]] = nil
	end 

	self.objects.lastDepthIndex = nil
	self.objects.lastDepthIndex = self.objects.depthIndex
	self.objects.depthIndex = nil
	self.objects.depthIndex = {}
end

function DrawList:SortDepthIndex()
	TableSort:SortByString(self.objects.depthIndex)
end 

function DrawList:Draw()

	local depthIndex = TableSort:UniqueVars(self.objects.depthIndex)
	TableSort:SortByString(depthIndex)

	for i=1, #depthIndex do
		for j=1, #self.objects[depthIndex[i]] do
			self.objects[depthIndex[i]][j]:Draw()
		end 
	end

end 


function DrawList:PrintDebugText()

	local depthIndexString = ""

	for i=1, #self.objects.lastDepthIndex do
		if(i == 1) then
			depthIndexString = depthIndexString .. self.objects.lastDepthIndex[i]
		else
			depthIndexString = depthIndexString .. ", " .. self.objects.lastDepthIndex[i]
		end 
	end



	DebugText:TextTable
	{
		{text = "", obj = "DrawList" },
		{text = "Draw"},
		{text = "---------------------"},
		{text = "Depth Index:"},
		{text = depthIndexString}
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


-- WORKS - but is annoying to add a submite function to each object
-- not that big of a deal I guess
-- might create a draw component to handle shit like that
-- but most draw funcitions are fairly different
-- so maybe I wont make a universal component for that

-- also I just realized that the index method I've created doesnt work
-- for 0 or negative values :|
-- maybe not the worst thing in the world but its def weird


