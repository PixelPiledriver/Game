-- Line.lua

------------------
-- Requires
------------------
local Color = require("Color")
local Life = require("Life")
local Fade = require("Fade")
local Draw = require("Draw")
local Pos = require("Pos")

-------------------------------------------------------------------

local Line = {}

-----------------
-- Static Info
-----------------
Line.Info = Info:New
{
	objectType = "Line",
	dataType = "Graphics",
	structureType = "Static"
}

---------------------
-- Static Vars
---------------------
Line.normalColor = Color:Get("darkGreen")
Line.normalHingePoint = "startPoint"

---------------------
-- Object
---------------------

-- {a = {x,y}, b = {x,y}, width, color}
function Line:New(data)

	local o = {}

	--------------------------
	-- Object Info
	--------------------------

	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Line",
		dataType = "Graphics",
		structureType = "Object"
	}


	------------
	-- Vars
	------------

	-- start point
	o.a = {}
	o.a.x = data.a and data.a.x or 0
	o.a.y = data.a and data.a.y or 0
	o.a.parent = o

	-- end point
	o.b = {}
	o.b.x = data.b and data.b.x or 100
	o.b.y = data.b and data.b.y or 100
	o.b.parent = o

	-- graphics
	o.color = data.color or Color:Get("black")
	o.width = data.width or 1

	-- normal
	o.showNormal = Bool:DataOrDefault(data.showNormal, false)

	-- other
	o.collidablePoints = data.collidablePoints
	o.DrawLine = data.DrawLine


	------------------------
	-- Components
	------------------------
	if(data.life) then
		o.Life = Life:New
		{
			life = data.life,
			maxLife = data.maxLife,
			drain = data.drain,
			parent = o
		}
	end 

	if(data.fade) then	
		o.Fade = Fade:New
		{
			parent = o,
			fadeWithLife = data.fadeWithLife or false
		}
	end 

	local defaultDraw =
	{
		parent = o,
		layer = data.layer or "Objects",
		GetDepth = o.GetDepth,
		first = data.first or false,
		last = data.last or false,
	}

	o.Draw = Draw:New(defaultDraw)

	o.Pos = Pos:New{}

	--o.components = {"Life", "Fade", "Draw"}

	-----------------
	-- Functions
	-----------------

	-- returns a normal vector of this line
	function o:GetNormal()
		local dx = self.b.x - self.a.x
		local dy = self.b.y - self.a.y

		local normalRight = {x = -dy, y = dx}
		local normalLeft = {x = dy, y = -dx}

		return normalRight
	end

	function o:GetVector()
		return Math:LineToVector(self)
	end

	function o:GetLength()
		local dx = self.b.x - self.a.x
		local dy = self.b.y - self.a.y

		dx = dx * dx
		dy = dy * dy

		return math.sqrt(dx + dy)
	end 

	function o:Update()
	end

	function o:PostUpdate()

		if(self.collidablePoints) then
			self.a.collided = false
			self.b.collided = false			
		end 


	end 

	function o:DrawCall()

		-- draw this line
		love.graphics.setLineWidth(self.width)
		love.graphics.setColor(Color:AsTable(self.color))
		love.graphics.line(self.Pos.x + self.a.x, self.Pos.y + self.a.y, self.Pos.x + self.b.x, self.Pos.y + self.b.y)

		-- reset width
		love.graphics.setLineWidth(1)

		-- display normal or line
		if(self.showNormal) then
			love.graphics.setColor(Color:AsTable(Line.normalColor))

			local normal = self:GetNormal()
			normal = Math:UnitVector(normal)

			local vector = Math:LineToVector(self)
			local length = self:GetLength()

			local a =
			{
				x = self.Pos.x + self.a.x + (vector.x * (length/2)),
				y = self.Pos.y + self.a.y + (vector.y * (length/2)),
			}

			local b =
			{
				x = self.Pos.x + self.a.x + (vector.x * (length/2)) + (normal.x * 20),
				y = self.Pos.y + self.a.y + (vector.y * (length/2)) + (normal.y * 20)
			}

			love.graphics.line(a.x, a.y, b.x, b.y)

		end 


	end

	function o:OnCollision()
		printDebug{"point of line collided", "Line"}

		if(self.DrawLine and self.collidablePoints) then

			if(self.a.collided) then
				self.DrawLine:AddSelectedPoint(self.a)
			end 

			if(self.b.collided) then
				self.DrawLine:AddSelectedPoint(self.b)
			end 

		end 

	end 

	function o:PrintDebugText()

		local life = self.Life and self.Life.life or 0

		DebugText:TextTable
		{
			{text = "", obj = "Line" },
			{text = "Name: " .. self.Info.name},
			{text = "A: {" .. self.a.x .. "," .. self.a.y .. "}"},
			{text = "B: {" .. self.b.x .. "," .. self.b.y .. "}"},
			{text = "LifeCompValue: " .. life},
			{text = "Alpha: " .. self.color.a},
			--{text = "Fade: " .. (self.Fade and self.Fade.fade) or "noFade"} -- something broken with this
		}

	end


	function o:Destroy()
		
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.Life)
		ObjectManager:Destroy(self.Fade)
		ObjectManager:Destroy(self.Draw)
		ObjectManager:Destroy(self.Pos)

		--[=[
		for i=1, #self.components do
			if(self[self.components[i]]) then
				ObjectManager:Destroy(self[self.components[i]])
			end 
		end 
		--]=]

	end 


	ObjectManager:Add{o}

	return o

end 





return Line








-- Junk
------------------------------------------------------

-->NEED
-- currently only supports 2 verts
-- will add multi vert lines later


--[[
		
		local rot = Matrix.x3:Rotation(1)

		local newPointPos = Matrix.x3:MulPoint(rot, Vertex:AsPoint(self.a))


		self.a.x = newPointPos.x
		self.a.y = newPointPos.y



		Matrix.x3:RotateAround(self.b, self.a, 2)
		
--]]
