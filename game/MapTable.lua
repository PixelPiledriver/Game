-- MapTable.lua
-- 2 dimensional table to add and get things from
-- fuckin dope as shiiiiiiiit!!!!

local ObjectUpdater = require("ObjectUpdater")

local MapTable = {}


function MapTable:New(data)
	
	local o = {}

	o.width = data.width or 1
	o.height = data.height or 1

	o.map = {}

	o.growMap = data.growMap or true


	-- puts the _nil keyword into 
	function o:BlankMap()

		for i=1, self.width do
			self.map[i] = {}
			for j=1, self.height do
				self.map[i][j] = "_nil"
			end 
		end 
				
		print(self.map[1][1])
	end 

	o:BlankMap()


	-- runs thru the table and fills any empty slots with "_nil"
	function o:FillEmptySlots()
		printDebug{"width: " .. self.width, "MapTable"}
		printDebug{"height: " .. self.height, "MapTable"}

		for x=1, self.width do
			for y=1, self.height do
				-- does x exist?
				if(self.map[x] == nil) then
				self.map[x] = {}
				end 
				-- is slot already taken?
				if(self.map[x]) then

					-- full slot, do nothing
					if(self.map[x][y]) then
						printDebug{"slot taken by:", "MapTable"}
						printDebug{"x:" .. x ..  ", y:" .. y .. " = " .. self.map[x][y], "MapTable"}

					-- empty slot, fill with nil keyword
					else
						printDebug{"empty slot:", "MapTable"}
						printDebug{"x:" .. x ..  ", y:" .. y .. " = " .. "NIL", "MapTable"}
						self.map[x][y] = "_nil"
					end 

				end
					
			end 
		end 



	end 



	-- place object into slot in map
	function o:Add(data)

		print("add to map")

		-- grow X?
		if(data.x > self.width) then
			printDebug{"grow map X", "MapTable"}
			local oldWidth = self.width
			self.width = self.width + (data.x - self.width)
		
			for i=oldWidth+1, data.x do
				self.map[i] = {}
			end 

			self:FillEmptySlots()
		end

		-- grow Y?
		if(data.y > self.height) then
			printDebug{"grow map Y", "MapTable"}

			local oldHeight = self.height
			self.height = self.height + (data.y - self.height)
			
			for x=1, #self.map do		
				for i=oldHeight+1, self.height do
					self.map[x][i] = "_nil"
				end
			end
		end 

		-- x doesnt exist?
		if(self.map[data.x] == nil) then
			print("create X")
			self.map[data.x] = {}
		end

		-- slot is empty so put object inside?
		--if(self.map[data.x][data.y] == "_nil") then 
			print("yes")
			self.map[data.x][data.y] = data.object
			print(self.map[data.x][data.y])
		--end

	end 

	-- get object from slot in the map
	function o:Get(data)

		if(self.map[data.x] and self.map[data.x][data.y]) then
			return self.map[data.x][data.y]
		end 

		return nil
	end 

	o.printDebugTextActive = true

	function o:PrintDebugText()

		if(self.printDebugTextActive == false) then
			return
		end 

		local text = 
		{
			{text = "", obj = "MapTable"},
			{text = "MAPTABLE"},
			{text = "-----------------"}, 
		}

		-- creates a string of the table and its values
		-- done y,x to transpose the list printing order
		for y = 1, self.height do

			local mapAsString = ""

			for x = 1, self.width do
				if(self.map[x][y]) then
					--mapAsString = mapAsString .. "[" .. self.map[x][y] .. "]"
				else
					--mapAsString = mapAsString .. "[x]"
				end 
			end 

			text[#text+1] = {text = mapAsString}
		end

		DebugText:TextTable(text)

	end 

	ObjectUpdater:Add{o}

	return o

end 




return MapTable


-- Notes
--]]---------------------------
	
-- need to add functionality for growing the map
-- if objects are placed outside of its current size




--]]----------------------------




--[[
		for i=1, #self.map do
			local mapAsString = ""
			for j=1, #self.map[i] do
				--print("x:" .. i .. ", Y:" .. j)
				mapAsString = mapAsString .. "[" .. self.map[i][j] .. "]"
			end 

			text[#text+1] = {text = mapAsString}
		end 



	-- fill out rest of maps empty slots with _nil
	-- this may or may not be needed
	function o:RefillMap()
		-- find which x in the map has the most y
		-- create all ys that dont exist and fill them with _nil
		-- keeps the table fulll of objects and makes map always rectangular
		-- all length of the table can be read at any time from any position cuz its always the same --> nice
		local largestX = 0
		for i=1, #map do
			
		end 

	end 

--]]
