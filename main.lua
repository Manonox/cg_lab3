local t = 0
local image
local imageData
local showTriangle = false

local triangle = require("triangle")
local draw = require("draw")



function love.load()
    local v = 30 / 255
    love.graphics.setBackgroundColor(v, v, v, 1)

    local triangleImageData = love.image.newImageData(512, 512)
    triangleImageData:mapPixel(function() return 1, 1, 1, 1 end)
    triangle:init(triangleImageData)

    imageData = love.image.newImageData(128, 128)
    imageData:mapPixel(function() return 1, 1, 1, 1 end)
    draw.line(imageData, 32, 32, 64, 100)
    draw.line(imageData, 32, 32, 120, 50)
    draw.line(imageData, 64, 100, 120, 50)
    image = love.graphics.newImage(imageData)
    image:setFilter("nearest", "nearest")
end


function love.update(dt)
    t = t + dt

end


local function rotate(p, a)
    local x, y = p[1] - 256, p[2] - 256
    local d, th = math.sqrt(x * x + y * y), math.atan2(y, x)
    x, y = d * math.cos(th + a), d * math.sin(th + a)
    return { x + 256, y + 256 }
end

function love.draw()
    if showTriangle then
        triangle:draw(rotate({400, 400}, t), rotate({256, 128}, t*1.6), rotate({100, 300}, t*3.51))
        love.graphics.draw(triangle.image, 128, 0)
        return
    end

    love.graphics.draw(image, 128, 0, 0, 4, 4)
end


function love.filedropped(file)
    file:open("r")
    local fileImageData = love.image.newImageData(file:read("data"))
    file:close()
    
    local w, h = fileImageData:getWidth(), fileImageData:getHeight()
    draw.fill(imageData, 64, 64, 0, function(x, y)
        local r, g, b, a = fileImageData:getPixel(x % w, y % h)
        return r, g, b, 1
    end)
    image:replacePixels(imageData)
end
