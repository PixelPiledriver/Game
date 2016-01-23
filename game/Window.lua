-- Window.lua

-- Purpose
----------------------------
-- Handles the window the game is diplayed within

---------------------------------------------------------

-- global
Window = {}

------------------
-- Static Info
------------------
Window.Info = Info:New
{
	objectType = "Window",
	dataType = "View",
	structureType = "Static"
}

----------------
-- Title
----------------

-- fun additional text to add to the window title
-- a random title is chosen each time you run the game
Window.titleFlavor = 
{
	"[*___*]",
	"[x___x]",
	"[o___o]",
	"[+___-]",
	"[-___*]",
	"[>___>]",
	"[<___<]",
	"[-___-]",
	":D",
	":)",
	":O",
	":|",
	">:E",
	"D:",
	"XD",
	">:A",
	"YEAW",
	"WAT",
	"WUT",
	"aw yeaw",
	"pow pow pachow",
	"oh yes",
	"shabba",
	"yep",
	"Do a barrel roll!",
	"NEVER GONNA GIVE IT UP!!!",
	"2DEEP4U",
	"just... DO IT!",
	"Don't even trip dawg...",
	"The path of life is not always short and sweet",
	"loves you...",
	"has vivid dreams of you...",
	"thinks about you when you're not around...",
	"saw you sleeping last night...",
	"Hello World",
	"You can do this!",
	"you just gotta BELIEVE",
}

Window.title = "PixelRobot: " .. Random:ChooseRandomlyFrom(Window.titleFlavor)

love.window.setTitle(Window.title)


-----------
-- Size
-----------
-- sets window to full screen of current monitor
-- love.window.setMode(0,0,{display = 1})

Window.width = love.window.getWidth()
Window.height = love.window.getHeight()

------------------
-- Functions
------------------


-- check if an Pos is inside in the window space or not
-- pos = {x,y} or Pos object
-- shit this wont actually work correctly if the camera is moved.... :P
function Window:IsPosOnScreen(pos)
	-- this is a very bare bones check
	-- can implement a more complex version
	-- that takes size or string length into account
	-- all this checks is for a single point in window or not

	if(pos.x < 0) then
		return false
	end 

	if(pos.x > love.window.getWidth()) then
		return false
	end 

	if(pos.y < 0) then
		return false
	end 

	if(pos.y > love.window.getHeight()) then
		return false
	end 

	return true

end 

function Window:PrintDebugText()
	DebugText:TextTable
	{
		{text = "", obj = "Window"},
		{text = "Window"},
		{text = "-----------"},
		{text = "Width: " .. love.window.getWidth()},
		{text = "Height: " .. love.window.getHeight()},
	}
end


ObjectManager:AddStatic(Window)

return Window



-- Notes
----------------------------------
-- changed to global
-- to include some useful functions realated to window size
-- will add other cool features to this later