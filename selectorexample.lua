S = require("selector")
---@type Selector
local s = S.new({
	"first thing",
	"second thing",
	"third thing",
})
function love.draw()
	s:draw()
end
function love.keypressed(key)
	if key == "q" or key == "escape" then
		love.event.quit()
	end
	s:handleKey(key)
end
