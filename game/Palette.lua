-- Palette.lua

-- Purpose
----------------------
-- color palette
-- store and do cool stuff with colors
-- I think all of these will be converted colors.... no names...
-- that probly makes the most sense I guess

------------------
-- Requires
------------------
local Pos = require("Pos")
local Color = require("Color")
local Random = require("Random")
local Value = require("Value")
local Collision = require("Collision")
local MouseHover = require("MouseHover")
local MouseDrag = require("MouseDrag")
local Draw = require("Draw")

----------------------------------------------------------------

local Palette = {}

----------------
-- Static Info
----------------
Palette.Info = Info:New
{
	objectType = "Palette",
	dataType = "Graphics",
	structureType = "Static"
}

---------------------------
-- Static Functions
---------------------------

-- create a new random palette
-- {size}
function Palette:NewRandom(data)

	local p = Palette:New{}
	p:Random{size = data.size}

	return p

end 

--{colors, name, draw, size}
function Palette:New(data)

	local o = {}

	----------------
	-- Object Info
	----------------
	o.Info = Info:New
	{
		objectType = "Palette",
		dataType = "Graphics",
		structureType = "Object"
	}

	---------------
	-- Create
	---------------

	-- object
	o.name = data.name or "..."
	o.objectType = "Palette"
	o.dataType = "Graphics"

	-- vars
	o.colors = data.colors or {}
	o.size = data.size or 0 -- size = max, not just length of color table
	o.draw = data.draw or false -- show the palette on screen or not

	--if(data.asObject) then

	o.width = 32
	o.height = 32

	---------------------
	-- Color Stats
	---------------------
	-- stores the index of the given property
	-- make a funciton that calculates just one or all of these
	-- these should actually be tables.....
	-- and then just sort them by --> ? no idea comment wasnt finished
	o.colorStatsCalculated = false
	o.darkest = {}
	o.lightest = {}
	o.mostRed = {}
	o.mostGreen = {}
	o.mostBlue = {}

	-----------------
	-- Components
	-----------------
	o.componentsIndex = {}

	if(data.Pos) then
		Pos:AddComponent(o, data.Pos)
	else
		local defaultPos = {x = 0, y = 0}
		Pos:AddComponent(o, defaultPos)
	end

	---[[
	o.collision = Collision:New
	{
		x = o.Pos.x,
		y = o.Pos.y,
		width = o.width,
		height = o.height,
		shape = "rect",
		name = o.name,
		collisionList = {"Mouse"},
	}
	o.collision.Pos:LinkPosTo{link = o.Pos}

	o.Draw = Draw:New
	{
		parent = o,
		layer = "Hud"
	}

	-------------------------
	-- Mouse Interaction
	-------------------------
	o.hover = MouseHover:New{parent = o}
	o.drag = MouseDrag:New{parent = o}

	----------------------
	-- Sorting Functions
	-----------------------

	function o:SortByVar(name)
		TableSort:SortByVar
		{
			t = self.colors,
			var = name
		}
	end 

	function o:SortByFunc(name)

		TableSort:SortByFunc
		{
			t = self.colors,
			func = name
		}

	end 

	-------------------------
	-- Get Functions
	-------------------------

	-- return a color based on a condition

	-- by index
	function o:Get(index)
		return self.colors[index]
	end 

	-- random
	function o:GetRandom()
		return Random:ChooseRandomlyFrom(self.colors)
	end 

	-- darkest
	function o:GetDarkest()
		if(self.colorStatsCalculated == false) then
			self:CalculateColorStats()
		end 

		return self.darkest
	end

	function o:GetLightest()
		if(self.colorStatsCalculated == false) then
			self:CalculateColorStats()
		end 

		return self.lightest		
	end 

	function o:GetMostRed()
		if(self.colorStatsCalculated == false) then
			self:CalculateColorStats()
		end 

		return self.mostRed
	end 

	function o:GetMostGreen()
		if(self.colorStatsCalculated == false) then
			self:CalculateColorStats()
		end 

		return self.mostGreen
	end 

	function o:GetMostBlue()
		if(self.colorStatsCalculated == false) then
			self:CalculateColorStats()
		end 

		return self.mostBlue
	end 


	-- go thru all colors and store
	-- indexes for colors with certain properties
	function o:CalculateColorStats()
		
		-- convert all colors to luminance values in table
		local lums = {}
		for i=1, #self.colors do
			lums[#lums + 1] = Color:GetLuminance(self.colors[i])
		end 

		-- find the lightest of all colors
		self.lightest = {}
		local lightestIndex = 1
		for i=1, #lums do
			if(lums[i] > lums[lightestIndex]) then
				lightestIndex = i
			end 
		end 

		-- find the darkest of all colors
		local darkestIndex = 1
		for i=1, #lums do
			if(lums[i] < lums[darkestIndex]) then
				darkestIndex = i
			end 
		end 

		-- find most of each channel
		local mostRedIndex = 1
		local mostGreenIndex = 1
		local mostBlueIndex = 1

		
		for i=1, #self.colors do 
			-- red
			if(self.colors[i].r > self.colors[mostRedIndex].r) then
				mostRedIndex = i
			end 

			-- green
			if(self.colors[i].g > self.colors[mostGreenIndex].g) then
				mostGreenIndex = i
			end 

			-- blue
			if(self.colors[i].b > self.colors[mostBlueIndex].b) then
				mostBlueIndex = i
			end 

		end

		self.darkest = darkestIndex
		self.lightest = lightestIndex
		self.mostRed = mostRedIndex
		self.mostGreen = mostGreenIndex
		self.mostBlue = mostBlueIndex

	end 

	-----------------------------
	-- Create Functions -- create a palette and add colors to it

	-----------------------------

	-- stuff to run on any type of palette after its been created
	-- needs to be made optional --> will do later :P
	function o:AfterCreatePass(data)
		self:SortByFunc("Luminance")
	end 

	-- all random from named colors
	-- {size}
	function o:Random(data)
		self:Clear()

		for i=1, data.size do
			self.colors[i] = Color:Get("random")
		end

		self:AfterCreatePass()

	end


	-- create linear palette from colorA -> size ->colorB lerp
	-- {a, b, size}
	function o:Linear(data)
		self:Clear()

		self.colors[1] = Color:Get(data.a)
		self.colors[data.size] = Color:Get(data.b)

		for i=2, data.size-1 do
			self.colors[i] = Color:Lerp
			{
				a = self.colors[1],
				b = self.colors[data.size],
				t = 1/(data.size - 1) * (i-1)
			}
		end 

		self:AfterCreatePass()

	end

	-- pass in the colors you want to set the palette
	-- and then the indexes where each one will be placed
	-- this lets you easily choose the number of colors to interpolate between them
	-- {colors={"name",...}, indexs={#,...}}
	-- this mimics the ProMotion adjust palette feature
	function o:Interpolated(data)
		self:Clear()

		for i=1, #data.colors do
			self.colors[data.indexes[i]] = Color:Get(data.colors[i])
		end

		for i=1, #data.indexes-1 do

			local count = 1
			local k = data.indexes[i+1]

			for j= data.indexes[i]+1, k-1 do

				self.colors[j] = Color:Lerp
				{
					a = self.colors[data.indexes[i]],
					b = self.colors[data.indexes[i+1]],
					t = 1/(k - data.indexes[i]) * count
					--t = 0.5
					--t = 1/(data.indexes[i+1] - data.indexes[i]) * (k-(k-j)-1)
					--t = 1/3 - 1 * (k - j)
				}

				count = count + 1
			end 

		end 

		self:AfterCreatePass()

	end 

	-----------------
	-- Obejct Functions
	-----------------

	-- remove all colors
	function o:Clear()
		self.colors = nil
		self.colors = {}
	end 

	function o:Update()

		-- stuff	
	end 


	function o:DrawCall()
		
		if(self.draw == false) then
		
			return 
		end 

		for i=1, #self.colors do
			love.graphics.setColor(Color:AsTable(self.colors[i]))
			love.graphics.rectangle("fill", self.Pos.x, self.Pos.y + ( (i-1) * self.height), self.width, self.height)
		end 

	end 


	-- prints out rgba of all colors in palette
	-- not super useful but good for quick tests
	function o:PrintSelf()
		print("Palette")
		print("Colors:")
		print(#self.colors)
		for i=1, #self.colors do
			local r,g,b,a = self.colors[i].r, self.colors[i].g, self.colors[i].b,self.colors[i].a			
			print("{" .. r .. "," .. g .. "," .. b .. "," .. a .. "}")
		end

		print("Stats:")
		print("Lightest:" .. self.lightest)
		print("Darkest:" .. self.darkest)
		print("MostRed:" .. self.mostRed)
		print("MostGreen:" .. self.mostGreen)
		print("MostBlue:" .. self.mostBlue)

	end 



	function o:PrintDebugText()

		local life = self.Life and self.Life.life or 0

		local colorsList = {}
		colorsList[1] = {text = "", obj = "Palette"}

		for i=1, #o.colors do
			colorsList[#colorsList + 1] = {text = "Color[" .. i .. "]" .. o.colors[i].r .. ", " .. o.colors[i].g .. ", " .. o.colors[i].b}
		end 

		DebugText:TextTable
		{
			{text = "", obj = "Palette" },
			{text = "Palette"},
			{text = "---------------------"},
			{text = #o.colors}
		}

		DebugText:TextTable(colorsList)

	end 



	ObjectUpdater:Add{o}

	return o

end 





--ObjectUpdater:AddStat(Pallet)





return Palette





-- add in palette types
-------------------------------------------
-- linear, bilinear, etc
-- add palettes to object updater so they can change colors over time
-- Color type that change its color over time --> component that can be added to colors
-- funciton o:ReInterpolate colors between given indexes

-- o:Interpolated is not quite right
-- when using odd total spaces between colors, some colors are repeated