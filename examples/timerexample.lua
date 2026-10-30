-- timer example

-- import module and set correct type inference
local T = require("modules.timer") ---@type Timer

-- initialization supports any order, all optional, or as an opt table
-- stylua: ignore
local timer = T.new({
	interval = 2,
	continuous = true,
	callback = function() print("hi!") end,
})
-- local timer = T.new(2, true, function() print("hi!") end)

function love.update(dt)
	timer:update(dt)
end

function love.draw()
	if timer.finished then
		timer.finished = false -- external access to flag allows observer patterns
		love.graphics.setBackgroundColor(1, 0, 0, 1)
	else
		love.graphics.setBackgroundColor(0, 1, 0, 1)
	end
end

function love.keypressed(key)
	if key == "q" or key == "escape" then
		love.event.quit()
	end
end
