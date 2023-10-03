local NAME = "lab3"
local W, H = 512+128, 512

function love.conf(t)
    t.identity = "cg_" .. NAME

    t.window.title = "CG - " .. NAME
    t.window.width = W
    t.window.height = H
    t.window.resizable = false

    t.modules.audio     = false
    t.modules.data      = true
    t.modules.event     = true
    t.modules.font      = true
    t.modules.graphics  = true
    t.modules.image     = true
    t.modules.joystick  = false
    t.modules.keyboard  = true
    t.modules.math      = true
    t.modules.mouse     = true
    t.modules.physics   = false
    t.modules.sound     = false
    t.modules.system    = true
    t.modules.thread    = false
    t.modules.timer     = true
    t.modules.touch     = false
    t.modules.video     = false
    t.modules.window    = true
end