-- TemplateLevel.lua

-- Description
---------------------------------------
-- empty level

---------------------------------------------------------

local Start = function()
end

local Update = function()
end

local Restart = function()
end 

local Exit = function()
end



local level = Level:New
{
	Start = Start,
	Update = Update,
	Restart = Restart,
	Exit = Exit,

	filename = "TemplateLevel"
}

return level