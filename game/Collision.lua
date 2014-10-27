-- Collision
-- does stuff and checks if shit is hitting shit


local ObjectUpdater = require("ObjectUpdater")
local CollisionManager = require("CollisionManager")
local Color = require("Color")

local Collision = {}


function Collision:New(data)

	local object = {}


	-----------------
	-- Variables
	-----------------

	-- other
	object.name = data.name or "???"
	object.type = "collision"

	-- pos
	object.x = data.x or -100
	object.y = data.y or -100

	-- shape
	object.shape = data.shape or "rect"-- point, rect only for now
	object.width = data.width or nil
	object.height = data.height or nil
	object.radius = data.radius or nil

	-- color
	object.color = data.color or Color:Get("white")
	object.collisionColor = data.collisionColor or Color:Get("green")

	-- stuff
	object.visible = data.visible
	if(data.visible == nil) then
		object.visible = true
	end 
	object.destroy = false
	object.collided = false

	-- objects that only hit once use this
	object.oneCollision = data.oneCollision or false
	object.firstCollision = false

	object.parent = data.parent or nil
	object.name = data.name
	object.type = "collision"

	-- movment
	object.mouse = data.mouse or false
	object.followParent = object.parent and true or false

	-- collision list
	-- others that this object can collide with
	object.collisionList = data.collisionList or nil

	-- alignment
	object.vertCenter = data.vertCenter or false
	object.horzCenter = data.horzCenter or false

	-- draw
	object.draw = data.draw
	if(object.draw == nil) then
		object.draw = true
	end 


	
	-----------------
	-- Functions
	-----------------

	function object:CheckCollisionList(data)
		
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

	function object:CollisionWith(data)

		printDebug{self.collisionList, "Collision3"}
		printDebug{data.other.collisionList, "Collision3"}

		-- what does this do?
		--[[
		if(self.collisionList) then
			if(self:CheckCollisionList(data) == false) then
				self.collision = false
				return
			end
		end
		--]]

		self.collided = true

		if(self.oneCollision) then
			self.firstCollision = true
		end

		-- do action
		if(self.parent and self.parent.OnCollision) then
			self.parent:OnCollision(data)	
		end

	end 

	function object:Draw()

		-- show?
		if(self.draw == false) then
			return
		end 

		love.graphics.setColor( self.collided and self.collisionColor or self.color)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

	end 

	function object:FollowMouse()
		if(self.mouse == false) then
			return
		end 

			self.x = love.mouse.getX()
			self.y = love.mouse.getY()
		
	end 

	function object:FollowParent()
		if(self.followParent == false) then
			return
		end

		self.x = self.parent.x
		self.y = self.parent.y

	end 

	function object:Update()
		self:FollowMouse()
		self:FollowParent()
		self.collided = false
	end 

	CollisionManager:Add(object)
	ObjectUpdater:Add{object}

	return object

end









return Collision




-- notes
---------------

-- when you get back
-- commit collision
-- then re write it to be sorted by name
-- so objects only check for objects on their collision list
-- this should reduce the number of collision checks by a lot

-- also display a collision check counter