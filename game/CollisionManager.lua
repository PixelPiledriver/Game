-- checks all the collision objects for collisions

-- Requires
-----------------
-- local ObjectUpdater = require("ObjectUpdater")
-- leave out for now
-- cannot put a manager in a manager or some shit

local CollisionManager = {}


----------------------
-- Variables
----------------------

-- object
CollisionManager.name = "CollisionManager"
CollisionManager.oType = "Static"
CollisionManager.dataType = "Manager"

-- lists
CollisionManager.objects = {}
CollisionManager.names = {}
CollisionManager.destroyList = {}

-- flags
CollisionManager.destroyObjects = false

-------------------------
-- Collision Functions
-------------------------

-- {a = {x,y}, b = {x,y}}
function CollisionManager:PointToPoint(a, b)

	if(a.x == b.x and a.y == b.y) then
		printDebug{"Point to Point: collision", "Collision"}
		return true
	end 

	return false
end

-- {point = {x,y}, rect = {x,y,width,height} }
function CollisionManager:PointToRect(point, rect)
	if(point.x > rect.x and point.x < rect.x + rect.width and point.y > rect.y ) then
		return true
	end

	return false
end 

-- {a = {x,y,width,height}, b = {}}
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

-- add a new object name to ordered table of names --> straight array
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


-- add a new object to object table --> unordered, sorted by name
function CollisionManager:Add(object)
	--self.objects[#self.objects + 1] = object

	-- sort objects by name
	-- first object of this type? create table for them
	if(self.objects[object.name] == nil) then
		self.objects[object.name] = {}
		self:AddName(object.name)
	end 

	-- add object to table by name
	self.objects[object.name][#self.objects[object.name] + 1] = object

end

-- mark an object type to be destroyed on the next clear
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

-- does what is says
--> this should be ported to work with DebugText
function CollisionManager:PrintDestroyList()
	for i=1, #self.destroyList do
		print(self.destroyList[i])
	end 
end

-- removes all destroyed objects
-- from the lists
-- this does not include Statics --> are not destroyed --> for now
function CollisionManager:ClearDestroyedObjects()

	--self:PrintDestroyList()
	
	-- only re-add objects that are not to be destroyed
	for i=1, #self.destroyList do

		local temp = self.objects[self.destroyList[i]]
		self.objects[self.destroyList[i]] = nil

		for j=1, #temp do

			if(temp[j].destroy == nil or temp[j].destroy == false) then
				printDebug("Add", "Collision")
				self:Add(temp[j])
			else
				printDebug("remove", "Collision")
				temp[j] = nil
			end 

		end 
	end

	-- remove slots and names for object types that there are none of
	local tempNames = {}

	for i=1, #self.names do

		if(self.objects[self.names[i]] and #self.objects[self.names[i]] > 0) then	
			tempNames[#tempNames + 1] = self.names[i]			
		end 

	end 

	-- set names to newly built table
	self.names = nil
	self.names = tempNames

	-- remove all names from destroy list
	self.destroyList = nil
	self.destroyList = {}

	-- clear temp object table
	-- no need to set objects to this because they are added in the loop
	temp = nil

	-- done
	self.destroyObjects = false

end


-- runs collision checks on all objects
-- with objects they are able to collide with
function CollisionManager:CheckForCollisions()

	-- for each object type -- by name

	for n=1, #self.names do

		-- for each object of type
		local objList = self.objects[self.names[n]]

		for a=1, #objList do

			local obj = objList[a]

			for c=1, #obj.collisionList do
				local collisionObjectName = obj.collisionList[c]

				if(self.objects[collisionObjectName]) then

					repeat

						for b=1, #self.objects[collisionObjectName] do

							local B = self.objects[collisionObjectName][b]
							local A = obj

							-- only collide once?
							if((A.oneCollision and A.firstCollision) or (B.oneCollision and B.firstCollision)) then
								break
							end 

							if(self:RectToRect(A, B)) then

								A:CollisionWith{other = B}
								B:CollisionWith{other = A}

								--printDebug{A.name .. " +collision+ " .. B.name, "Collision"}
							end 

						end 

					until true

				end 

			end 
			
			

		end 

	end 
--[==[
			local obj = objList[a]

			repeat

				if(obj.collisionList == nil) then
					break
				end 

				-- for each in collision list of a
				for c=1, #obj.collisionList do
				

					for b=1, #objList[obj.collisionList[c]] do
					
						local B = objList[obj.collisionList[c]][b]
						local A = obj

						if(self:RectToRect(A, B)) then
							A:CollisionWith{other = B}
							B:CollisionWith{other = A}

							printDebug{A.name .. " +collision+ " .. B.name, "Collision"}
						end 

					end

				end

			until true

		end

	end 
	--]==]

end 


CollisionManager.printDebugTextActive = false


-- :P
function CollisionManager:PrintDebugText()
	
	if(self.printDebugTextActive == false) then
		return
	end 

	-- header
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

end 


function CollisionManager:Update()
	self:CheckForCollisions()
	self:PrintDebugText()
end 




-- leave out for now
-- cannot put a manager in a manager or some shit
--ObjectUpdater:AddStatic(CollisionManager)




return CollisionManager