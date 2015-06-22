-- Color.lua


-- Purpose
----------------------------
-- colors by name and other color operations



------------------
-- Requires
------------------

local Random = require("Random")


--------------------------------------------------------------------------

local Color = {}

----------------------
-- Static Info
----------------------

Color.name = "Color"
Color.oType = "Static"
Color.dataType = "Graphics Constructor"

----------------------
-- Colors
----------------------

Color.maroon = 
{
	r = 128,
	g = 0,
	b = 0,
	a = 255,
	name = "maroon"
}

Color.darkRed = 
{
	r = 139,
	g = 0,
	b = 0,
	a = 255,
	name = "darkRed"
}

Color.brown = 
{
	r = 165,
	g = 42,
	b = 42,
	a = 255,
	name = "brown"
}

Color.firebrick = 
{
	r = 178,
	g = 34,
	b = 34,
	a = 255,
	name = "firebrick"
}

Color.crimson = 
{
	r = 220,
	g = 20,
	b = 60,
	a = 255,
	name = "crimson"
}

Color.red = 
{
	r = 255,
	g = 0,
	b = 0,
	a = 255,
	name = "red"
}

Color.tomato = 
{
	r = 255,
	g = 99,
	b = 71,
	a = 255,
	name = "tomato"
}

Color.coral = 
{
	r = 255,
	g = 127,
	b = 80,
	a = 255,
	name = "coral"
}

Color.indianRed = 
{
	r = 205,
	g = 92,
	b = 92,
	a = 255,
	name = "indianRed"
}

Color.lightCoral = 
{
	r = 240,
	g = 128,
	b = 128,
	a = 255,
	name = "lightCoral"
}

Color.darkSalmon = 
{
	r = 233,
	g = 150,
	b = 122,
	a = 255,
	name = "darkSalmon"
}

Color.salmon = 
{
	r = 250,
	g = 128,
	b = 114,
	a = 255,
	name = "salmon"
}

Color.lightSalmon = 
{
	r = 255,
	g = 160,
	b = 122,
	a = 255,
	name = "lightSalmon"
}

Color.orangeRed = 
{
	r = 255,
	g = 69,
	b = 0,
	a = 255,
	name = "orangeRed"
}

Color.darkOrange = 
{
	r = 255,
	g = 140,
	b = 0,
	a = 255,
	name = "darkOrange"
}

Color.orange = 
{
	r = 255,
	g = 165,
	b = 0,
	a = 255,
	name = "orange"
}

Color.gold = 
{
	r = 255,
	g = 215,
	b = 0,
	a = 255,
	name = "gold"
}

Color.darkGoldenRod = 
{
	r = 184,
	g = 134,
	b = 11,
	a = 255,
	name = "darkGoldenRod"
}

Color.goldenRod = 
{
	r = 218,
	g = 165,
	b = 32,
	a = 255,
	name = "goldenRod"
}

Color.paleGoldenRod = 
{
	r = 238,
	g = 232,
	b = 170,
	a = 255,
	name = "paleGoldenRod"
}

Color.darkKhaki = 
{
	r = 189,
	g = 183,
	b = 107,
	a = 255,
	name = "darkKhaki"
}

Color.khaki = 
{
	r = 240,
	g = 230,
	b = 140,
	a = 255,
	name = "khaki"
}

Color.olive = 
{
	r = 128,
	g = 128,
	b = 0,
	a = 255,
	name = "olive"
}

Color.yellow = 
{
	r = 255,
	g = 255,
	b = 0,
	a = 255,
	name = "yellow"
}

Color.yellowGreen = 
{
	r = 154,
	g = 205,
	b = 50,
	a = 255,
	name = "yellowGreen"
}

Color.darkOliveGreen = 
{
	r = 85,
	g = 107,
	b = 47,
	a = 255,
	name = "darkOliveGreen"
}

Color.oliveDrab = 
{
	r = 107,
	g = 142,
	b = 35,
	a = 255,
	name = "oliveDrab"
}

Color.lawnGreen = 
{
	r = 124,
	g = 252,
	b = 0,
	a = 255,
	name = "lawnGreen"
}

Color.chartReuse = 
{
	r = 127,
	g = 255,
	b = 0,
	a = 255,
	name = "chartReuse"
}

