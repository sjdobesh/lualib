---@class Watcher
---@field watching { [string]: function } dictionary of functions to monitor execution  of
---@field listening table[] must implement `o:listen(who: string)` to respond to the function that executed
---@field originals { [string]: function }
local Watcher = {
	listening = {},
	watching = {},
	originals = {},
}

-- set / resets the watcher and listening fields
---@param watching { [string]: function } observed for execution
---@param listening table[] executed in response to the function
function Watcher:set(watching, listening)
	self:watchMany(watching)
	self:listenTo(listening)
end

-- clears the watching and listening tables
-- also unwraps the functions that had been wrapped
function Watcher:clear()
	self.watching = {}
	self.listening = {}
	local r = self.originals
	self.originals = {}
	return r
end

-- add a single listener into table
---@param l table that implements `:listen(who: string)` where who is the name of the function that triggered it
function Watcher:listenTo(l)
	table.insert(self.listening, l)
end

function Watcher:listenToMany(lg)
	for _, l in ipairs(lg) do
		Watcher:listenTo(l)
	end
end

-- pass along a msg to a subscriber
function Watcher:tell(msg)
	print("telling!")
	for _, listener in ipairs(Watcher.listening) do
		listener:listen(msg)
	end
end

-- watch a function by wrapping it in a table with
-- a __call metamethod that calls your notify function
function Watcher:watch(f, name)
	wrapped = {}
	setmetatable(wrapped, {
		__call = function()
			local r = { f() }
			self:tell(name)
			return unpack(r)
		end,
		__name = name,
	})
	self.watching[name] = wrapped
	self.originals[name] = f
	return wrapped
end

---@param fg { [string]: function}
---@return function[] a reference to the watxhed tsble
function Watcher:watchMany(fg)
	for k, v in pairs(fg) do
		self:watch(v, k)
	end
	return self.watching
end

-- example usage
StatefulFunctions = {
	foo = function()
		print("foo!")
	end,
	bar = function(...)
		print("bar!")
		return ...
	end,
}

-- example listener
L1 = {
	listen = function(self, who)
		print("listener heard " .. who)
	end,
}

StatefulFunctions = Watcher:watchMany(StatefulFunctions)
Watcher:listenTo(L1)
-- should trigger listener
StatefulFunctions.foo()
UnstatefulFunctions = Watcher:clear()
-- should no longer trigger
UnstatefulFunctions.foo()
