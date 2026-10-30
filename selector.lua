---@class Selector
---@field index number
---@field options string[]
local Selector = {}
Selector.__index = Selector

---@param opts string[] selectable options
---@return Selector
function Selector.new(opts)
	local s = {
		index = 1,
		options = opts or {},
	}
	setmetatable(s, Selector)
	return s
end

function Selector:draw()
	for i = 1, #self.options do
		love.graphics.printf(self.options[i], 0, i * 20, love.graphics.getWidth(), "left")
		if i == self.index then
			love.graphics.rectangle("line", 0, i * 20, 20, 40)
		end
	end
end

-- handle wrapping index selection
function Selector:handleKey(key)
	if key == "up" or key == "w" then
		self.index = (math.fmod(self.index + #self.options - 2, #self.options) + 1)
		print("up: " .. self.index)
	end
	if key == "down" or key == "s" then
		self.index = (math.fmod(self.index + #self.options, #self.options) + 1)
		print("down: " .. self.index)
	end
end

return Selector
