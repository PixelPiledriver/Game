--  CollisionManager.lua
-->CLEAN
-->REVISE
-->COMMENT

-- Purpose
----------------------------
-- checks all the collision objects for collisions

---------------------------------------------------------------------
-- global
CollisionManager = {}


----------------------
-- Static Vars
----------------------
CollisionManager.Info = Info:New
{
	objectType = "CollisionManager",
	dataType = "Collision",
	structureType = "Manager"
}

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

	if(a.Pos.x == b.Pos.x and a.Pos.y == b.Pos.y) then
		printDebug{"Point to Point: collision", "CollisionManager"}
		return true
	end 

	return false
end

-- {point = {x,y}, rect = {x,y,width,height} }
function CollisionManager:PointToRect(point, rect)
	if(point.x > rect.Pos.x and point.x < rect.Pos.x + rect.Size.width and point.y > rect.Pos.y and point.y < rect.Pos.y + rect.Size.height) then
		return true
	end

	return false
end 

-- {a = {x,y,width,height}, b = {}}
function CollisionManager:RectToRect(a, b)
	local rect1, rect2

	if(a.Pos.x < b.Pos.x) then
		rect1 = 
		{
			min = 
			{	
				x = a.Pos.x,
				y = a.Pos.y
			},

			max = 
			{
				x = a.Pos.x + a.Size.width,
				y = a.Pos.y + a.Size.height
			}
		}

		rect2 =
		{
			min = 
			{	
				x = b.Pos.x,
				y = b.Pos.y
			},

			max = 
			{
				x = b.Pos.x + b.Size.width,
				y = b.Pos.y + b.Size.height
			}
		}

	else
		rect1 = 
		{
			min = 
			{	
				x = b.Pos.x,
				y = b.Pos.y
			},

			max = 
			{
				x = b.Pos.x + b.Size.width,
				y = b.Pos.y + b.Size.height
			}
		}

		rect2 =
		{
			min = 
			{	
				x = a.Pos.x,
				y = a.Pos.y
			},

			max = 
			{
				x = a.Pos.x + a.Size.width,
				y = a.Pos.y + a.Size.height
			}
		}
	end 


	if(rect2.min.x <= rect1.max.x and rect2.min.x >= rect1.min.x) then

		-- bottom right overlap
		if(rect2.min.y <= rect1.max.y and rect2.min.y >= rect1.min.y) then
			printDebug{"Rect to Rect: collision", "CollisionManager"}
			return true
		end 

		-- top right overlap
		if(rect2.max.y >= rect1.min.y and rect2.max.y <= rect1.max.y) then
			printDebug{"Rect to Rect: collision", "CollisionManager"}
			return true
		end

	end

	return false

end 

----------------------
-- Static Functions
----------------------

