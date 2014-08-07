-- Button
-- click on it and it does stuff

local ObjectUpdater = require("ObjectUpdater")

local Button = {}


function Button:New(data)

	local object = {}
	----------------
	-- Variables
	----------------

	object.x = data.x or 0
	object.y = data.y or 0

	object.useRect = data.useRect or true
	object.width = data.width or 100
	object.height = data.height or 50
	object.text = data.text or "Button"

	object.sprite = data.sprite or nil

	----------------
	-- Functions
	----------------


	function object:Update()
	end

	function object:OnCollision()
	end 


	ObjectUpdater:Add{object}

	return object
end 








return Button