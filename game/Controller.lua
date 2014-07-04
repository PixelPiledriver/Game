-- manages using controllers

local Controller = {}


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
		if(controller.controller:isDown(buttons[buttons.buttonsList[i]].value)) then
			print(controller.playerName .. " " .. buttons[buttons.buttonsList[i]].name)
		end
	end

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
		print(controller.playerName .. " Left X: " .. controller.controller:getAxis(controller.leftStick.x.axis))
	end

	-- y
	if(math.abs(controller.leftStick.y.lastValue - controller.controller:getAxis(controller.leftStick.y.axis)) > minDifference ) then	
		controller.leftStick.y.lastValue = controller.controller:getAxis(controller.leftStick.y.axis)
		print(controller.playerName .. " Left Y: " .. controller.controller:getAxis(controller.leftStick.y.axis))
	end


	-- Right
	---------------------
	-- x
 	if(math.abs(controller.rightStick.x.lastValue - controller.controller:getAxis(controller.rightStick.x.axis)) > minDifference ) then
		controller.rightStick.x.lastValue = controller.controller:getAxis(controller.rightStick.x.axis)
		print(controller.playerName .. " Right X: " .. controller.controller:getAxis(controller.rightStick.x.axis))
	end

	-- y
	if(math.abs(controller.rightStick.y.lastValue - controller.controller:getAxis(controller.rightStick.y.axis)) > minDifference ) then	
		controller.rightStick.y.lastValue = controller.controller:getAxis(controller.rightStick.y.axis)
		print(controller.playerName .. " Right Y: " .. controller.controller:getAxis(controller.rightStick.y.axis))
	end


end

------------------
-- Functions
------------------

-- init controllers
-- this will need to be called again if a controller is synced during play
-- altho it will need some modifications for that to work properly
-- I'll do it later :P
function Controller:Setup()

	for i=1, #getControllers do

		print("controller" .. i .. " setup")

		-- add controller
		controllers[#controllers + 1] = {}


		local object = controllers[#controllers]

		-- setup
		object.claimed = false
		object.controller = getControllers[i]
		object.playerName = "Controller" .. i

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

		-- functions
		function object:Button(button)
			if(self.controller:isDown(buttons[button].value)) then
				return true
		end
	
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
	end 

end 


-- Vibration
-------------------------
-- Doesnt work :(

-- setup
Controller:Setup()

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