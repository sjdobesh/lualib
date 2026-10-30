---@class Timer
---@field elapsed number time elapsed since last interval
---@field interval number time between sending true pulses
---@field continuous boolean wether or not the timer repeats, defaults to false
---@field set fun(self: Timer, interval: number, continuous: boolean?) set interval time
---@field reset fun(self: Timer) reset elapsed time
---@field update fun(self: Timer, dt: number): boolean update timer, returns true once time is elapsed
Timer = {}

-- make a new timer
---@param interval number? interval to set timer at
---@param continous boolean? if timer repeats
---@return Timer
function Timer.new(interval, continous)
	---@type Timer
	local timer = {
		elapsed = 0,
		interval = interval or 0,
		continuous = continous or false,

		-- set timer options
		---@param i number interval
		---@param c boolean continous
		set = function(self, i, c)
			self.interval = i
			self.continuous = c or self.continuous
		end,

		-- reset time elapsed
		reset = function(self)
			self.elapsed = 0
		end,
		-- update timer
		---@param dt number delta time
		---@return boolean finished
		update = function(self, dt)
			self.elapsed = self.elapsed + dt
			if self.elapsed > self.interval then
				self.elapsed = 0
				return true
			else
				return false
			end
		end,
	}
	setmetatable(timer, Timer)
	return timer
end

return Timer
