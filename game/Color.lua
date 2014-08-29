-- use to get colors by name
-- and other stuff

local Random = require("Random")

local Color = {}



Color.red = {255,0,0,255}
Color.darkRed = {100,0,0,255}
Color.blue = {0,0,255,255}
Color.darkBlue = {0,0,100,255}
Color.green = {0,255,0,255}
Color.white = {255,255,255,255}
Color.black = {0,0,0,255}
Color.purple = {128, 0, 255, 255}
Color.orange = {255, 165, 0, 255}


--[[
Color.maroon =(128,0,0, 255}
Color.darkRed	=	(139,0,0, 255}
Color.brown	=	(165,42,42, 255}
Color.firebrick	=	(178,34,34, 255}
Color.crimson	=	(220,20,60, 255}
Color.red	= (255,0,0, 255}
Color.tomato	(255,99,71, 255}
Color.coral =	(255,127,80, 255}
Color.indianRed	=	(205,92,92, 255}
Color.lightCoral	=	(240,128,128, 255}
Color.darkSalmon	=	(233,150,122, 255}
Color.salmon	=	(250,128,114, 255}
Color.lightSalmon	=	(255,160,122, 255}
Color.orangeRed =	(255,69,0, 255}
Color.darkOrange = (255,140,0, 255}
Color.orange	=	(255,165,0, 255}
Color.gold	=	(255,215,0, 255}
Color.darkGoldenRod	=	(184,134,11, 255}
Color.goldenRod	=	(218,165,32, 255}
Color.paleGoldenRod	=	(238,232,170, 255}
Color.darkKhaki	=	(189,183,107, 255}
Color.khaki	=	(240,230,140, 255}
Color.olive	=	(128,128,0, 255}
Color.yellow	=	(255,255,0, 255}
Color.yellowGreen	=	(154,205,50, 255}
Color.darkOliveGreen =	(85,107,47, 255}
Color.oliveDrab	=	(107,142,35, 255}
Color.lawnGreen	=	(124,252,0, 255}
Color.chartReuse	=	(127,255,0, 255}
Color.greenYellow	=	(173,255,47, 255}
Color.darkGreen	=	(0,100,0, 255}
Color.green	=	(0,128,0, 255}
Color.forestGreen	=	(34,139,34, 255}
Color.lime	=	(0,255,0, 255}
Color.limeGreen	=	(50,205,50, 255}
Color.lightGreen	=	(144,238,144, 255}
Color.paleGreen	= (152,251,152, 255}
Color.darkSeaGreen	=	(143,188,143, 255}
Color.mediumSpringGreen	=	(0,250,154, 255}
Color.springGreen	=	(0,255,127, 255}
Color.seaGreen	=	(46,139,87, 255}
Color.mediumAquaMarine	=	(102,205,170, 255}
Color.mediumSeaGreen	=	(60,179,113, 255}
Color.lightSeaGreen	=	(32,178,170, 255}
Color.darkSlateGray	=	(47,79,79, 255}
Color.teal	=	(0,128,128, 255}
Color.darkCyan	=	(0,139,139, 255}
Color.aqua	=	(0,255,255, 255}
Color.cyan	=	(0,255,255, 255}
Color.lightCyan	=	(224,255,255, 255}
Color.darkTurquoise	=	(0,206,209, 255}
Color.turquoise	=	(64,224,208, 255}
Color.mediumTurquoise	=	(72,209,204, 255}
Color.paleTurquoise	=	(175,238,238, 255}
Color.aquaMarine	=	(127,255,212, 255}
Color.powderBlue	=	(176,224,230, 255}
Color.cadetBlue	=	(95,158,160, 255}
Color.steelBlue	=	(70,130,180, 255}
Color.cornFlowerBlue	=	(100,149,237, 255}
Color.deepSkyBlue	=	(0,191,255, 255}
Color.dodgerBlue	=	(30,144,255, 255}
Color.lightBlue  =	(173,216,230, 255}
Color.sky blue	#87CEEB	(135,206,235, 255}
Color.light sky blue	#87CEFA	(135,206,250, 255}
Color.midnight blue	#191970	(25,25,112, 255}
Color.navy	#000080	(0,0,128, 255}
Color.dark blue	#00008B	(0,0,139, 255}
Color.medium blue	#0000CD	(0,0,205, 255}
Color.blue	#0000FF	(0,0,255, 255}
Color.royal blue	#4169E1	(65,105,225, 255}
Color.blue violet	#8A2BE2	(138,43,226, 255}
Color.indigo	#4B0082	(75,0,130, 255}
Color.dark slate blue	#483D8B	(72,61,139, 255}
Color.slate blue	#6A5ACD	(106,90,205, 255}
Color.medium slate blue	#7B68EE	(123,104,238, 255}
Color.medium purple	#9370DB	(147,112,219, 255}
Color.dark magenta	#8B008B	(139,0,139, 255}
Color.dark violet	#9400D3	(148,0,211, 255}
Color.dark orchid	#9932CC	(153,50,204, 255}
Color.medium orchid	#BA55D3	(186,85,211, 255}
Color.purple	#800080	(128,0,128, 255}
Color.thistle	#D8BFD8	(216,191,216, 255}
Color.plum	#DDA0DD	(221,160,221, 255}
Color.violet	#EE82EE	(238,130,238, 255}
Color.magenta	=	(255,0,255, 255}
Color.orchid	=	(218,112,214, 255}
Color.mediumVioletRed	=	(199,21,133, 255}
Color.paleVioletRed	=	(219,112,147, 255}
Color.deepPink	=	(255,20,147, 255}
Color.hotPink	=	(255,105,180, 255}
Color.lightPink	=	(255,182,193, 255}
Color.pink	=	(255,192,203, 255}
Color.antiqueWhite	=	(250,235,215, 255}
Color.beige	=	(245,245,220, 255}
Color.bisque	=	(255,228,196, 255}
Color.blanchedAlmond	#FFEBCD	(255,235,205, 255}
Color.wheat	=	(245,222,179, 255}
Color.cornSilk	=	(255,248,220, 255}
Color.lemon chiffon	=	(255,250,205, 255}
Color.lightGoldenRodYellow	=	(250,250,210, 255}
Color.lightYellow	=	(255,255,224, 255}
Color.saddleBrown	=	(139,69,19, 255}
Color.sienna	=	(160,82,45, 255}
Color.chocolate	=	(210,105,30, 255}
Color.peru = (205,133,63, 255}
Color.sandyBrown	=	(244,164,96, 255}
Color.burlyWood	=	(222,184,135, 255}
Color.tan	=	(210,180,140, 255}
Color.rosyBrown	=	(188,143,143, 255}
Color.moccasin	=	(255,228,181, 255}
Color.navajoWhite	=	(255,222,173, 255}
Color.peachPuff	=	(255,218,185, 255}
Color.mistyRose	=	(255,228,225, 255}
Color.lavenderBlush	=	(255,240,245, 255}
Color.linen	=	(250,240,230, 255}
Color.oldLace	=	(253,245,230, 255}
Color.papayaWhip =	(255,239,213, 255}
Color.seaShell	=	(255,245,238, 255}
Color.mintCream	=	(245,255,250, 255}
Color.slateGray	=	(112,128,144, 255}
Color.lightSlateGray	=	(119,136,153, 255}
Color.lightSteelBlue	=	(176,196,222, 255}
Color.lavender	=	(230,230,250, 255}
Color.floral white	=	(255,250,240, 255}
Color.alice blue	=	(240,248,255, 255}
Color.ghost white	=	(248,248,255, 255}
Color.honeydew	=	(240,255,240, 255}
Color.ivory	=	(255,255,240, 255}
Color.azure	=	(240,255,255, 255}
Color.snow	=	(255,250,250, 255}
Color.black	=	(0,0,0, 255}
Color.dimGray	=	(105,105,105, 255}
Color.gray	=	(128,128,128, 255}
Color.darkGray	=	(169,169,169, 255}
Color.silver	=	(192,192,192, 255}
Color.lightGray =	(211,211,211, 255}
Color.gainsboro	=	(220,220,220, 255}
Color.whiteSmoke	=	(245,245,245, 255}
Color.white	=	(255,255,255, 255}
--]]







