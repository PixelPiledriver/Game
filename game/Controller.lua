-- manages using controllers

local ObjectUpdater = require("ObjectUpdater")


local Controller = {}

----------------
-- Static Vars
----------------

Controller.name = "Controller"
Controller.oType = "Static"
Controller.dataType = "Input Constructor & Manager"


-- get all available controllers
-- needs to be cleaned up and added to Controller static table
local getControllers = love.joystick.getJoysticks()
local controllers = {}

-------------
-- Buttons
-------------
-- table of button values
local buttons = 
{
	-- pad
	up = {value = 1, name = "up"},
	down = {value = 2, name = "down"},
	left = {value = 3, name = "left"},
	right = {value = 4, name = "right"},

	-- center
	start = {value = 5, name = "Start"},
	back = {value = 6, name = "back"},
	Xbox = {value = 15, name = "Xbox"},

	-- stick buttons
	L3 = {value = 7, name = "L3"},
	R3 = {value = 8, name = "R3"},

	-- bumpers
	LB = {value = 9, name = "LB"},
	RB = {value = 10, name = "RB"},

	-- face buttons
	A = {value = 11, name = "A"},
	B = {value = 12, name = "B"},
	X = {value = 13, name = "X"},
	Y = {value = 14, name = "Y"},

	buttonsList =
	{
		"up", "down", "left", "right", "start", "back",
		"Xbox", "L3", "R3", "LB", "RB", "A", "B", "X", "Y"
	}
}

function Controller:ButtonTest(controller)

	for i=1, #buttons.buttonsList do

		local down = false

		-- button Down
		----------
		if(controller.controller:isDown(buttons[buttons.buttonsList[i]].value)) then
			controller.buttons[buttons.buttonsList[i]].pressed = true
			down = true
			printDebug{controller.playerName .. " " .. buttons[buttons.buttonsList[i]].name, "Controller"}
		end

		-- button Up
		-----------------
		if(down == false ) then
			if(controller.buttons[buttons.buttonsList[i]].lastValue == true) then
				print(buttons.buttonsList[i] .. " UP!")
			end
		end

	end

end 


-------------
-- Triggers
-------------
function Controller:TriggerTest(controller)
-- :D
end


-------------
-- Sticks
-------------
function Controller:SticksTest(controller)

  
  local minDifference = 0.1

	-- Left
	----------------
	-- check for major difference
	-- x
	if(math.abs(controller.leftStick.x.lastValue - controller.controller:getAxis(controller.leftStick.x.axis)) > minDifference ) then	
		controller.leftStick.x.lastValue = controller.controller:getAxis(controller.leftStick.x.axis)
		printDebug{controller.playerName .. " Left X: " .. controller.controller:getAxis(controller.leftStick.x.axis), "Controller"}
	end

	-- y
	if(math.abs(controller.leftStick.y.lastValue - controller.controller:getAxis(controller.leftStick.y.axis)) > minDifference ) then	
		controller.leftStick.y.lastValue = controller.controller:getAxis(controller.leftStick.y.axis)
		printDebug{controller.playerName .. " Left Y: " .. controller.controller:getAxis(controller.leftStick.y.axis), "Controller"}
	end


	-- Right
	---------------------
	-- x
 	if(math.abs(controller.rightStick.x.lastValue - controller.controller:getAxis(controller.rightStick.x.axis)) > minDifference ) then
		controller.rightStick.x.lastValue = controller.controller:getAxis(controller.rightStick.x.axis)
		printDebug{controller.playerName .. " Right X: " .. controller.controller:getAxis(controller.rightStick.x.axis), "Controller"}
	end

	-- y
	if(math.abs(controller.rightStick.y.lastValue - controller.controller:getAxis(controller.rightStick.y.axis)) > minDifference ) then	
		controller.rightStick.y.lastValue = controller.controller:getAxis(controller.rightStick.y.axis)
		printDebug{controller.playerName .. " Right Y: " .. controller.controller:getAxis(controller.rightStick.y.axis), "Controller"}
	end


end

------------------
-- Functions
------------------

function Controller:NewButtonTable(name)
	local b =
	{
		name = name,
		pressed = false,
		lastValue = false,
	}

	return b
end 

