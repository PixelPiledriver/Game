-- Kirk 4-18-2015
-- Keyboard.lua

-- wrapper for love.keyboard

-- WTF BRO
-- this file does nothing at all
-- >:L

-- lets make this global just for fun

local ObjectUpdater = require("ObjectUpdater")
local Key = require("Key")

Keyboard = {}




local allKeys =
{
	-- letters
	"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m", " ",
	
	-- numbers
	"1","2","3","4","5","6","7","8","9","0",

	-- symbols
	"!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "+",

	-- other punctuation
	"[", "]", "{", "}", ":", ";","'",'"',",",".","<",">","/","?"

}

Keyboard.keys = {}

for i=1, #allKeys do
	Keyboard.keys[#Keyboard.keys + 1] = Key:New(allKeys[i])
end



Keyboard.keyPress = false

function Keyboard:Update()

	self:AllKeysTest()

end


-- All letter keys
function Keyboard:AllKeysTest()

	-- check all keys
	for i=1, #self.keys do

		-- reset key
		self.keys[i].pressed = false

		-- is key pressed?
		if(love.keyboard.isDown(self.keys[i].key)) then
			self.keys[i].pressed = true
		end 

	end 

end

function Keyboard:Key(k)
	return love.keyboard.isDown(k)
end

function Keyboard:RepeatedInput()
end


function Keyboard:PrintDebugText()	

	-- header
	local text = 
	{
		{text = "", obj = "Keyboard"},
		{text = "Keyboard"},
		{text = "-------------------------"},		
	}

	-- print state of all active keys
	for i=1, #self.keys do 
		text[#text+1] = {text = self.keys[i].key .. " = " .. Bool:ToString(self.keys[i].pressed)}
	end

	-- print text :)
	DebugText:TextTable(text)

end


ObjectUpdater:AddStatic(Keyboard) 


-- notes
----------------------
--[===[

Keyboard.keys = 
{
	a = false,
	s = false,
	d = false,
	f = false,
	index = {"a", "s", "d", "f"}
}


--{text = Bool:ToString(self.keyPress)},

	for i=1, #self.keys.index do 
		
		self.keys[self.keys.index[i]] = false

		if(love.keyboard.isDown(self.keys.index[i])) then
			self.keys[self.keys.index[i]] = true
		
		end 
	end




		{text = "New Keys"},

		
		{text = "Old Keys"},
		{text = "a = " .. Bool:ToString(self.keys["a"])},
		{text = "s = " .. Bool:ToString(self.keys["s"])},
		{text = "d = " .. Bool:ToString(self.keys["d"])},
		{text = "f = " .. Bool:ToString(self.keys["f"])},




--]===]

