-- makes animations from sprite frames
-- should handle itself for drawing

local Animation = {}


function Animation:New(data)

	-----------
	-- Fails
	-----------
	-- number of delays does not match number of frames
	if(#data.frames ~= #data.delays) then
		printDebug{"Delays and Frames count not the same!", "animation"}
		return 
	end

	----------
	-- Create
	----------
	local object = {}

	object.name = data.name or nil
	object.colors = data.colors or nil

	object.sheet = data.sheet or nil
	object.frames = data.frames or nil -- table of frames
	object.currentFrame = 1
	
	object.speedTime = 1
	object.speed = data.speed
	object.delayTime = 1
	object.delays = data.delays

	object.loopMax = data.loopMax or 0
	object.loopCount = 0

	object.active = true

	-------------
	-- Functions
	-------------
	-- update the frame based on the animation speed and frame delay
	function object:UpdateFrameTime()

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

	function object:Draw(objectData)

		if(self.colors) then
			love.graphics.setColor(self.colors[self.currentFrame])
		else
			love.graphics.setColor({255,255,255,255})
		end 

		love.graphics.draw(self.sheet, self.frames[self.currentFrame].frame, objectData.x, objectData.y, objectData.angle, objectData.xScale, objectData.yScale)

		self:UpdateFrameTime()	
	end 


	return object

end 





return Animation



	