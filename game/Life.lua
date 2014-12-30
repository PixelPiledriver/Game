-- Life.lua
-- basic component for destroying os when they get too old
-- this is for simple os like lines, boxes, etc
-- this is not a health component for players/enemies
-- do not confuse it for that --> BITCH! >:D

local ObjectUpdater = require("ObjectUpdater")


local Life = {}

-----------------
-- Static Vars
-----------------

Life.name = "Life"
Life.oType = "Static"
Life.dataType = "Component Construtor"


--{life, maxLife, drain, parent}
function Life:New(data)

	local o = {}

	---------------------
	-- Create
	---------------------

	-- object
	o.name = data.name or "..."
	o.oType = "Life"
	o.dataType = "Component"

	-- vars
	o.life = data.life or 100
	o.maxLife = data.maxLife or o.life
	o.drain = data.drain or nil

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
	-- called on Update
	function o:Drain()

		if(self.drain) then
			self.life = self.life - 1
		end 

	end 

	-- check the life, if depleted, destroy
	function o:CheckDead()
		
		if(self.life <= 0) then
			--ObjectUpdater:Destroy(self)
			ObjectUpdater:Destroy(self.parent)
		end 

	end 

	-- this will cause the parent
	-- to be destroyed next frame
	function o:Kill()
		self.life = 0
	end 

	-- increase life
	function o:Add(v)
		self.life = self.life + v
	end

	-- decrease life
	function o:Sub(v)
		self.life = self.life - v
	end 

	-- return life to original max
	function o:Reset()
		self.life = self.maxLife
	end


	ObjectUpdater:Add{o}

	return o

end


ObjectUpdater:AddStatic(Life)

return Life