Color.index = {"red", "darkRed", "blue", "darkBlue", 
							 "green", "white", "black", "purple", "orange"}


function Color:Get(name)

	if(name == "random") then
		name = Random:ChooseRandomlyFrom(Color.index)
	end 

	local copy =
	{
		Color[name][1],
		Color[name][2],
		Color[name][3],
		Color[name][4]
	}
	
	return copy
end

-- compare two colors for equality
function Color:Equal(a,b)
	
	if(a[1] ~= b[1]) then
		return false
	end 

	if(a[2] ~= b[2]) then
		return false
	end 

	if(a[3] ~= b[3]) then
		return false
	end 

	return true
end 

-- add two colors together
-- {a, b}
function Color:Add(data)
	local newColor = {}

	newColor[1] = data.a[1] + data.b[1]
	newColor[2] = data.a[2] + data.b[2]
	newColor[3] = data.a[3] + data.b[3]

	if(data.loop == false) then

		if(newColor[1] > 255) then
			newColor[1] = 255
		end 

		if(newColor[2] > 255) then
			newColor[2] = 255
		end 

		if(newColor[3] > 255) then
			newColor[3] = 255
		end 

	end 

	return newColor
end 

-- subtracct color b from color a
-- {a, b, loop}
function Color:Sub(data)
	local newColor = {}

	newColor[1] = data.a[1] - data.b[1]
	newColor[2] = data.a[2] - data.b[2]
	newColor[3] = data.a[3] - data.b[3]

	if(data.loop == false) then
		
		if(newColor[1] < 0) then
			newColor[1] = 0
		end 

		if(newColor[2] < 0) then
			newColor[2] = 0
		end 

		if(newColor[3] < 0) then
			newColor[3] = 0
		end 


	end 

	return newColor
end 


--{color, min, max}
function Color:Clamp(data)

	-- min 	
	if(data.color[1] < data.min) then
		data.color[1] = data.min
	end 

	if(data.color[2] < data.min) then
		data.color[2] = data.min
	end 

	if(data.color[3] < data.min) then
		data.color[3] = data.min
	end 

	-- max
	if(data.color[1] > data.max) then
		data.color[1] = data.max
	end 

	if(data.color[2] > data.max) then
		data.color[2] = data.max
	end 

	if(data.color[3] > data.max) then
		data.color[3] = data.max
	end 


end 

--{a, b, p}
function Color:Lerp(data)

	local newColor = {}

	newColor[1] =  data.a[1] + ((data.b[1] - data.a[1]) * data.t)
	newColor[2] =  data.a[2] + ((data.b[2] - data.a[2]) * data.t)
	newColor[3] =  data.a[3] + ((data.b[3] - data.a[3]) * data.t)

	-- alpha
	if(data.alpha ) then
		newColor[4] =  data.a[4] + ((data.b[4] - data.a[4]) * data.t)
	else
		newColor[4] =  data.a[4]
	end 

	return newColor

end 











-- done
return Color