-- init controllers
-- this will need to be called again if a controller is synced during play
-- altho it will need some modifications for that to work properly
-- I'll do it later :P
-- also need to make this based on calling Controller:New()
-- currents structure is a bit wonk >:L
function Controller:Setup()

	for i=1, #getControllers do

		printDebug{"controller" .. i .. " setup", "Controller"}

		-- add controller
		controllers[#controllers + 1] = {}


		local object = controllers[#controllers]

		-- setup
		object.claimed = false
		object.controller = getControllers[i]
		object.playerName = "Controller" .. i

		object.buttons = 
		{
			A = self:NewButtonTable("A"),
			B = self:NewButtonTable("B"),
			X = self:NewButtonTable("X"),
			Y = self:NewButtonTable("Y"),

			up = self:NewButtonTable("up"),
			down = self:NewButtonTable("down"),
			left = self:NewButtonTable("left"),
			right = self:NewButtonTable("right"),

			start = self:NewButtonTable("start"),
			back = self:NewButtonTable("back"),
			Xbox = self:NewButtonTable("Xbox"),

			LB = self:NewButtonTable("LB"),
			RB = self:NewButtonTable("RB"),
			L3 = self:NewButtonTable("L3"),
			R3 = self:NewButtonTable("R3")
		}

		-- sticks
		object.leftStick = 
		{
			x =
			{
				axis = 1,
				lastValue = 0
			},

			y =
			{
				axis = 2,
				lastValue = 0
			}
		}

		object.rightStick = 
		{
			x =
			{
				axis = 3,
				lastValue = 0
			},

			y =
			{
				axis = 4,
				lastValue = 0
			}
		}

		object.rightTrigger =
		{
			axis = 5,
			lastValue = 0
		}

		object.leftTrigger =
		{
			axis = 6,
			lastValue = 0
		}


		------------------
		-- Functions
		------------------

		-- press button
		function object:ButtonDown(button)
			if(self.controller:isDown(buttons[button].value)) then
				
				if(self.buttons[buttons[button].name] == false) then
					self.buttons[buttons[button].name].pressed = true
				end 

				return true

			end
		end

		-- release button
		function object:ButtonUp(button)

			if(self.buttons[buttons[button]].pressed == false ) then
				if(self.buttons[buttons[button]].lastValue == true) then
					printDebug{buttons.buttonsList[i] .. " UP!", "Controller"}
				end
			end

		end 

		-- clears and stores from last frame
		function object:ClearButtonsPressed()

			-- for each button
			for i=1, #buttons.buttonsList do

				-- get current button
				local b = self.buttons[buttons.buttonsList[i]]

				-- store value for next frame
				b.lastValue = b.pressed

				-- clear
				b.pressed = false
			end 

		end 

		function object:PrintDebugText()

			DebugText:TextTable
			{
				{text = "", obj = "Controller"},
				{text = self.playerName},

				{text = "LeftStick:"},
				{text = "-------------"},
				{text = "X:" .. self.leftStick.x.lastValue},
				{text = "Y:" .. self.leftStick.y.lastValue},

				{text = "Buttons"},
				{text = "-------------"},
				{text = "A: " .. tostring(self.buttons["A"])},
				
				{text = "B: " .. tostring(self.buttons["B"])},
				{text = "X: " .. tostring(self.buttons["X"])},
				{text = "Y: " .. tostring(self.buttons["Y"])},
				{text = "Y: " .. tostring(self.buttons["Y"])},

				{text = "start: " .. tostring(self.buttons["start"])},
				{text = "back: " .. tostring(self.buttons["back"])},
				{text = "Xbox: " .. tostring(self.buttons["Xbox"])},

				{text = "RB: " .. tostring(self.buttons["RB"])},
				{text = "LB: " .. tostring(self.buttons["LB"])},
				{text = "L3: " .. tostring(self.buttons["L3"])},
				{text = "R3: " .. tostring(self.buttons["R3"])},

				{text = "up: " .. tostring(self.buttons["up"])},
				{text = "down: " .. tostring(self.buttons["down"])},
				{text = "left: " .. tostring(self.buttons["left"])},
				{text = "right: " .. tostring(self.buttons["right"])},
			}

		end 

	end
end


-- returns the number of controllers connected
function Controller:Count()
	return #controllers
end 


-- returns a controller that no one else is using
function Controller:GetUnclaimedController()

	for i=1, #controllers do
		if(controllers[i].claimed == false) then

			controllers[i].claimed = true
			return controllers[i]

		end 
	end 

	return nil
	
end 


-- quick test controller input
function Controller:Update()

	for i=1, #controllers do
		Controller:SticksTest(controllers[i])
		Controller:ButtonTest(controllers[i])
		controllers[i]:PrintDebugText()
		controllers[i]:ClearButtonsPressed()
	end 



end 


-- Vibration
-------------------------
-- Doesnt work :(s
-- hopefully will work in next update of SDL
-- which is what Love2D is built with

-- setup
Controller:Setup()

ObjectUpdater:AddStatic(Controller)

return Controller





-- Notes
---------------------------------------
--[[
-- count the number of connected controllers
print(love.joystick.getJoystickCount())


-- print out the names of connected controllers
local controllers = love.joystick.getJoysticks()

for i=1, #controllers do
	print(controllers[i]:getName())
end 


-- get a single controller and
-- see if we can fuck with it
local player1 = controllers[1]
print(player1:getName())
print(player1:getButtonCount())
--]]




-- Tests
		--Controller:SticksTest(controllers[i])
		--Controller:ButtonTest(controllers[i])
		--Controller:TriggerTest(controllers[i])