Color.greenYellow = 
{
	r = 173,
	g = 255,
	b = 47,
	a = 255,
	name = "greenYellow"
}

Color.darkGreen = 
{
	r = 0,
	g = 100,
	b = 0,
	a = 255,
	name = "darkGreen"
}

Color.green = 
{
	r = 0,
	g = 128,
	b = 0,
	a = 255,
	name = "green"
}

Color.forestGreen = 
{
	r = 34,
	g = 139,
	b = 34,
	a = 255,
	name = "forestGreen"
}

Color.lime = 
{
	r = 0,
	g = 255,
	b = 0,
	a = 255,
	name = "lime"
}

Color.limeGreen = 
{
	r = 50,
	g = 205,
	b = 50,
	a = 255,
	name = "limeGreen"
}

Color.lightGreen = 
{
	r = 144,
	g = 238,
	b = 144,
	a = 255,
	name = "lightGreen"
}

Color.paleGreen = 
{
	r = 152,
	g = 251,
	b = 152,
	a = 255,
	name = "paleGreen"
}

Color.darkSeaGreen = 
{
	r = 143,
	g = 188,
	b = 143,
	a = 255,
	name = "darkSeaGreen"
}

Color.mediumSpringGreen = 
{
	r = 0,
	g = 250,
	b = 154,
	a = 255,
	name = "mediumSpringGreen"
}

Color.springGreen = 
{
	r = 0,
	g = 255,
	b = 127,
	a = 255,
	name = "springGreen"
}

Color.seaGreen = 
{
	r = 46,
	g = 139,
	b = 87,
	a = 255,
	name = "seaGreen"
}

Color.mediumAquaMarine = 
{
	r = 102,
	g = 205,
	b = 170,
	a = 255,
	name = "mediumAquaMarine"
}

Color.mediumSeaGreen = 
{
	r = 60,
	g = 179,
	b = 113,
	a = 255,
	name = "mediumSeaGreen"
}

Color.lightSeaGreen = 
{
	r = 32,
	g = 178,
	b = 170,
	a = 255,
	name = "lightSeaGreen"
}

Color.darkSlateGray = 
{
	r = 47,
	g = 79,
	b = 79,
	a = 255,
	name = "darkSlateGray"
}

Color.teal = 
{
	r = 0,
	g = 128,
	b = 128,
	a = 255,
	name = "teal"
}

Color.darkCyan = 
{
	r = 0,
	g = 139,
	b = 139,
	a = 255,
	name = "darkCyan"
}

Color.aqua = 
{
	r = 0,
	g = 255,
	b = 255,
	a = 255,
	name = "aqua"
}

Color.cyan = 
{
	r = 0,
	g = 255,
	b = 255,
	a = 255,
	name = "cyan"
}

Color.lightCyan	= 
{
	r = 224,
	g = 255,
	b = 255,
	a = 255,
	name = "lightCyan"
}

Color.darkTurquoise = 
{
	r = 0,
	g = 206,
	b = 209,
	a = 255,
	name = "darkTurquoise"
}

Color.turquoise = 
{
	r = 64,
	g = 224,
	b = 208,
	a = 255,
	name = "turquoise"
}

Color.mediumTurquoise = 
{
	r = 72,
	g = 209,
	b = 204,
	a = 255,
	name = "mediumTurquoise"
}

Color.paleTurquoise = 
{
	r = 175,
	g = 238,
	b = 238,
	a = 255,
	name = "paleTurquoise"
}

Color.aquaMarine = 
{
	r = 127,
	g = 255,
	b = 212,
	a = 255,
	name = "aquaMarine"
}

Color.powderBlue = 
{
	r = 176,
	g = 224,
	b = 230,
	a = 255,
	name = "powderBlue"
}

Color.cadetBlue	= 
{
	r = 95,
	g = 158,
	b = 160,
	a = 255,
	name = "cadetBlue"
}

Color.steelBlue	= 
{
	r = 70,
	g = 130,
	b = 180,
	a = 255,
	name = "steelBlue"
}

Color.cornFlowerBlue = 
{
	r = 100,
	g = 149,
	b = 237,
	a = 255,
	name = "cornFlowerBlue"
}

Color.deepSkyBlue = 
{
	r = 0,
	g = 191,
	b = 255,
	a = 255,
	name = "deepSkyBlue"
}

