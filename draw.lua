local draw = {}


local abs = math.abs
function draw.line(imageData, x0, y0, x1, y1)
    local dx, dy = abs(x1 - x0), -abs(y1 - y0)
    local sx, sy = x0 < x1 and 1 or -1, y0 < y1 and 1 or -1
    local error = dx + dy

    while true do
        local v = 0
        imageData:setPixel(x0, y0, v, v, v, 1)
        if x0 == x1 and y0 == y1 then break end
        local e2 = 2 * error
        
        if e2 >= dy then
            if x0 == x1 then break end
            error = error + dy
            x0 = x0 + sx
        end

        if e2 <= dx then
            if y0 == y1 then break end
            error = error + dx
            y0 = y0 + sy
        end
    end
end

local floor = math.floor
function draw.lineAA(imageData, x0, y0, x1, y1)
    imageData:setPixel(x1, y1, 1, 1, 1, 1)
    local dx, dy = x1 - x0, y1 - y0
    local grad = dy / dx
    local y = y0 + grad
    for x = x0 + 1, x1 do
        local yf = floor(y)
        local d = y - yf
        local v1, v2 = d, 1 - d
        imageData:setPixel(x, yf, v1, v1, v1, 1)
        imageData:setPixel(x, yf + 1, v2, v2, v2, 1)
        y = y + grad
    end
end



local function distanceSqr(r1, g1, b1, a1, r2, g2, b2, a2)
    local dr, dg, db, da = r1 - r2, g1 - g2, b1 - b2, a1 - a2
    return dr * dr + dg * dg + db * db + da * da
end

function draw.fill(imageData, x, y, radius, sampler, r, g, b, a)
    if not r then
        r, g, b, a = imageData:getPixel(x, y)
    end

    local xLeft = x
    while xLeft > 0 do
        if distanceSqr(r, g, b, a, imageData:getPixel(xLeft - 1, y)) > radius then break end
        xLeft = xLeft - 1
    end

    local w = imageData:getWidth()

    local xRight = x
    while xRight < w - 1 do
        if distanceSqr(r, g, b, a, imageData:getPixel(xRight + 1, y)) > radius then break end
        xRight = xRight + 1
    end

    for x_=xLeft, xRight do
        imageData:setPixel(x_, y, sampler(x_, y))
    end


    for x_=xLeft, xRight do
        if distanceSqr(r, g, b, a, imageData:getPixel(x_, y + 1)) <= radius then
            draw.fill(imageData, x_, y + 1, radius, sampler, r, g, b, a)
        end

        if distanceSqr(r, g, b, a, imageData:getPixel(x_, y - 1)) <= radius then
            draw.fill(imageData, x_, y - 1, radius, sampler, r, g, b, a)
        end
    end
end


return draw