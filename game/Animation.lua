-- Animaiton.lua
-->OLD
-->REVISE


-- Purpose
----------------------------
-- makes animations from sprite frames


------------------
-- Requires
------------------
local Color = require("Color")
local Pos = require("Pos")
local Draw = require("Draw")
local Scale = require("Scale")

---------------------------------------------------------------------------

local Animation = {}


-----------------
-- Static Info
-----------------
Animation.Info = Info:New
{
	objectType = "Animation",
	dataType = "Graphics",
	structureType = "Static",
}


---------------------
-- Static Functions
---------------------


-- Create an animation
-- data = 
-- {
-- 	 frames = { index table of frames to display},
--	 delays = { index table of numbers to control speed per frame},
--	 colors = { index table of colors per frame for shading},
--	 *loopMax = number of times you want the animation to play, 0 = infinite
-- }
function Animation:New(data)

	----------------
	-- Fail Cases
	----------------

	-- number of delays does not match number of frames
	if(#data.frames ~= #data.delays) then
		printDebug{"Animation:New FAILED!", "animation"}
		printDebug{"Delays and Frames count not the same!", "animation"}
		return 
	end


	local o = {}

	-----------------
	-- Object Info
	-----------------
	o.Info = Info:New
	{
		name = data.name or "...",
		objectType = "Animation",
		dataType = "Graphics",
		structureType = "Object"
	}


	----------------
	-- Vars
	----------------	
	o.colors = data.colors or "poop"

	o.spriteSheet = data.spriteSheet or nil
	o.frames = data.frames or nil -- table of frames
	o.currentFrame = 1
	
	o.speedTime = 1
	o.speed = data.speed or 1
	o.delayTime = 1
	o.delays = data.delays

	o.loopMax = data.loopMax or 0
	o.loopCount = 0

	o.active = true


	---------------
	-- Components
	---------------
	o.Pos = Pos:New(data.pos or Pos.defaultPos)

	o.Draw = Draw:New
	{
		parent = o,
		layer = "Objects"
	}

	o.Scale = Scale:New
	{
		x = data.Scale and data.Scale.x or 1,
		y = data.Scale and data.Scale.y or 1
	}

	--------------
	-- Functions
	--------------
	function o:Update()
		self:FrameTimeUpdate()
	end 

	-- handle animation speed and frame delay
	function o:FrameTimeUpdate()

		-- animation should be playing?
		if(self.active == false) then
			return
		end 

		self.speedTime = self.speedTime + 1

		-- next frame?
		if(self.speedTime > self.speed) then
			self.speedTime = 1
			self.delayTime = self.delayTime + 1

			if(self.delayTime > self.delays[self.currentFrame]) then
				self.delayTime = 1
				self.currentFrame = self.currentFrame + 1
			end 
		end 

		-- end of animation?
		if(self.currentFrame > #self.frames) then

			self.currentFrame = 1

			-- loop?
			if(self.loopMax > 0) then
				self.loopCount = self.loopCount + 1

				if(self.loopCount == self.loopMax) then
					self.active = false
				end 

			end 

		end 

	end 

 
 	-- render object to screen
	function o:DrawCall()

		-- color
		love.graphics.setColor(Color:AsTable(Color:Get(self.colors[self.currentFrame])))

		-- transform
		-- needs to be changed to processed by component
		local x = 0
		local y = 0
		local angle = 0

		if(self.parent) then

			if(self.parent.Pos) then
				x = self.parent.Pos.x + self.Pos.x
				y = self.parent.Pos.y + self.Pos.y
			else
				x = self.Pos.x
				y = self.Pos.y
			end 

		else
			x = self.Pos.x
			y = self.Pos.y
		end 

		love.graphics.draw(self.spriteSheet.image, self.frames[self.currentFrame].sprite, x, y, angle, self.Scale.x, self.Scale.y)

	end 

	function o:Destroy()
		ObjectUpdater:Destroy(self.Info)
		ObjectUpdater:Destroy(self.Pos)
		ObjectUpdater:Destroy(self.Draw)
		ObjectUpdater:Destroy(self.Scale)

	end 

	----------
	-- End
	----------

	ObjectUpdater:Add{o}
	return o

end 


---------------
-- Static End
---------------

ObjectUpdater:AddStatic(Animation)

return Animation



-- Notes
---------------------------------------
-- old code but still works