Color.dodgerBlue = 
{
	r = 30,
	g = 144,
	b = 255,
	a = 255,
	name = "dodgerBlue"
}

Color.lightBlue = 
{
	r = 173,
	g = 216,
	b = 230,
	a = 255,
	name = "lightBlue"
}

Color.skyBlue = 
{
	r = 135,
	g = 206,
	b = 235,
	a = 255,
	name = "skyBlue"
}

Color.lightSkyBlue = 
{
	r = 135,
	g = 206,
	b = 250,
	a = 255,
	name = "lightSkyBlue"
}

Color.midnightBlue = 
{
	r = 25,
	g = 25,
	b = 112,
	a = 255,
	name = "midnightBlue"
}

Color.navy = 
{
	r = 0,
	g = 0,
	b = 128,
	a = 255,
	name = "navy"
}

Color.darkBlue = 
{
	r = 0,
	g = 0,
	b = 139,
	a = 255,
	name = "darkBlue"
}

Color.mediumBlue = 
{
	r = 0,
	g = 0,
	b = 205,
	a = 255,
	name = "mediumBlue"
}

Color.blue = 
{
	r = 0,
	g = 0,
	b = 255,
	a = 255,
	name = "blue"
}

Color.royalBlue = 
{
	r = 65,
	g = 105,
	b = 225,
	a = 255,
	name = "royalBlue"
}

Color.blueViolet = 
{
	r = 138,
	g = 43,
	b = 226,
	a = 255,
	name = "blueViolet"
}

Color.indigo = 
{
	r = 75,
	g = 0,
	b = 130,
	a = 255,
	name = "indigo"
}

Color.darkSlateBlue = 
{
	r = 72,
	g = 61,
	b = 139,
	a = 255,
	name = "darkSlateBlue"
}

Color.slateBlue = 
{
	r = 106,
	g = 90,
	b = 205,
	a = 255,
	name = "slateBlue"
}

Color.mediumSlateBlue = 
{
	r = 123,
	g = 104,
	b = 238,
	a = 255,
	name = "mediumSlateBlue"
}

Color.mediumPurple = 
{
	r = 147,
	g = 112,
	b = 219,
	a = 255,
	name = "mediumPurple"
}

Color.darkMagenta = 
{
	r = 139,
	g = 0,
	b = 139,
	a = 255,
	name = "darkMagenta"
}

Color.darkViolet  = 
{
	r = 148,
	g = 0,
	b = 211,
	a = 255,
	name = "darkViolet"
}

Color.darkOrchid = 
{
	r = 153,
	g = 50,
	b = 204,
	a = 255,
	name = "darkOrchid"
}

Color.mediumOrchid = 
{
	r = 186,
	g = 85,
	b = 211,
	a = 255,
	name = "mediumOrchid"
}

Color.purple = 
{
	r = 128,
	g = 0,
	b = 128,
	a = 255,
	name = "purple"
}

Color.thistle = 
{
	r = 216,
	g = 191,
	b = 216,
	a = 255,
	name = "thistle"
}

Color.plum = 
{
	r = 221,
	g = 160,
	b = 221,
	a = 255,
	name = "plum"
}

Color.violet = 
{
	r = 238,
	g = 130,
	b = 238,
	a = 255,
	name = "violet"
}

Color.magenta = 
{
	r = 255,
	g = 0,
	b = 255,
	a = 255,
	name = "magenta"
}

Color.orchid = 
{
	r = 218,
	g = 112,
	b = 214,
	a = 255,
	name = "orchid"
}

Color.mediumVioletRed = 
{
	r = 199,
	g = 21,
	b = 133,
	a = 255,
	name = "mediumVioletRed"
}

Color.paleVioletRed = 
{
	r = 219,
	g = 112,
	b = 147,
	a = 255,
	name = "paleVioletRed"
}

Color.deepPink = 
{
	r = 255,
	g = 20,
	b = 147,
	a = 255,
	name = "deepPink"
}

Color.hotPink = 
{
	r = 255,
	g = 105,
	b = 180,
	a = 255,
	name = "hotPink"
}

Color.lightPink = 
{
	r = 255,
	g = 182,
	b = 193,
	a = 255,
	name = "lightPink"
}