-- add a new object name to ordered table of names --> index table
function CollisionManager:AddName(name)
	local add = true

	-- does name already exist?
	for i=1, #self.names do

		-- it does, don't create
		if(self.names[i] == name)then
			add = false
		end 
	end 

	-- new name, add to table
	if(add) then
		self.names[#self.names+1] = name
	end 

end



-- add a new object to object table --> unordered, sorted by name
function CollisionManager:Add(object)

	-- sort objects by name
	-- first object of this type? create table for them
	if(self.objects[object.Info.name] == nil) then
		self.objects[object.Info.name] = {}
		self:AddName(object.Info.name)
	end 

	-- add object to table by name
	self.objects[object.Info.name][#self.objects[object.Info.name] + 1] = object

	-- save index pos of object in list 
	-- use later to destroy this object
	object.indexInCollisionManager = #self.objects[object.Info.name]

end

-- does what is says
-->FIX 
-- this should be ported to work with DebugText
function CollisionManager:PrintDestroyList()
	--[[
	for i=1, #self.destroyList do
		print(self.destroyList[i])
	end 
	--]]
end


-->FIX this shit is broken
-- mark an object type to be destroyed on the next clear
function CollisionManager:Destroy(obj)

	obj.destroyThisCollisionObject = true

	-- flag to indicate objects need to be destroyed
	-- at the end of this frame
	self.destroyObjects = true

end 

-- removes all destroyed objects from manager
-- and then rebuilds list from whats left
function CollisionManager:ClearDestroyedObjects()

	local temp = self.objects
	self.objects = nil
	self.objects = {}

	for i=1, #self.names do
		for j=1, #temp[self.names[i]] do

			repeat

				-- should object be destroyed?
				-- then don't add it to rebuilt table
				if(temp[self.names[i]][j].destroyThisCollisionObject) then
					break
				end 

				-- this object still lives
				-- add it to the new rebuilt objects table
				self:Add(temp[self.names[i]][j])

			until true
		end 
	end 



	-- remove empty names from list
	local tempNames = {}
	for i=1, #self.names do
		repeat

		if(self.objects[self.names[i]] == nil or #self.objects[self.names[i]] == 0) then
			break
		end 

		tempNames[#tempNames+1] = self.names[i]

		until true
	end 

	self.names = nil
	self.names = tempNames



	-- done, put destroy flag down so this doesnt run again next frame
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

			if(obj.collissionList) then
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

									printDebug{A.Info.name .. " +collision+ " .. B.Info.name, "CollisionManager"}
								end 

							end 

						until true

					end 

				end 
			end 


			-- points to collide with
			if(obj.pointsList) then
				for i=1, #obj.pointsList do

					if(self:PointToRect(obj.pointsList[i], obj))then
						obj:CollisionWith{other = obj.pointsList[i]}
					end 

				end 

				if(obj.clearPoints) then
					obj.pointsList = nil
				end 
			end 

			
			

		end 

	end 

end 


-- needs to be a feature of PrintDebugText -->FIX
CollisionManager.printDebugTextActive = true


-- function is bugged right now
-- needs to be fixed
-- i think this is an old style of coding the debug text ->FIX
function CollisionManager:PrintDebugText()
	
	if(self.printDebugTextActive == false) then
		return
	end 

	local textTable =	
	{
		{text = "", obj = "CollisionManager" },
		{text = "CollisionManager"},
		{text = "---------------------"},
		{text = #self.names}, -- total unique collision objects names
	}
	
	-- print objects per name
	for i=1, #self.names do
		textTable[#textTable+1] = {text = self.names[i] .. ": " .. #self.objects[self.names[i]] }
	end 

	DebugText:TextTable(textTable)

end 


function CollisionManager:Update()
	self:CheckForCollisions()
	self:PrintDebugText()
end 


---------------
-- Static End
---------------

--ObjectManager:AddStatic(CollisionManager)




-- Notes
---------------------------------------


-->FIX
-- Collision Manager is not meant to be submitted to ObjectManager
-- it remains as its own Manager type
-- leave it out for now
-- will refactor how that works later 




-- Junk
----------------------------------------------------
--[=[




--------------------------------------------
Destroy Functions for Collision Objects
--------------------------------------------
-- I'm completely re writing how these work
-- these are the old versions


-- does what is says
-->FIX 
-- this should be ported to work with DebugText
function CollisionManager:PrintDestroyList()
	for i=1, #self.destroyList do
		print(self.destroyList[i])
	end 
end


-->FIX this shit is broken
-- mark an object type to be destroyed on the next clear
function CollisionManager:Destroy(obj)


	--obj.destroy = true
	--self.destroyList[#self.destroyList + 1] = {obj.name, obj.indexInCollisionManager}

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

-- removes all destroyed objects
-- from the lists
-- this does not include Statics --> are not destroyed --> for now
function CollisionManager:ClearDestroyedObjects()
	
	-- only re-add objects that are not to be destroyed
	for i=1, #self.destroyList do

		local temp = self.objects[self.destroyList[i]]
		self.objects[self.destroyList[i]] = nil

		for j=1, #temp do

			if(temp[j].destroy == nil or temp[j].destroy == false) then
				printDebug("Add", "CollisionManager")
				self:Add(temp[j])
			else
				printDebug("remove", "CollisionManager")
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





--]=]



