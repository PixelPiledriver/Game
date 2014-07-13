-- checks all the collision objects for collisions

local CollisionManager = {}



CollisionManager.objects = {}


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

function CollisionManager:ClearDestroyedObjects()

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
end

function CollisionManager:Add(object)
	self.objects[#self.objects + 1] = object
end

function CollisionManager:CheckForCollisions()

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

end 

function CollisionManager:Update()
	self:CheckForCollisions()
end 












return CollisionManager