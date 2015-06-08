-- Animaiton.lua
-- makes animations from sprite frames
-- should handle itself for drawing


local Color = require("Color")
local Pos = require("Pos")
local Draw = require("Draw")


local Animation = {}

-----------------
-- Static Vars
-----------------

-- obj
Animation.name = "Animation"
Animation.oType = "Static"
Animation.dataType = "Data Constructor"



function Animation:New(data)
	
	
	-- bug checking stuff --> should really add this stuff to more files :P
	-- but should organize it in some way
	-----------
	-- Fails
	-----------
	-- number of delays does not match number of frames
	if(#data.frames ~= #data.delays) then
		printDebug{"Delays and Frames count not the same!", "animation"}
		return 
	end

	--------------
	-- Create
	--------------
	local o = {}

	-- object
	o.name = data.name or "..."
	o.oType = "Animation"
	o.dataType = "Graphics"

	-- color per frame
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
		depth = DrawList:GetLayer("Objects")
	}

	-------------
	-- Functions
	-------------

	function o:Update()
		self:UpdateFrameTime()
	end 

	-- update the frame based on the animation speed and frame delay
	function o:UpdateFrameTime()

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

 
	function o:DrawCall()

		-- color
		love.graphics.setColor(Color:AsTable(Color:Get(self.colors[self.currentFrame])))

		-- transform
		-- needs to be changed to processed by component
		local x = 0
		local y = 0
		local angle = 0
		local xScale = 3
		local yScale = 3

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

		love.graphics.draw(self.spriteSheet.image, self.frames[self.currentFrame].sprite, x, y, angle, xScale, yScale)

	end 

--[[
	function o:Draw(oData)

		if(self.colors) then
			love.graphics.setColor(self.colors[self.currentFrame])
		else
			love.graphics.setColor({255,255,255,255})
		end 

		love.graphics.draw(self.sheet, self.frames[self.currentFrame].frame, oData.x, oData.y, oData.angle, oData.xScale, oData.yScale)

		self:UpdateFrameTime()	
	end 
--]]

	ObjectUpdater:Add{o}
	return o

end 


ObjectUpdater:AddStatic(Animation)

return Animation



	