-- minimal functional programming tools
---@class Functional
Functional = {}

-- map a function onto a table
---@param tbl table
---@param func fun(x: any):any
---@return table mappedTable
function Functional.map(tbl, func)
	local result = {}
	for i, v in ipairs(tbl) do
		result[i] = func(v)
	end
	return result
end

-- filter a table with a predicate function
---@param tbl table
---@param predicate fun(x: any):boolean
---@return table filteredTable
function Functional.filter(tbl, predicate)
	local result = {}
	for _, v in ipairs(tbl) do
		if predicate(v) then
			table.insert(result, v)
		end
	end
	return result
end

-- returns a range of numbers.
-- if given one argument, generates 0 to n, otherwise n1 to n2
---@param n1 number
---@param n2 number?
---@return number[] range integer inclusive range
function Functional.range(n1, n2)
	local result = {}
	if not n2 then
		n2 = n1
		n1 = 1
	end
	for i = n1, n2 do
		table.insert(result, i)
	end
	return result
end

return Functional
