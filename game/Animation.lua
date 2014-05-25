-- makes animations from sprite frames
-- should handle itself for drawing

local Animation = {}


function Animation:New(data)

	----------
	-- Create
	----------
	local object = {}

	object.name = data.name or nil
	object.colors = data.colors or nil

	object.sheet = data.sheet or nil
	object.frames = data.frames or nil
	object.currentFrame = 1
	
	object.speedTime = 1
	object.speed = data.speed
	object.delayTime = 1
	object.delays = data.delays

	-------------
	-- Functions
	-------------
	-- update the frame based on the animation speed and frame delay
	function object:UpdateFrameTime()
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

		-- end of animation? --> need to add loop and stop options here
		if(self.currentFrame > #self.frames) then
			self.currentFrame = 1
		end 

	end 

	function object:Draw(objectData)

		if(self.colors) then
			love.graphics.setColor(self.colors[self.currentFrame])
		else
			love.graphics.setColor({255,255,255,255})
		end 

		love.graphics.draw(self.sheet, self.frames[self.currentFrame], objectData.x, objectData.y, objectData.angle, objectData.xScale, objectData.yScale)

		self:UpdateFrameTime()
	end 


	return object

end 





return Animation



