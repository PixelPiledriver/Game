-- Input.lua

-- Purpose
---------------------------------------------
-- input component for objects
-- add keys and functions to be run when they are pressed
-- keyboard input only --> need to add controller in future

-----------------
-- Requires
-----------------
local KeySequence = require("KeySequence")

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
		o.sequenceKeys = {}

		o.sequenceIndex = o.sequenceKeys

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
					
					self[inputType][data[i][1]] =
					{
						key = data[i][1],
						func = data[i][3],
						parent = data[i][4] or nil,
						state = false,
						description = data[i][5] or "?",
						active = data[i][6] or true
					}

					self[inputType]["index"][#self[inputType]["index"]+1] = data[i][1]
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

		function o:AddSequences(list)
			for i=1, #list do
				self:AddSequence(list[i])
			end 
		end 

		function o:AddSequence(data)
			self.sequenceKeys[#self.sequenceKeys+1] = KeySequence:New(data)
		end 

		function o:SequenceInputUpdate(key)

			local resetAll = false

			-- check to see if any sequence has given key next
			for i=1, #self.sequenceKeys do
				local complete = self.sequenceKeys[i]:TestKey(key)

				-- sequence done?
				if(complete) then
					resetAll = true
				end
				
			end

			-- reset all indexes?
			if(resetAll) then
				for i=1, #self.sequenceKeys do
					self.sequenceKeys[i]:ResetIndex()
				end 

				return true
			end

			-- priority over non sequences
		end 

		o.convert = {}
		o.convert.active = true
		o.convert.mode = nil

		function o:ConvertToggle()
			Bool:Toggle(o.convert.active)
		end 

		function o:AddConvertKey(data)
			if(self.convert[data.mode] == nil) then
				self.convert[data.mode] = {}
			end 

			self.convert[data.mode][data.key] = data.keyConvertsTo
		end 


		function o:ConvertKey(key)
			if(self.convert.active == false) then
				return key
			end 

			if(self.convert[self.convert.mode] and self.convert[self.convert.mode][key]) then
				return self.convert[self.convert.mode][key]
			end 

			return key
		end
		

		-- passed in from ObjectManager -> parent -> this object on input callbacks
		-- this is used for press and release only
		-- hold needs to be done with a seperate function
		function o:InputUpdate(key, inputType)

			-- is input on?
			if(self.active == false) then
				return
			end 

			-- convert keys mode
			key = self:ConvertKey(key)

			-- run this key as part of sequence
			if(inputType == "press") then
				local complete = self:SequenceInputUpdate(key)

				-- cancel all basic input if a sequence is completed
				if(complete) then
					print("shit")
					return
				end 

			end

			-- make table name
			local inputType = inputType .. "Keys"

			
			-- does key exist?
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

					-- number of times this key has been pressed
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
			ObjectManager:Destroy(self.Info)
		end 

		----------
		-- End
		----------

		return o

	end 

	-----------------
	-- Static End
	-----------------

ObjectManager:AddStatic(Input)

return Input



-- Notes
--------------------
-- gotta take a huge shit
-- add "sequence" input type, for double taps, and fighting game moves
-- also should add "multi" for buttons at the same time


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



-- Junk
----------------------------------
--[==[

		-- { list = {key1, key2, ...}, func = function() 
		function o:AddSequence2(data)

			-- add to index list
			self.sequenceKeys.index[#self.sequenceKeys.index + 1] = data.list[1]

			-- use to save place in tables to move deeper
			local slot = self.sequenceKeys

			-- add buttons to sequence as table branches
			for i=1, #data.list do
				if(slot[data.list[i]] == nil) then
					slot[data.list[i]] = {}
				end

				slot = slot[data.list[i]]

				-- last button in sequence
				if(i == #data.list) then
					slot.complete = true
					slot.func = data.func
				end 
			end 

		end 



		-- simple version, needs changes to be functional in the future
		function o:SequenceInputUpdate2(key)
		
			--print(self.sequenceKeys[key])
			-- key in sequence?
			if(self.sequenceIndex[key]) then
				print("step + in sequence: " .. key)

				-- go to next
				self.sequenceIndex = self.sequenceIndex[key]


				-- last key in squence?
				if(self.sequenceIndex.complete == true) then
					
					print("sequence completed!")
					self.sequenceIndex:func()

					-- return to start
					self.sequenceIndex = self.sequenceKeys
				end 

			end


		end 


--]==]