Color.pink = 
{
	r = 255,
	g = 192,
	b = 203,
	a = 255,
	name = "pink"
}

Color.antiqueWhite = 
{
	r = 250,
	g = 235,
	b = 215,
	a = 255,
	name = "antiqueWhite"
}

Color.beige = 
{
	r = 245,
	g = 245,
	b = 220,
	a = 255,
	name = "beige"
}

Color.bisque = 
{
	r = 255,
	g = 228,
	b = 196,
	a = 255,
	name = "bisque"
}

Color.blanchedAlmond = 
{
	r = 255,
	g = 235,
	b = 205,
	a = 255,
	name = "blanchedAlmond"
}

Color.wheat = 
{
	r = 245,
	g = 222,
	b = 179,
	a = 255,
	name = "wheat"
}

Color.cornSilk = 
{
	r = 255,
	g = 248,
	b = 220,
	a = 255,
	name = "cornSilk"
}

Color.lemonChiffon = 
{
	r = 255,
	g = 250,
	b = 205,
	a = 255,
	name = "lemonChiffon"
}

Color.lightGoldenRodYellow = 
{
	r = 250,
	g = 250,
	b = 210,
	a = 255,
	name = "lightGoldenRodYellow"
}

Color.lightYellow = 
{
	r = 255,
	g = 255,
	b = 224,
	a = 255,
	name = "lightYellow"
}

Color.saddleBrown = 
{
	r = 139,
	g = 69,
	b = 19,
	a = 255,
	name = "saddleBrown"
}

Color.sienna = 
{
	r = 160,
	g = 82,
	b = 45,
	a = 255,
	name = "sienna"
}

Color.chocolate	= 
{
	r = 210,
	g = 105,
	b = 30,
	a = 255,
	name = "chocolate"
}

Color.peru = 
{
	r = 205,
	g = 133,
	b = 63,
	a = 255,
	name = "peru"
}

Color.sandyBrown = 
{
	r = 244,
	g = 164,
	b = 96,
	a = 255,
	name = "sandyBrown"
}

Color.burlyWood = 
{
	r = 222,
	g = 184,
	b = 135,
	a = 255,
	name = "burlyWood"
}

Color.tan = 
{
	r = 210,
	g = 180,
	b = 140,
	a = 255,
	name = "tan"
}

Color.rosyBrown = 
{
	r = 188,
	g = 143,
	b = 143,
	a = 255,
	name = "rosyBrown"
}

Color.moccasin = 
{
	r = 255,
	g = 228,
	b = 181,
	a = 255,
	name = "moccasin"
}

Color.navajoWhite = 
{
	r = 255,
	g = 222,
	b = 173,
	a = 255,
	name = "navajoWhite"
}

Color.peachPuff = 
{
	r = 255,
	g = 218,
	b = 185,
	a = 255,
	name = "peachPuff"
}

Color.mistyRose	= 
{
	r = 255,
	g = 228,
	b = 225,
	a = 255,
	name = "mistyRose"
}

Color.lavenderBlush = 
{
	r = 255,
	g = 240,
	b = 245,
	a = 255,
	name = "lavenderBlush"
}

Color.linen = 
{
	r = 250,
	g = 240,
	b = 230,
	a = 255,
	name = "linen"
}

Color.oldLace = 
{
	r = 253,
	g = 245,
	b = 230,
	a = 255,
	name = "oldLace"
}

Color.papayaWhip = 
{
	r = 255,
	g = 239,
	b = 213,
	a = 255,
	name = "papayaWhip"
}

Color.seaShell = 
{
	r = 255,
	g = 245,
	b = 238,
	a = 255,
	name = "seaShell"
}

Color.mintCream = 
{
	r = 245,
	g = 255,
	b = 250,
	a = 255,
	name = "mintCream"
}

Color.slateGray = 
{
	r = 112,
	g = 128,
	b = 144,
	a = 255,
	name = "slateGray"
}

Color.lightSlateGray = 
{
	r = 119,
	g = 136,
	b = 153,
	a = 255,
	name = "lightSlateGray"
}

Color.lightSteelBlue = 
{
	r = 176,
	g = 196,
	b = 222,
	a = 255,
	name = "lightSteelBlue"
}

Color.lavender = 
{
	r = 230,
	g = 230,
	b = 250,
	a = 255,
	name = "lavender"
}

