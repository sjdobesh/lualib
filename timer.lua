-- generic timer class

---@class Timer
---@field elapsed number time elapsed since last interval
---@field finished boolean a simple flag allowing external inspection
---@field interval number time between sending true pulses
---@field continuous boolean wether or not the timer repeats, defaults to false
---@field callback function? an optional function to run upon timer completion
Timer = {}
Timer.__index = Timer

---@alias TimerOpts {interval: number, continuous: boolean, callback: function}

-- make a new timer from a list of options
-- local as to only expose the generic timer constructor
---@param opts TimerOpts
---@return Timer
local function newOpts(opts)
	local t = {
		elapsed = 0,
		finished = false,
		interval = opts.interval or 0,
		continuous = opts.continuous or false,
		callback = opts.callback or nil,
	}
	setmetatable(t, Timer)
	return t
end

-- virtual table switch statement thing for initializing optional values
-- stylua: ignore
local timerinit_vt = {
	  number       = function(o, arg) o.interval   = arg end,
	  boolean      = function(o, arg) o.continuous = arg end,
	  ["function"] = function(o, arg) o.callback   = arg end
}

-- will take arguments one at a time in any order or as a single option table
-- interval:   number
-- continuous: boolean
-- callback:   function
---@param ... number | boolean | function | TimerOpts
---@return Timer
function Timer.new(...)
	local args = { ... }
	if #args == 1 then
		local arg = args[1] ---@cast arg TimerOpts
		return newOpts(arg)
	else
		local opts = { interval = nil, continuous = false, callback = nil }
		for _, arg in ipairs(args) do
			timerinit_vt[type(arg)](opts, arg)
		end
		return newOpts(opts)
	end
end

-- set timer options
---@param i number interval
---@param c boolean? continuous
---@param cb function? callback
function Timer:set(i, c, cb)
	self.interval = i
	self.continuous = c or self.continuous
	self.callback = cb or nil
end

-- reset time elapsed
function Timer:reset()
	self.elapsed = 0
end

-- update timer
---@param dt number delta time
---@return boolean finished
function Timer:update(dt)
	-- count elapsed time
	self.elapsed = self.elapsed + dt
	-- if we've completed an interval
	if self.elapsed > self.interval then
		self.finished = true
		-- run the callback if available
		if self.callback then
			self.callback()
			-- if not continuous, get rid of it.
			if not self.continuous then
				self.callback = nil
			end
		end
		if self.continuous then
			self.elapsed = 0
		end
		return true
	else
		return false
	end
end

return Timer
