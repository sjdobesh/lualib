function love.conf(t)
    t.window.title = "Black Sigil"

    -- Virtual resolution will be scaled in main.lua
    t.window.width = 240 * 5 -- base width × scale
    t.window.height = 160 * 5 -- base height × scale
    t.window.resizable = false
    t.window.vsync = 1
    t.console = true
end
