-- Life.lua
-- basic component for destroying os when they get too old
-- this is for simple os like lines, boxes, etc
-- this is not a health component for players/enemies
-- do not confuse it for that

local ObjectUpdater = require("ObjectUpdater")


local Life = {}




--{life, maxLife, drain, parent}
function Life:New(data)

	local o = {}

	---------------------
	-- Create
	---------------------

	-- object
	o.name = data.name or "..."
	o.type = "Life"

	-- vars
	o.life = data.life or 100
	o.maxLife = data.maxLife or o.life
	o.drain = nil

	if(data.drain == nil) then
		o.drain = true
	else
		o.drain = data.drain
	end 

	o.parent = data.parent or nil

	function o:Update()
		self:Drain()
		self:CheckDead()
	end 


	-- lowers the life over time --> default behavior
	function o:Drain()

		if(self.drain) then
			self.life = self.life - 1
		end 

	end 
	
	-- check the life, if depleted, destroy
	function o:CheckDead()
		
		if(self.life <= 0) then
			ObjectUpdater:Destroy(self)
			ObjectUpdater:Destroy(self.parent)
		end 

	end 

	function o:Kill()
		self.life = 0
	end 

	function o:Add(v)
		self.life = self.life + v
	end

	function o:Sub(v)
		self.life = self.life - v
	end 

	function o:Reset()
		self.life = self.maxLife
	end


	ObjectUpdater:Add{o}

	return o

end


	



return Life

