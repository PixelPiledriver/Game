-- DrawList.lua

-- manages draw order of objects submitted to it


DrawList = {}

--DrawList.submittedObjects
--DrawList.finalDrawOrder

DrawList.objects = {}
DrawList.objects.depthIndex = {}

function DrawList:CreateDepth(depth)

	if(self.objects[depth] == nil) then
		self.objects[depth] = {}
	end 

end 

function DrawList:Submit(data)
	self:CreateDepth(data.depth)
	self.objects[data.depth][#self.objects[data.depth] + 1] = data.o

	-- store depths in use
	self.objects.depthIndex[#self.objects.depthIndex + 1] = data.depth

	print(self.objects[self.objects.depthIndex[1]][1].oType)
end 

function DrawList:SortDepthIndex()

	TableSort:SortByString(self.objects.depthIndex)

end 

function DrawList:PrintDebugText()

	local depthIndexString = ""

	for i=1, #self.objects.depthIndex do
		if(i == 1) then
			depthIndexString = depthIndexString .. self.objects.depthIndex[i]
		else
			depthIndexString = depthIndexString .. ", " .. self.objects.depthIndex[i]
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

-- there should maybe be a way to make sure you cant submit an object more than once.... or should there? I dunno

-- need to hook this up to ObjectUpdater and get draw calls based on this and nothing else