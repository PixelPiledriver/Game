-- Button
-- click on it and it does stuff

local ObjectUpdater = require("ObjectUpdater")
local Box = require("Box")
local Collision = require("Collision")

local Button = {}


function Button:New(data)

	local object = {}
	----------------
	-- Variables
	----------------

	-- info
	object.name = data.name or "???"
	object.type = "button"

	-- pos
	object.x = data.x or 0
	object.y = data.y or 0

	-- size
	object.width = data.width or 100
	object.height = data.height or 50


	--rect
	object.useBox = data.useRect or true
	object.box =  Box:New
	{
		x = object.x,
		y = object.y,
		width = object.width,
		height = object.height
	}


	-- collision --> this uses collision objects
	-- need to also have a mouse based version
	object.collision = Collision:New
	{
		x = object.x,
		y = object.y,
		width = object.width,
		height = object.height,
		shape = "rect",
		name = "Mike",
		collisionList = {"MiniMouse"},
		parent = object
	}

	-- text
	object.text = data.text or "Button"

	-- graphics
	object.sprite = data.sprite or nil

	-- button
	object.hover = false
	object.func = data.func

	-- clicked
	object.clicked = false
	object.lastClicked = false

	----------------
	-- Functions
	----------------
	function object:Update()
		self:ClickButton()
		self.hover = false
		self.lastClicked = self.clicked
		self.clicked = false
	end

	function object:Draw()
		love.graphics.printf(self.text, self.x, self.y + self.height/2 - self.height/6, self.width, "center")
	end

	function object:OnCollision(data)
		self.hover = true
	end 

	function object:ClickButton()

		if(self.hover == true)then
			if(love.mouse.isDown("l")) then

				self.clicked = true

				if(self.lastClicked == false) then
					if(self.func) then
						self.func()
					else
						print("this button has no function")
					end 
				end

			end 
		end 

	end 





	ObjectUpdater:Add{object}

	return object
end 








return Button