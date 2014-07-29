-- checks all the collision objects for collisions

local CollisionManager = {}



CollisionManager.objects = {}
CollisionManager.names = {}
CollisionManager.destroyList = {}


----------------------
-- Variables
----------------------

CollisionManager.destroyObjects = false


-------------------------
-- Collision Functions
-------------------------

function CollisionManager:PointToPoint(a, b)

	if(a.x == b.x and a.y == b.y) then
		printDebug{"Point to Point: collision", "Collision"}
		return true
	end 

	return false
end

function CollisionManager:PointToRect(point, rect)
	if(point.x > rect.x and point.x < rect.x + rect.width and point.y > rect.y ) then
		return true
	end

	return false
end 

function CollisionManager:RectToRect(a, b)
	local rect1, rect2

	if(a.x < b.x) then
		rect1 = 
		{
			min = 
			{	
				x = a.x,
				y = a.y
			},

			max = 
			{
				x = a.x + a.width,
				y = a.y + a.height
			}
		}

		rect2 =
		{
			min = 
			{	
				x = b.x,
				y = b.y
			},

			max = 
			{
				x = b.x + b.width,
				y = b.y + b.height
			}
		}

	else
		rect1 = 
		{
			min = 
			{	
				x = b.x,
				y = b.y
			},

			max = 
			{
				x = b.x + b.width,
				y = b.y + b.height
			}
		}

		rect2 =
		{
			min = 
			{	
				x = a.x,
				y = a.y
			},

			max = 
			{
				x = a.x + a.width,
				y = a.y + a.height
			}
		}
	end 


	if(rect2.min.x <= rect1.max.x and rect2.min.x >= rect1.min.x) then

		-- bottom right overlap
		if(rect2.min.y <= rect1.max.y and rect2.min.y >= rect1.min.y) then
			printDebug{"Rect to Rect: collision", "Collision"}
			return true
		end 

		-- top right overlap
		if(rect2.max.y >= rect1.min.y and rect2.max.y <= rect1.max.y) then
			printDebug{"Rect to Rect: collision", "Collision"}
			return true
		end

	end

	return false

end 


---------------
-- Functions
---------------

-- add a new object name
function CollisionManager:AddName(name)
	local add = true

	for i=1, #self.names do
		if(self.names[i] == name)then
			add = false
		end 
	end 

	if(add) then
		self.names[#self.names+1] = name
	end 

end 


-- add a new object
function CollisionManager:Add(object)
	--self.objects[#self.objects + 1] = object

	-- sort objects by name
	-- first object of this type? create table for them
	if(self.objects[object.name] == nil) then
		self.objects[object.name] = {}
		self:AddName(object.name)
	end 

	print(object.name)

	-- add object to table by name
	self.objects[object.name][#self.objects[object.name] + 1] = object

end

function CollisionManager:Destroy(obj)

	local add = true

	for i=1, #self.destroyList do
		if(self.destroyList[i] == obj.name) then
			add = false
			break
		end 
	end 

	if(add) then
		self.destroyList[#self.destroyList + 1] = obj.name
	end

end 

function CollisionManager:PrintDestroyList()
	for i=1, #self.destroyList do
		print(self.destroyList[i])
	end 
end

function CollisionManager:ClearDestroyedObjects()

	self:PrintDestroyList()
	
	-- only re-add objects that are not to be destroyed
	for i=1, #self.destroyList do

		local temp = self.objects[self.destroyList[i]]
		self.objects[self.destroyList[i]] = nil

		for j=1, #temp do

			if(temp[j].destroy == nil or temp[j].destroy == false) then
				print("Add")
				self:Add(temp[j])
			else
				print("remove")
				temp[j] = nil
			end 

		end 
	end

	
	-- remove slots and names for object types that there are none of
	local tempNames = {}
	--print("Names: " .. #self.names)

	for i=1, #self.names do
		--print(self.objects[self.names[i]])
		if(self.objects[self.names[i]] and #self.objects[self.names[i]] > 0) then	
			--print("name readded")
			tempNames[#tempNames + 1] = self.names[i]			
		end 
	end 

	--print("TempNames: " .. #tempNames)

	self.names = nil
	self.names = tempNames


	-- remove all names from destroy list
	self.destroyList = nil
	self.destroyList = {}

	-- set object table to newly cleared table
	temp = nil

	self.destroyObjects = false

	printDebug{"Collision destroyed", "Collision"}




-- Old 
----------------
--[[
	local temp = self.objects
	self.objects = nil
	self.objects = {}

	for i=1, #temp do
		if(temp[i].destroy == nil or temp[i].destroy == false) then
			self:Add(temp[i])
		end 

	end
	
	temp = nil

	self.destroyObjects = false

	printDebug{"Collision destroyed", "Collision"}
	--]]
end



function CollisionManager:CheckForCollisions()

	-- for each object type -- by name

	for t=1, #self.names do

		-- for each object of type
		for a=1, #self.objects[self.names[t]] do

			-- for each in collision list of a
			for c=1, #self.objects[self.names[t]][a].collisionList do
			
				for b=1, #self.objects[self.objects[self.names[t]][a].collisionList[c]] do
				
					local B = self.objects[self.objects[self.names[t]][a].collisionList[c]][b]
					local A = self.objects[self.names[t]][a]

					if(self:RectToRect(A, B)) then
						A:CollisionWith{other = B}
						B:CollisionWith{other = A}

						printDebug{A.name .. " +collision+ " .. B.name, "Collision"}
					end 

				end

			end

		end

	end 



	--[[
	for a=1, #self.objects do

		for b=a+1, #self.objects do
		
			-- continue loop
			repeat

				
				--self:PointToPoint(self.objects[a], self.objects[b])

				if(self:RectToRect(self.objects[a], self.objects[b])) then
					self.objects[a]:CollisionWith{other = self.objects[b]}
					self.objects[b]:CollisionWith{other = self.objects[a]}

					printDebug{self.objects[a].name .. " +collision+ " .. self.objects[b].name, "Collision"}
				end 

			until true

		end

	end


	--]]

end 


function CollisionManager:PrintDebugText()

	DebugText:Text("")
	DebugText:Text("Collision Manager")
	DebugText:Text("------------------------")

	-- names
	DebugText:Text("Names: " .. #self.names)
	for i=1, #self.names do

		if(self.objects[self.names[i]] ~= nil) then
			DebugText:Text(self.names[i] .. ": " .. #self.objects[self.names[i]])
		end 

	end 

	-- destroy list


end 

function CollisionManager:Update()
	--self:CheckForCollisions()
	self:PrintDebugText()
end 












return CollisionManager