Color.floralWhite = 
{
	r = 255,
	g = 250,
	b = 240,
	a = 255,
	name = "floralWhite"
}

Color.aliceBlue = 
{
	r = 240,
	g = 248,
	b = 255,
	a = 255,
	name = "aliceBlue"
}

Color.ghostWhite = 
{
	r = 248,
	g = 248,
	b = 255,
	a = 255,
	name = "ghostWhite"
}

Color.honeydew = 
{
	r = 240,
	g = 255,
	b = 240,
	a = 255,
	name = "honeydew"
}

Color.ivory = 
{
	r = 255,
	g = 255,
	b = 240,
	a = 255,
	name = "ivory"
}

Color.azure = 
{
	r = 240,
	g = 255,
	b = 255,
	a = 255,
	name = "azure"
}

Color.snow = 
{
	r = 255,
	g = 250,
	b = 250,
	a = 255,
	name = "snow"
}

Color.black = 
{
	r = 0,
	g = 0,
	b = 0,
	a = 255,
	name = "black"
}

Color.dimGray = 
{
	r = 105,
	g = 105,
	b = 105,
	a = 255,
	name = "dimGray"
}

Color.gray = 
{
	r = 128,
	g = 128,
	b = 128,
	a = 255,
	name = "gray"
}

Color.darkGray = 
{
	r = 169,
	g = 169,
	b = 169,
	a = 255,
	name = "darkGray"
}

Color.silver = 
{
	r = 192,
	g = 192,
	b = 192,
	a = 255,
	name = "silver"
}

Color.lightGray = 
{
	r = 211,
	g = 211,
	b = 211,
	a = 255,
	name = "lightGray"
}

Color.gainsboro = 
{
	r = 220,
	g = 220,
	b = 220,
	a = 255,
	name = "gainsboro"
}

Color.whiteSmoke = 
{
	r = 245,
	g = 245,
	b = 245,
	a = 255,
	name = "whiteSmoke"
}

Color.white = 
{
	r = 255,
	g = 255,
	b = 255,
	a = 255,
	name = "white"
}


------------------------
-- All Colors
------------------------
Color.index = 
{
	"maroon", "darkRed", "brown", "firebrick", "crimson", "red", "tomato", "coral",
	"indianRed", "lightCoral", "darkSalmon", "salmon", "lightSalmon", "orangeRed",
	"darkOrange", "orange", "gold", "darkGoldenRod", "goldenRod", "paleGoldenRod",
	"darkKhaki", "khaki", "olive", "yellow", "yellowGreen", "darkOliveGreen", "oliveDrab",
	"lawnGreen", "chartReuse", "greenYellow", "darkGreen", "green", "forestGreen", "lime",
	"limeGreen", "lightGreen", "paleGreen", "darkSeaGreen", "mediumSpringGreen","springGreen",
	"seaGreen", "mediumAquaMarine", "mediumSeaGreen", "lightSeaGreen", "darkSlateGray", "teal",
	"darkCyan", "aqua", "cyan",	 "lightCyan", "darkTurquoise", "turquoise", "mediumTurquoise",
	"paleTurquoise", "aquaMarine", "powderBlue", "cadetBlue", "steelBlue", "cornFlowerBlue",
	"deepSkyBlue", "dodgerBlue", "lightBlue", "skyBlue", "lightSkyBlue", "midnightBlue",
	"navy", "darkBlue", "mediumBlue", "blue", "royalBlue", "blueViolet", "indigo", "darkSlateBlue",
	"slateBlue", "mediumSlateBlue", "mediumPurple", "darkMagenta", "darkViolet", "darkOrchid",
	"mediumOrchid", "purple", "thistle", "plum", "violet", "magenta", "orchid", "mediumVioletRed",
	"paleVioletRed", "deepPink", "hotPink", "lightPink", "pink", "antiqueWhite", "beige", "bisque",
	"blanchedAlmond", "wheat", "cornSilk", "lemonChiffon", "lightGoldenRodYellow", "lightYellow", 
	"saddleBrown", "sienna", "chocolate", "peru", "sandyBrown", "burlyWood", "tan", "rosyBrown",	
	"moccasin", "navajoWhite", "peachPuff", "mistyRose", "lavenderBlush", "linen", "oldLace",
	"papayaWhip", "seaShell", "mintCream","slateGray", "lightSlateGray", "lightSteelBlue", "lavender",
	"floralWhite", "aliceBlue", "ghostWhite", "honeydew", "ivory", "azure", "snow", "black",
	"dimGray", "gray", "darkGray", "silver", "lightGray", "gainsboro", "whiteSmoke", "white"
}

