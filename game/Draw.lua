-- Draw.lua
-- global love.graphics wrappers

Draw = {}







-- calls love.graphics.draw()
-- with a table --> use any order or optional
-- {drawable, x, y, r, sx, sy, ox, oy, kx, ky} -- love names
-- {object, x, y, rot, xScale, yScale, xOffset, yOffset, xShear, yShear}
function Draw:Draw(data)

	-- defaults
	--> add a "missing texture/graphics" image to project
	local drawable = data.object -- or "missing graphics"
	local x = data.x or 0
	local y = data.y or 0
	local r = data.rot or 0
	local sx = data.xScale or 1
	local sy = data.yScale or 1
	local ox = xOffset or 0
	local oy = yOffset or 0
	local kx = xShear or 0
	local ky = yShear or 0

	love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end
