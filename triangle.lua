local triangle = {}

function triangle:init(imageData)
    self.image = love.graphics.newImage(imageData)
    self.imageData = imageData
end


local math_abs = math.abs
local math_sqrt = math.sqrt
local math_min, math_max = math.min, math.max
local math_clamp_bi = function(x, a, b) if a > b then a, b = b, a end return math_min(math_max(x, a), b) end

local function distance(p1, p2)
    local dx, dy = p2[1] - p1[1], p2[2] - p1[2]
    return math_sqrt(dx * dx + dy * dy)
end

local function distanceToLine(p1, p2, x, y)
    return math_abs((p2[1] - p1[1]) * (p1[2] - y) - (p1[1] - x) * (p2[2] - p1[2])) / distance(p1, p2)
end

local function sampleTriangle(triangle, x, y)
    local rp, gp, bp = unpack(triangle)
    
    local rdmax = distanceToLine(gp, bp, rp[1], rp[2])
    local gdmax = distanceToLine(rp, bp, gp[1], gp[2])
    local bdmax = distanceToLine(rp, gp, bp[1], bp[2])

    local rd = distanceToLine(gp, bp, x, y)
    local gd = distanceToLine(rp, bp, x, y)
    local bd = distanceToLine(rp, gp, x, y)

    local r = rd / rdmax
    local g = gd / gdmax
    local b = bd / bdmax

    return r, g, b
end


local function paintTriangle(imageData, p1, p2, p3)
    local unsorted = {p1, p2, p3}
    local sorted = {p1, p2, p3}
    table.sort(sorted, function(a, b) return a[2] < b[2] end)
    p1, p2, p3 = unpack(sorted)
    local yStart = math.floor(p1[2] + 0.5)
    local yMid = math.floor(p2[2] + 0.5)
    local yEnd = math.floor(p3[2] + 0.5)
    local slope1 = (p2[2] - p1[2]) / (p2[1] - p1[1])
    local slope2 = (p3[2] - p1[2]) / (p3[1] - p1[1])
    local slope3 = (p3[2] - p2[2]) / (p3[1] - p2[1])

    for y=yStart, yEnd do
        local xEdge1
        if y < yMid then
            xEdge1 = math_clamp_bi((y - yStart) / slope1 + p1[1], p1[1], p2[1])
        else
            xEdge1 = math_clamp_bi((y - yMid) / slope3 + p2[1], p2[1], p3[1])
        end

        local xEdge2 = math_clamp_bi((y - yStart) / slope2 + p1[1], p1[1], p3[1])
        if xEdge1 > xEdge2 then
            xEdge1, xEdge2 = xEdge2, xEdge1
        end

        xEdge1, xEdge2 = math.floor(xEdge1 + 0.5), math.floor(xEdge2 + 0.5)
        for x=xEdge1, xEdge2 do
            local r, g, b = sampleTriangle(unsorted, x, y)
            imageData:setPixel(x, y, r, g, b, 1)
        end
    end
end


function triangle:draw(p1, p2, p3)
    self.imageData:mapPixel(function() return 1, 1, 1, 1 end)
    paintTriangle(
        self.imageData,
        p1, p2, p3
    )
    self.image:replacePixels(self.imageData)
end

return triangle
