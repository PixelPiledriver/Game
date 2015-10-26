-- MapTable.lua

-- 2 dimensional table to add and get things from
--------------------------------------------------------------------------------


local MapTable = {}

------------------
-- Static Info
------------------
MapTable.name = "MapTable"
MapTable.objectType = "Static"
MapTable.dataType = "Data Storage Constructor"


function MapTable:New(data)
	
	local o = {}

	------------------
	-- Object Info
	------------------
	o.name = "..."
	o.objectType = "MapTable"
	o.dataType = "Data Storage"


	------------
	-- Vars
	------------

	o.width = data.width or 1
	o.height = data.height or 1

	o.map = {}

	o.growMap = data.growMap or true

	o.emptySlotDefault = data.emptySlotDefault or nil
	print(o.emptySlotDefault)


	-- puts the _nil keyword into slots of the map
	-- does not clean up objects, may need that in the future
	function o:BlankMap()

		for i=1, self.width do
			self.map[i] = {}
			for j=1, self.height do
				self.map[i][j] = "_nil"
			end 
		end 
				
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
						-- cant get name for some reason
						printDebug{"slot taken by " .. "Unknown" , "MapTable"} 
						
					-- empty slot, fill with nil keyword
					else
						printDebug{"empty slot:", "MapTable"}
						printDebug{"x:" .. x ..  ", y:" .. y .. " = " .. "NIL", "MapTable"}
						self.map[x][y] = self.emptySlotDefault or "_nil"
					end 

				end
					
			end 
		end 



	end 


	-- set the size of the map
	-- only works with a blank map for now
	-- need to add better support for already built maps later
	function o:SetSize(data)
		self:Add
		{
			object = "_nil",
			x = data.width,
			y = data.height
		}
	end 

	-- place object into slot in map
	function o:Add(data)

		printDebug{"Added " .. (data.object.name or "NoName") .. " to map", "MapTable"}

		-- grow X?
		if(data.x > self.width) then
			printDebug{"grow map X", "MapTable"}
			local oldWidth = self.width
			self.width = self.width + (data.x - self.width)
		
			for i=oldWidth + 1, data.x do
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
			--print("create X")
			self.map[data.x] = {}
		end

		-- slot is empty so put object inside?
		--if(self.map[data.x][data.y] == "_nil") then 
			--print("yes")
			self.map[data.x][data.y] = data.object
			--print(self.map[data.x][data.y])
		--end

	end 

	-- get object from slot in the map
	function o:Get(data)

		if(self.map[data.x] and self.map[data.x][data.y]) then
			return self.map[data.x][data.y]
		end 

		return nil
	end 

	-- swap the map position of a and b
	function o:Swap(data)

		-- not sure if this actually works
		-- probly doesn't

		if(self:IsPosInBounds{x = data.b.x, y = data.b.x} == false) then
			print("out of bounds")
			return
		end 

		local a = self.map[data.a.x][data.a.y]
		local b = self.map[data.b.x][data.b.y]

		self.map[data.a.x][data.a.y] = b
		self.map[data.b.x][data.b.y] = a

	end


	-- test an x,y pos to see if it is inside
	-- the width and height of the map
	function o:IsPosInBounds(data)

		if(data.x > self.width) then
			return false
		end

		if(data.x < 1) then
			return false
		end 

		if(data.y > self.height) then
			return false
		end

		if(data.y < 1) then
			return false
		end 

		return true

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



-- 
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
