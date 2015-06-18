-- Kirk 4-18-2015
-- Keyboard.lua

-- lets make this global just for fun


local Key = require("Key")

Keyboard = {}



----------------
-- Vars
----------------

Keyboard.anyKey = false

-- text results of holding shift and pressing a key
local alternateKeys =
{
	["q"] = "A",
	["w"] = "W",
	["e"] = "E",
	["r"] = "R",
	["t"] = "T",
	["y"] = "Y",
	["u"] = "U",
	["i"] = "I",
	["o"] = "O",
	["p"] = "P",
	["a"] = "A",
	["s"] = "S",
	["d"] = "D",
	["f"] = "F",
	["g"] = "G",
	["h"] = "H",
	["j"] = "J",
	["k"] = "K",
	["l"] = "L",
	["z"] = "Z",
	["x"] = "X",
	["c"] = "C",
	["v"] = "V",
	["b"] = "B",
	["n"] = "N",
	["m"] = "M",

  ["1"] = "!",
  ["2"] = "@",
  ["3"] = "#",
  ["4"] = "$",
  ["5"] = "%",
  ["6"] = "^",
  ["7"] = "&",
  ["8"] = "*",
  ["9"] = "(",
  ["0"] = ")",
	["-"] = "_",
	["="] = "+",
	["["] = "{",
	["]"] = "}",
	[";"] = ":",
	["'"] = '"',
	[","] = "<",
	["."] = ">",
	["/"] = "?",
	["\\"] = "|",
}

Keyboard.allKeys =
{
	-- buttons
	"escape", "tab", "lshift", "lctrl", "lalt",
	" ", -- spacebar
	"delete", "backspace", "return", "rshift", "rctrl", "ralt",
	"insert", "numlock", "capslock",
	"home", "end", "pageup", "pagedown",
	"pause", "printscreen", "help", 
	
	

	-- letters
	"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m",
	
	-- numbers
	"1","2","3","4","5","6","7","8","9","0",

	-- symbol keys 
	"-", "=", "[", "]", ";", "'", ",", ".", "/", "\\", "`",

	-- numpad
	"kp0", "kp1", "kp2", "kp3", "kp4", "kp5", "kp6", "kp7", "kp8", "kp9",
	"kp.", "kp,", "kp-", "kp+", "kp*", "kp/", "kp=", "kpenter",

	-- arrows
	"up", "down", "left", "right",

	-- f keys
	"f1", "f2", "f3", "f4", "f5", 
	"f6", "f7", "f8", "f9", "f10", 
	"f11", "f12", "f13", "f14", "f15",
	"f16", "f17", "f18",
}

Keyboard.keys = {}

for i=1, #Keyboard.allKeys do
	Keyboard.keys[#Keyboard.keys + 1] = Key:New(Keyboard.allKeys[i])
end

Keyboard.keysText = {}

for i=1, #Keyboard.allKeys do
	Keyboard.keysText[Keyboard.allKeys[i]] = Keyboard.allKeys[i]
end 

function Keyboard:Update()
	self:AllKeysTest()
end

-- runs thru all keys and tracks their current state
function Keyboard:AllKeysTest()

	self.anyKey = false

	-- check all keys
	for i=1, #self.keys do

		-- reset key
		self.keys[i].pressed = false
		
		-- is key pressed?
		if(love.keyboard.isDown(self.keys[i].key)) then
			self.keys[i].pressed = true
			self.anyKey = true
		end 

	end 

end

-- is a key pressed? --> only one input
-- this funciton is bullstuff
-- it doesnt work this way at all
function Keyboard:KeyPress(k)
	return love.keypressed(k)
end

-- is a key down? --> held down repeats input
function Keyboard:Key(k)
	return love.keyboard.isDown(k)
end

-- are multiple keys down?
function Keyboard:Keys(data)
		
	local allKeysPressed = true

	for i=1, #data do 
		if(love.keyboard.isDown(data[i]) == false) then
			allKeysPressed = false
		end 		
	end

	return allKeysPressed 

end

function Keyboard:AnyKey()
	return self.anyKey
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
		{text = "Any Key = " .. Bool:ToString(self.anyKey)}
	}

	-- print state of all active keys
	for i=1, #self.keys do
		local keyName = self.keys[i].key
		if(keyName == " ") then
			keyName = "spacebar"
		end 
		text[#text+1] = {text = keyName .. " = " .. Bool:ToString(self.keys[i].pressed)}
		--text[#text+1] = {text = self.keys[i].key .. " = " .. Bool:ToString(self.keys[i].pressed)}
	end

	-- print text :)
	DebugText:TextTable(text)

end


ObjectUpdater:AddStatic(Keyboard)



return Keyboard



-- notes
----------------------

-- NEEDED
	-- alternate key recognition
	-- to recognize alternate keys I need to program in holding shift manually
	-- should be fairly easy using a table with each key as the location
	-- and the alternate key as the data
	-- { "key" = "alternateKey"}

-- NEEDED
	-- single key press
	-- can do this thru the call back love.keypressed
	-- or can write my own single key presss
	-- lets do the call back first

-- NEEDED
	-- key sequence
	-- key input log


--[[
-- Examples
-------------------------

local keys = Keyboard:Keys{"lshift", "t"}




--]]



-- old code stuff
--[===[

-- symbols
--"-", "=", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+",

-- other punctuation
--"[", "]", "{", "}", ":", ";","'",'"',",",".","<",">","/","?"


-- wrapper for love.keyboard
-- WTF BRO
-- this file does nothing at all
-- >:L


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

