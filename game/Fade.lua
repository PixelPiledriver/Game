-- Fade.lua
-- component
-- use to fade out basic os and control their alpha
-- might merge this with a SuperColor class in the future


local Fade = {}

-----------------
-- Static Vars
-----------------

Fade.name = "Fade"
Fade.oType = "Static"
Fade.dataType = "Component Constructor"

Fade.activeDefault = false


function Fade:New(data)

	local o = {}

	----------------
	-- Create 
	----------------

	-- o
	o.name = data.name or "..."
	o.oType = "Fade"
	o.dataType = "Component"

	-- vars
	o.fade = data.fade or 255
	o.speed = data.speed or 1

	-- other
	o.parent = data.parent or nil
	o.doneFading = false
	o.fadeWithLife = data.fadeWithLife or false

	-- make this component active or not
	-- if parent does not contain a color, this component serves no purpose
	local activeOnCreation = nil

	if(data.active == nil) then
		activeOnCreation = Fade.activeDefault
	else
		activeOnCreation = data.active
	end


	o.active = false
	if(data.parent.color and activeOnCreation) then
		o.active = true
	end 

	----------------
	-- Functions
	----------------

	function o:Update(data)
		self:Fade()
	end

	function o:Fade()

		if(self.active == false) then
			return
		end

		-- parent has color? <-- it needs one! :)
		if(self.parent.color == nil) then
			return
		end
		
		-- fade linked to life?
		if(self.fadeWithLife) then

			--o has life component?
			if(self.parent.Life) then
				self.fade = Math:InverseLerp
				{
					a = 0, 
					b = self.parent.Life.maxLife,
					t = self.parent.Life.life
				}

				self.fade = self.fade * 255
			end 

		-- normal fade
		else
			self.fade = self.fade - self.speed
		end 

		-- min limit
		if(self.fade < 0) then
			self.fade = 0
		end 

		-- done!
		self.parent.color.a = self.fade

	end 


	ObjectUpdater:Add{o}

	return o
end

ObjectUpdater:AddStatic(Fade)

return Fade
