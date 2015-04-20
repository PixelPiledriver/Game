-- Collision
-- does stuff and checks if shit is hitting shit


local ObjectUpdater = require("ObjectUpdater")
local CollisionManager = require("CollisionManager")
local Color = require("Color")
local Pos = require("Pos")

-- new need to implement
local Size = require("Size")

local Collision = {}

-----------------
-- Static Vars
-----------------

Collision.name = "Collision"
Collision.oType = "Static"
Collision.dataType = "Object Constructor"

function Collision:New(data)

	-----------------
	-- Create
	-----------------
	local o = {}

	-- object
	o.name = data.name or "..."
	o.oType = "Collision"
	o.dataType = "Object"

	-- pos
	o.Pos = Pos:New
	{
		x = data.x or 100,
		y = data.y or 100
	}

	o.offsetX = o.Pos.x
	o.offsetY = o.Pos.y

	-- NEED TO convert thos over to use Size component
	--	o.width = data.width or nil
	--	o.height = data.height or nil
	o.Size = Size:New
	{
		width = data.width or 32,
		height = data.height or 32
	}

	-- shape
	o.shape = data.shape or "rect"-- point, rect only for now
	o.radius = data.radius or nil -- should add radius

	-- color
	o.color = data.color or Color:AsTable(Color:Get("white"))
	o.collisionColor = data.collisionColor or Color:AsTable(Color:Get("green"))

	-- stuff
	o.visible = data.visible
	if(data.visible == nil) then
		o.visible = true
	end 
	o.destroy = false
	o.collided = false
	o.collidedLastFrame = false

	-- objs that only hit once use this
	o.oneCollision = data.oneCollision or false
	o.firstCollision = false

	o.parent = data.parent or nil

	-- movment
	o.mouse = data.mouse or false

	if(o.parent and data.followParent == nil or data.followParent == true) then
		if(o.parent.Pos) then
			o.Pos:LinkPosTo
			{
				follow = data.parent.Pos,
				x = o.Pos.x - data.parent.Pos.x,
				y = o.Pos.y - data.parent.Pos.y
			}
		end 
	else
		-- do nothing
	end 

	-- collision list
	-- other objects that this object can collide with
	o.collisionList = data.collisionList or nil

	-- alignment
	o.vertCenter = data.vertCenter or false
	o.horzCenter = data.horzCenter or false

	-- draw
	o.draw = data.draw
	if(o.draw == nil) then
		o.draw = true
	end 


	
	-----------------
	-- Functions
	-----------------

	-- is object by name in the collision list?
	-- does collide with? --> its a question
	function o:DoesCollideWith(name)

		-- no collision list exists? it doesn't
		if(self.collisionList == nil) then
			return false
		end 

		for i=1, #self.collisionList do
			if(self.collisionList[i] == name) then
				return true
			end 
		end 

		return false

		--[[
		-- the named object IS in the list
		if(self.collisionList[name]) then
			return true
		else
			return false
		end
		--]]

	end 



	function o:CollisionWith(data)

		printDebug{self.collisionList, "Collision3"}
		printDebug{data.other.collisionList, "Collision3"}


		self.collided = true

		if(self.oneCollision) then
			self.firstCollision = true
		end

		-- do action
		if(self.parent and self.parent.OnCollision) then
			self.parent:OnCollision(data)	
		end

	end 

	function o:Draw()

		-- show?
		if(self.draw == false) then
			return
		end 

		love.graphics.setColor( self.collided and self.collisionColor or self.color)
		love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.width, self.Size.height)

	end 

	function o:FollowMouse()
		if(self.mouse == false) then
			return
		end 

			self.Pos.x = love.mouse.getX() + self.offsetX
			self.Pos.y = love.mouse.getY() + self.offsetY
		
	end 



	function o:Update()
		self:FollowMouse()
		--self:FollowParent()

		-- clear collision state --> and save state from last frame
		self.collidedLastFrame = self.collided
		self.collided = false
	end 


	function o:PrintDebugText()


		local parent = self.parent and self.parent.name or "no parent"		

		DebugText:TextTable
		{
			{text = "", obj = "Collision"},
			{text = "Collision"},
			{text = "-----------"},
			{text = "Width: " .. self.Size.width},
			{text = "Height: " .. self.Size.width},
			{text = "Parent: " .. parent}
		}

	end 

	CollisionManager:Add(o)
	ObjectUpdater:Add{o}

	return o


end


ObjectUpdater:AddStatic(Collision)


return Collision




-- notes
---------------

-- when you get back
-- commit collision
-- then re write it to be sorted by name
-- so os only check for os on their collision list
-- this should reduce the number of collision checks by a lot

-- also display a collision check counter



-- what does this do?
-- doesnt seem like its needed anymore
--[[
if(self.collisionList) then
	if(self:CheckCollisionList(data) == false) then
		self.collision = false
		return
	end
end
--]]

--[[
	-- same function as DoesObjectCollideWith
	function o:CheckCollisionList(data)
		
		-- no collision list exists
		if(self.collisionList == nil) then
			printDebug{"FALSE", "CollisionList"}
			
			return false
		end 

		if(self.collisionList[data.other.name]) then
			printDebug{"TRUE","CollisionList"}
			
			return true
		end 

		return false

	end 
--]]


--printDebug{"no CollisionList", "CollisionList"}

--printDebug{"TRUE","CollisionList"}


--[[
-- dont need this anymore
function o:FollowParent()
	if(self.followParent == false) then
		return
	end

	if(self.parent.Pos) then
		self.Pos.x = self.parent.Pos.x
		self.Pos.y = self.parent.Pos.y
	else
		self.Pos.x = self.parent.x
		self.Pos.y = self.parent.y
	end 

end 
--]]