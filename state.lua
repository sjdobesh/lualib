P = require("pprint")
-- state pattern example
-- a Finite State Machine implementation based on a dictionary of mappings

-- stylua: ignore
---@enum States say a characters position in a game
local States = {
	standing = "standing",
	ducking  = "ducking",
	jumping  = "jumping",
	diving   = "diving",
}

-- stylua: ignore
---@enum Inputs user inputs to change character state
local Inputs = {
	pressDown   = "pressDown",
	releaseDown = "releaseDown",
	pressB      = "pressB",
	releaseB    = "releaseB",
	doNothing   = "doNothing",
}

-- state object
---@class State
---@field currentState States
---@field stateTransitions { [string]: string[] }
local State = {
	currentState = States.standing,
	-- a map of state transitions based on input ie. state(input) -> state
	stateTransitions = {
		[States.standing] = {
			[Inputs.pressDown] = States.ducking,
			[Inputs.pressB] = States.jumping,
		},
		[States.ducking] = {
			[Inputs.releaseDown] = States.standing,
		},
		[States.jumping] = {
			[Inputs.releaseB] = States.standing,
			[Inputs.pressDown] = States.diving,
		},
		[States.diving] = {
			[Inputs.doNothing] = States.standing,
		},
	},
}

local function transition(self, input)
	if self.stateTransitions[self.currentState][input] then
		self.currentState = self.stateTransitions[self.currentState][input]
	end
end
setmetatable(State, { __call = transition })

-- example of use
P = require("pprint")
P(State)

-- a series of example inputs
local command_inputs = {
	Inputs.pressDown,
	Inputs.pressDown,
	Inputs.releaseDown,
	Inputs.pressB,
	Inputs.pressDown,
}

-- (state -> input -> state)
for _, input in ipairs(command_inputs) do
	io.write(string.format("%-8s -> ", State.currentState))
	io.write(string.format("%-11s ", input))
	State(input)
	io.write(string.format("-> %-8s\n", State.currentState))
end

-- reusable

---@param currentState string
---@param stateTransitions { [string]: string[] }
local function newStateArg(currentState, stateTransitions)
	local s = {}
	setmetatable(s, { __call = transition })
	s.currentState = currentState or nil
	s.stateTransitions = stateTransitions or nil
	P(s)
	return s
end

local function newStateOpts(opts)
	return newStateArg(opts.currentState, opts.stateTransitions)
end

function NewState(...)
	local args = { ... }
	if #args == 1 then
		return newStateOpts(args[1])
	else
		local opts = { currentState = nil, stateTransitions = nil }
		local vt = {
			string = function(i)
				opts.currentState = i
			end,
			table = function(i)
				opts.stateTransitions = i
			end,
		}
		for _, v in ipairs(args) do
			print(type(v))

			vt[type(v)](v)
		end
		P(opts)

		return newStateOpts(opts)
	end
end

local s = NewState(States.standing, {
	[States.standing] = {
		[Inputs.pressDown] = States.ducking,
		[Inputs.pressB] = States.jumping,
	},
	[States.ducking] = {
		[Inputs.releaseDown] = States.standing,
	},
	[States.jumping] = {
		[Inputs.releaseB] = States.standing,
		[Inputs.pressDown] = States.diving,
	},
	[States.diving] = {
		[Inputs.doNothing] = States.standing,
	},
})

print("new test")
-- (state -> input -> state)
for _, input in ipairs(command_inputs) do
	io.write(string.format("%-8s -> ", s.currentState))
	io.write(string.format("%-11s ", input))
	s(input)
	io.write(string.format("-> %-8s\n", s.currentState))
end

-- maybe now incorporate it into an object ala component
--
-- reset current state
s.currentState = States.standing

-- stylua: ignore
local o = {
	state = s,
  statefulFunctions = {
    pressDown   = function() print("pressDown") end,
    releaseDown = function() print("releaseDown") end,
    pressB      = function() print("pressB") end,
    releaseB    = function() print("releaseB") end,
    doNothing   = function() print("doNothing") end,
  }
}

-- maybe use metamethods to hide a notify() in the __call() method or similar
function WrapNotify(func)
	local t = {}
	setmetatable(t, {
		__call = function()
			func()
		end,
	})
	return t
end