-----------------------
-- Groups
-----------------------
Color.group = {}
Color.group.ice =
{
	"white", "cyan", "blue", "darkBlue"	
}

Color.group.forest =
{
	"white", "yellow", "green", "darkGreen"
}

Color.group.peppermint =
{
	"white", "red", "white", "red", "white", "red", "white", "red", "white", "red",
}

Color.group.slowRed =
{
	"white", "red"	
}

Color.group.whiteToBlack =
{
	"white", "black"
}

Color.group.blackToWhite =
{
	"black", "white"
}

Color.group.blackWhiteFlash =
{
	"black", "white", "black", "white", "black", "white", "black", "white", "black", "white",	
}

Color.group.rainbow =
{
	"red", "green", "blue", "orange", "purple", "yellow" 
}

Color.group.pretty = 
{
	"white", "pink", "salmon", "darkSalmon", "purple"
}

Color.group.fire =
{
	"white", "yellow", "orange", "red", "darkRed", "black"
}

Color.group.fire2 =
{
	"yellow", "maroon"
	
}


---------------------
-- Static Functions
---------------------

-- return copy of given named color
function Color:Get(name)

	if(name == "random") then
		name = Random:ChooseRandomlyFrom(Color.index)
	end 

	local copy = Color:New
	{
		r = Color[name].r,
		g = Color[name].g,
		b = Color[name].b,
		a = Color[name].a,
		name = name,
	}
	
	return copy
end

--create a new color object
function Color:New(data)

	local o = {}


	-- object
	o.name = data.name or "..."
	o.oType = "Color"
	o.dataType = "Graphics"


	o.r = data.r or 256
	o.g = data.g or 256
	o.b = data.b or 256
	o.a = data.a or 256


	------------------
	-- Functions
	------------------

	-- print info to console
	function o:PrintSelf()
		print( ((self.name .. ": ") or "Color: ") .. "[" .. self.r .. ", " .. self.g .. ", " .. self.b .. ", " .. self.a .. "]")
	end

	-- get brightness value
	function o:Luminance()
		return (self.r + self.g + self.b) / 3
	end

	-- probly need to add to ObjectUpdater

	return o

end 


-----------------------------
-- More Static Functions
-- many of these need to be converted to object functions
-----------------------------

-- return color as table for love.graphics.setColor(color)
-- data = {r, g, b, a}
function Color:AsTable(data)

	local copy =
	{
		data.r,
		data.g,
		data.b,
		data.a
	}

	return copy
	
end

-- return the brightness of given color
function Color:GetLuminance(c)
	return (c.r + c.g + c.b) / 3
end

-- return inverse color of given color
function Color:GetInverted(c)
	
	local newColor = Color:New
	{
		r = 255 - c.r,
		g =	255 - c.g,
		b = 255 - c.b,
	}

	return newColor
	
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
-- data = {a, b}
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
-- data {a, b, loop}
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


-- restrict all components of a color
-- data = {color, min, max}
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

-- Linear Interpolation from color A to color B at T
-- data = {a, b, t, *alpha} 
function Color:Lerp(data)

	local newColor = Color:New
	{
		r =  data.a.r + ((data.b.r - data.a.r) * data.t),
		g =  data.a.g + ((data.b.g - data.a.g) * data.t),
		b =  data.a.b + ((data.b.b - data.a.b) * data.t),
	}

	-- alpha
	if(data.alpha ) then
		newColor.a =  data.a.a + ((data.b.a - data.a.a) * data.t)
	else
		newColor.a =  data.a.a
	end 

	return newColor

end 


ObjectUpdater:AddStatic(Color)



return Color



-- Notes
---------------------------------------------------------------------------
-- this file could be improved in functionality and ease of use 
-- but its fine for now


--------------------
--[[ Test Code
--------------------

-- local red = Color:Get("red")
-- red:PrintSelf()

--]]

