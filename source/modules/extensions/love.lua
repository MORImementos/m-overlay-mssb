local graphics = love.graphics

local clear = graphics.clear
local setColor = graphics.setColor
local getColor = graphics.getColor
local setBackgroundColor = graphics.setBackgroundColor
local getBackgroundColor = graphics.getBackgroundColor

-- Love2D changed color values to be 0-1
-- Allow 0-255 values again..
function graphics.clear(r,g,b,a,...)
	if type(r) == "table" then
		r, g, b, a = r.r or 0, r.g or 0, r.b or 0, r.a or 0
	else
		r, g, b, a = tonumber(r) or 0, tonumber(g) or 0, tonumber(b) or 0, tonumber(a) or 0
	end
	r, g, b, a = r/255, g/255, b/255, a/255
	clear(r,g,b,a,...)
end

-- Love2D changed color values to be 0-1
-- Allow 0-255 values again..
function graphics.setColor(r,g,b,a)
	if type(r) == "table" then
		r, g, b, a = r.r or 0, r.g or 0, r.b or 0, r.a or 0
	else
		r, g, b, a = tonumber(r) or 0, tonumber(g) or 0, tonumber(b) or 0, tonumber(a) or 0
	end
	r, g, b, a = r/255, g/255, b/255, a/255
	setColor(r, g, b, a)
end

function graphics.getColor()
	local r,g,b,a = getColor()
	return r*255, g*255, b*255, a*255
end

-- Love2D changed color values to be 0-1
-- Allow 0-255 values again..
function graphics.setBackgroundColor(r,g,b,a)
	if type(r) == "table" then
		r, g, b, a = r.r or 0, r.g or 0, r.b or 0, r.a or 0
	else
		r, g, b, a = tonumber(r) or 0, tonumber(g) or 0, tonumber(b) or 0, tonumber(a) or 0
	end
	r, g, b, a = r/255, g/255, b/255, a/255
	setBackgroundColor(r,g,b,a)
end

function graphics.getBackgroundColor()
	local r,g,b,a = getBackgroundColor()
	return r*255, g*255, b*255, a*255
end

-- Draw an image using width and height in pixels
-- OriginX and OriginY should be between 0 and 1
-- An origin of 0.5, 0.5 would be the center
function graphics.easyDraw(obj, x, y, rotation, width, height, originX, originY, ...)
	if not obj then return end

	local objW, objH = obj:getWidth(), obj:getHeight()

	rotation = rotation or 0
	width = width or objW
	height = height or objH
	originX = originX or 0
	originY = originY or 0

	local scaledW = width / objW
	local scaledH = height / objH
	graphics.draw(obj, x, y, rotation, scaledW, scaledH, objW * originX, objH * originY, ...)
end

--applies a transformation that maps
--  0,0 => ox, oy
--  1,0 => xx, xy
--  0,1 => yx, yy
-- via love.graphics.translate, .rotate and .scale

local sqrt = math.sqrt
local atan2 = math.atan2
local acos = math.acos
local tan = math.tan
local cos = math.cos
local sin = math.sin

function graphics.transform(ox, oy, xx, xy, yx, yy)

	local ex, ey, fx,fy = xx-ox, xy-oy, yx-ox, yy-oy
	if ex*fy<ey*fx then ex,ey,fx,fy=fx,fy,ex,ey end
	local e,f = math.sqrt(ex*ex+ey*ey), math.sqrt(fx*fx+fy*fy)

	ex,ey = ex/e, ey/e
	fx,fy = fx/f, fy/f

	local desiredOrientation=math.atan2(ey+fy,ex+fx)
	local desiredAngle=math.acos(ex*fx+ey*fy)/2
	local z=math.tan(desiredAngle)
	local distortion=math.sqrt((1+z*z)/2)

	graphics.translate(ox, oy)
	graphics.rotate(desiredOrientation)
	graphics.scale(1, z)
	graphics.rotate(-math.pi/4)
	graphics.scale(e/distortion,f/distortion)

end

function graphics.innerRectangle(x, y, w, h, ...)
	local lw = graphics.getLineWidth()

	x = x + lw/2
	y = y + lw/2
	w = w - lw
	h = h - lw

	graphics.rectangle("line", x, y, w, h, ...)
end

-- Draw a rectangle to fit AROUND the width and height
function graphics.outlineRectangle(x, y, w, h, ...)
	local lw = graphics.getLineWidth()

	x = x - lw/2
	y = y - lw/2
	w = w + lw
	h = h + lw

	graphics.rectangle("line", x, y, w, h, ...)
end

function graphics.textOutlinef(text, width, x, y, ...)
	local steps = width * 2 / 3
	if steps < 1 then steps = 1 end

	for _x = -width, width, steps do
		for _y = -width, width, steps do
			graphics.printf(text, x + _x, y + _y, ...)
		end
	end
end

function graphics.textOutline(text, width, x, y, ...)
	local steps = width * 2 / 3
	if steps < 1 then steps = 1 end

	for _x = -width, width, steps do
		for _y = -width, width, steps do
			graphics.print(text, x + _x, y + _y, ...)
		end
	end
end

function graphics.roundRect(x, y, width, height, radius)
	--RECTANGLES
	graphics.rectangle("fill", x + radius, y, width-2*radius, height )
	graphics.rectangle("fill", x, y + radius, radius, height - (radius * 2))
	graphics.rectangle("fill", x + (width - radius), y + radius, radius, height - (radius * 2))

	--ARCS
	graphics.arc("fill", x + radius, y + radius, radius, math.rad(-180), math.rad(-90))
	graphics.arc("fill", x + width - radius , y + radius, radius, math.rad(-90), math.rad(0))
	graphics.arc("fill", x + radius, y + height - radius, radius, math.rad(-180), math.rad(-270))
	graphics.arc("fill", x + width - radius , y + height - radius, radius, math.rad(0), math.rad(90))
end
