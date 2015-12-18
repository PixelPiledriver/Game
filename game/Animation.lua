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


----------------
-- Static Vars
----------------
Animation.default = {}
Animation.default.color = Color:Get("white")
Animation.default.frame = nil --> change to a "No Frame" image
Animation.default.delay = 10

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
	
	if(data.frames and data.delays) then

		-- total frames and delays not the same?
		if(#data.frames ~= #data.delays) then
			printDebug{"Animation:New FAILED!", "animation"}
			printDebug{"Delays and Frames count not the same!", "animation"}
			return 
		end

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
	o.colors = data.colors or nil

	o.spriteSheet = data.spriteSheet or nil

	--{Sprite, Sprite, ...}
	o.frames = data.frames or nil 

	o.currentFrame = 1
	
	o.speedTime = 1
	o.speed = data.speed or 1
	o.delayTime = 1
	o.delays = data.delays

	o.loopMax = data.loopMax or 0
	o.loopCount = 0


	o.pause = false
	o.active = Bool:DataOrDefault(data.active, true)
	o.draw = Bool:DataOrDefault(data.draw, true)

	-- can this animation be played again
	-- even if it is already playing
	o.canBeReplayed = Bool:DataOrDefault(data.canBeReplayed, true)
	o.startOverOnReplay = Bool:DataOrDefault(data.startOverOnReplay, true)


	-- component owner of this animation
	o.animationComponentParent = nil

	o.whenDonePlay = data.whenDonePlay or nil

	---------------
	-- Components
	---------------
	o.Pos = Pos:New
	{
		x = data.x or Pos.defaultPos.x,
		y = data.y or Pos.defaultPos.y
	}

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
	function o:AddFrames(data)

		-- no frame table? create
		if(self.frames == nil) then
			self.frames = {}
		end

		for i=1, #data do 
			self.frames[#self.frames+1] = data[i]
		end 

	end 

	function o:AddFrame(frame)
		self:AddFrames{frame}
	end 

	function o:Update()
		self:FrameTimeUpdate()
	end 

	-- handle animation speed and frame delay
	function o:FrameTimeUpdate()

		-- animation should be playing?
		if(self.active == false) then
			return
		end

		if(self.pause == true) then
			return
		end 

		-- animation has no frames?
		if(self.frames == nil or #self.frames <= 1) then
			printDebug{"Animation has no frames", "Animation", 2}
			return
		end 

		self.speedTime = self.speedTime + 1

		-- next delay?
		if(self.speedTime > self.speed) then
			self.speedTime = 1
			self.delayTime = self.delayTime + 1

			-- get delay, if none exist use the default from Animation static
			local delay = self.delays and self.delays[self.currentFrame] or Animation.default.delay

			-- next frame?
			if(self.delayTime > delay) then
				self.delayTime = 1
				self.currentFrame = self.currentFrame + 1
			end

		end 

		-- end of animation?
		if(self.currentFrame > #self.frames) then

			-->FIX
			-- this should be optional
			-- most no loop animations should end with their last frame showing
			-- not the first
			self.currentFrame = 1

			-- does this animation have a loop value?
			if(self.loopMax > 0) then
				self.loopCount = self.loopCount + 1

				-- reached the loop limit?
				if(self.loopCount >= self.loopMax) then
					self.active = false
					
					-- notify AnimationComponent this animation is finished
					if(self.animationComponentParent and self.selected) then
						self.animationComponentParent:DonePlaying()
					end 

				end 

			end 

		end 

	end 



 	-- render object to screen
	function o:DrawCall()

		if(self.draw == false) then
			return
		end 

		-- dont draw if animation has 0 frames
		if(self.frames == nil or #self.frames <= 0) then
			return
		end 

		-- set color
		if(self.color == nil) then
			love.graphics.setColor(Color:AsTable(Animation.default.color))
		else
			love.graphics.setColor(Color:AsTable(Color:Get(self.colors[self.currentFrame])))
		end 

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
				x = (self.parent.xAbs or self.parent.x) + self.Pos.x
				y = (self.parent.yAbs or self.parent.y) + self.Pos.y
			end 

		else
			x = self.Pos.x
			y = self.Pos.y
		end 

		love.graphics.draw(self.spriteSheet.image, self.frames[self.currentFrame].sprite, x, y, angle, self.Scale.x, self.Scale.y)

	end 

	function o:Destroy()
		ObjectManager:Destroy(self.Info)
		ObjectManager:Destroy(self.Pos)
		ObjectManager:Destroy(self.Draw)
		ObjectManager:Destroy(self.Scale)
	end


	function o:PrintDebugText()

		local textTable = 
		{
			{text = "", obj = "Animation" },
			{text = "Animation"},
			{text = "---------------------"},
		}

		if(self.frames and #self.frames > 0) then
			textTable[#textTable+1] = {text = #self.frames}
		end 


		DebugText:TextTable(textTable)

	end 

	----------
	-- End
	----------

	ObjectManager:Add{o}
	return o

end 


---------------
-- Static End
---------------

ObjectManager:AddStatic(Animation)

return Animation



-- Notes
---------------------------------------
-->NEED
-- support for particles, sound, collision boxes
-- animations dont just show sprites
-- they drive a game object

-- making lots of little changes to improve this object

-- old code but still works



-- Junk
-----------------------------------------------------
--[[

	-- name to call when state of object's 
	-- animation component wants to play this animation
	o.playName = data.playName or "Animation"



--]]