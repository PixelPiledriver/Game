--InputText.lua


local ObjectUpdater = require("ObjectUpdater")
local Keyboard = require("Keyboard")
local Input = require("Input")


local InputText = {}


function InputText:New(data)

	local o = {}

	--------------
	-- Create
	--------------
	o.text = ""

	o.setLength = data.setLength or true
	o.maxLength = data.maxLength or 100
	o.minLength = data.minLength or 0
	
	------------------
	-- Functions
	-------------------
	function o:Update()
		
	end

	function o:Backspace()
		self.text = self.text:sub(1,-2)
	end 

	-- adds a single character to the string
	-- used by Input, but can also be set directly
	function o:AddToText(key)

		-- string uses max size and is less than max?
		if(self.setLength and self.text:len() < self.maxLength) then
			self.text = self.text .. key
		end 
		
	end

	-- pass string to add to this text
	-- directly sends a string from code, not used by input
	function o:AddStringToText(text)
		if(self.setLength and self.text:len() < self.maxLength) then
			self.text = self.text .. text
		end
	end 

	function o:PrintDebugText()
		DebugText:TextTable
		{
			{text = "", obj = "InputText"},
			{text = "InputText"},
			{text = "-------------------------"},
			{text = self.text}
		}
	end 

	----------------
	-- Input
	----------------
	o.Input = Input:New{}
	o.keys = data.keys or {}

	if(#o.keys > 0) then
		local keysToAdd = {}

		for i=1, #o.keys do
			keysToAdd[#keysToAdd + 1] = {o.keys[i], "press", function() o:AddToText(o.keys[i]) end}
		end

		o.Input:AddKeys(keysToAdd)

	end

	-- editing keys
	o.Input:AddKeys
	{
		{"backspace", "press", function() o:Backspace() end},
		{" ", "press", function() o:AddStringToText(" ") end}
	}



	ObjectUpdater:Add{o}


	return o

end 





ObjectUpdater:AddStatic(InputText)

return InputText




-- Notes
---------------------------------
-- type stuff into a string
-- a string that responds to the keyboard
-- thats all this does
-- then use these objects to build editor panels and a console and stuff


-- DONE
-- backspace 

-- TO DO
-- space

-- TO DO
-- presets for input string types
-- letters type
-- numbers type
-- mixed type

-- TO DO
-- max length

-- DONE
-- single key press typing

-- DONE
-- implement Input component
-- each input string only responds to specific keys
-- so easy to make number or letter input only strings


-- Old Code
---------------------

-- every key input type
-- only works with hold tho so not good for typing at all
--[==[

	function o:TypeText()
		
		-- this doesnt work for typing because its for holding down key
		for i=1, #Keyboard.allKeys do
			if(Keyboard:Key(Keyboard.allKeys[i])) then
				self.text = self.text .. Keyboard.keysText[Keyboard.allKeys[i]]
			end 
		end
		
	end 


--]==]