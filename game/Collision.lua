-- Collision
-- does stuff and checks if shit is hitting shit


local ObjectUpdater = require("ObjectUpdater")
local CollisionManager = require("CollisionManager")
local Color = require("Color")

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
	o.x = data.x or -100
	o.y = data.y or -100

	o.offsetX = o.x
	o.offsetY = o.y

	-- shape
	o.shape = data.shape or "rect"-- point, rect only for now
	o.width = data.width or nil
	o.height = data.height or nil
	o.radius = data.radius or nil

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

	-- os that only hit once use this
	o.oneCollision = data.oneCollision or false
	o.firstCollision = false

	o.parent = data.parent or nil

	-- movment
	o.mouse = data.mouse or false
	o.followParent = o.parent and true or false

	-- collision list
	-- others that this o can collide with
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

	function o:CheckCollisionList(data)
		
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

	function o:CollisionWith(data)

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

	function o:Draw()

		-- show?
		if(self.draw == false) then
			return
		end 

		love.graphics.setColor( self.collided and self.collisionColor or self.color)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

	end 

	function o:FollowMouse()
		if(self.mouse == false) then
			return
		end 

			self.x = love.mouse.getX() + self.offsetX
			self.y = love.mouse.getY() + self.offsetY
		
	end 

	function o:FollowParent()
		if(self.followParent == false) then
			return
		end

		self.x = self.parent.x
		self.y = self.parent.y

	end 

	function o:Update()
		self:FollowMouse()
		self:FollowParent()
		self.collided = false
	end 


	function o:PrintDebugText()


		local parent = self.parent and self.parent.name or "no parent"		

		DebugText:TextTable
		{
			{text = "", obj = "Collision"},
			{text = "Collision"},
			{text = "-----------"},
			{text = "Width: " .. self.width},
			{text = "Height: " .. self.height},
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