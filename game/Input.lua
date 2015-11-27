-- Input.lua

-- Purpose
---------------------------------------------
-- input component for objects
-- add keys and functions to be run when they are pressed



----------------------------------------------------------------------------

local Input = {}

-----------------
-- Static Info
-----------------
Input.Info = Info:New
{
	objectType = "Input",
	dataType = "Input",
	structureType = "Static"
}


----------------------
-- Static Functions
----------------------

	function Input:New(data)

		local o = {}

		-----------------
		-- Object Info
		-----------------
		o.Info = Info:New
		{
			name = "..." or data.name,
			objectType = "Input",
			dataType = "Input",
			structureType = "Component"
		}

		----------
		-- Vars
		----------

		-- lists of keys
		o.pressKeys = {index = {}}
		o.releaseKeys = {index = {}}
		o.holdKeys = {index = {}}

		-- other
		o.parent = data.parent or nil
		o.active = data.active or true
		o.count = 0


		---------------
		-- Functions
		---------------

		-- short hand, add multiple keys
		-- have new call this if data.keys is passed in
		-- {key, inputType, function, parent, description, active}
		function o:AddKeys(data)
		-- add keys to input as its created in a shortcut format
			if(data and #data > 0) then
				for i=1, #data do
					local inputType = data[i][2] .. "Keys"
					
					o[inputType][data[i][1]] =
					{
						key = data[i][1],
						func = data[i][3],
						parent = data[i][4] or nil,
						state = false,
						description = data[i][5] or "?",
						active = data[i][6] or true
					}

					o[inputType]["index"][#o[inputType]["index"]+1] = data[i][1]
				end 
			end 
		end 

		-- long hand, add a single key
		function o:AddKey(data)

			local inputType = data.type .. "Keys"

			self[inputType][data.key] = 
			{
				key = data.key,
				func = data.func,
				parent = data.parent or nil,
				state = false,
				description = data.description or "?",
				active = data.active or true
			}

			self[inputType]["index"][#self[inputType]["index"]+1] = data.key



		end

		

		-- passed in from ObjectUpdater -> parent -> this object on input callbacks
		-- this is used for press and release only
		-- hold needs to be done with a seperate function
		function o:InputUpdate(key, inputType)

			if(self.active == false) then
				return
			end 

			local inputType = inputType .. "Keys"


			if(self[inputType][key]) then

				repeat

					-- key is active? --> can be used?
					if(self[inputType][key].active == false)then
						break
					end

					-- key has parent? --> overrides component
					if(self[inputType][key].parent) then
						self[inputType][key].func(self[inputType][key].parent)

					-- component has parent?
					elseif(self.parent) then
						self[inputType][key].func(self.parent)

					-- no parent
					else 
						self[inputType][key].func()
					end 

					self.count = self.count + 1

					until true
				
			end

		end


		-- update all holdKeys
		function o:RepeatedInputUpdate()

			if(self.active == false) then
				return
			end 

			for i=1, #self.holdKeys.index do
				local keyIndex = self.holdKeys.index[i]

				repeat

					if(self.holdKeys[keyIndex].active == false) then
						break
					end 


					if(love.keyboard.isDown(self.holdKeys[keyIndex].key)) then

						-- key has parent?
						if(self.holdKeys[keyIndex].parent) then
							self.holdKeys[keyIndex].func(self.holdKeys[keyIndex].parent)

						-- component has parent?
						elseif(self.parent) then
							self.holdKeys[keyIndex].func(self.parent)

						-- no parent
						else
							self.holdKeys[keyIndex].func()
						end 
					end 

				until true

			end 

		end 

		-------------
		-- On New
		-------------
		if(data and data.keys) then
			o:AddKeys(data.keys)
		end 


		function o:Destroy()
			ObjectUpdater:Destroy(self.Info)
		end 

		----------
		-- End
		----------

		return o

	end 

	-----------------
	-- Static End
	-----------------

ObjectUpdater:AddStatic(Input)

return Input



-- Notes
--------------------
-- should this component handle mouse and controller input as well?
-- for now it only handles keyboard input


-- Creating an Input Component
--------------------------------------

-- long hand
--[[
App.Input = Input:New()
App.Input:AddKey
{
	key = "escape",
	type = "press",
	func = App.QuitGameInput,
}
--]]

-- short hand
--[[
App.Input = Input:New
{
	{"escape", "press", App.QuitGameInput}, -- key 1
	{key, inputType, function}, -- key 2
	{..., ..., ...} -- key 3
}
--]]




-- Old Notes
----------------------
-- this is one of the first componenents to not need an object updater
-- since it relies on a callpack
-- the comps parent will pass in the data for updating

-- has to be added to the end of an objects file