F = require("modules.functional") ---@type Functional
P = require("modules.pprint")

print("===| filter(table, predicate)-> table |===")
L = { true, false, true, false }
io.write("input list: ")
P(L)
print("L = filter(L, P)")
-- stylua: ignore
L = F.filter(L, function(bool) return not bool end)
io.write("output list: ")
P(L)

print("\n===| map(table, function) -> table |===")
L = { 1, 2, 3, 4 }
io.write("input list: ")
P(L)
print("L = map(L, (+1))")
-- stylua: ignore
L = F.map(L, function(n) return n + 1 end )
io.write("output list: ")
P(L)

print("\n===| range(n1, n2) -> number[] |===")
print("input: (5)")
print("range(5)")
-- stylua: ignore
L = F.range(5)
io.write("output list: ")
P(L)
print("input: (-2, 4)")
print("range(-2, 4)")
-- stylua: ignore
L = F.range(-2, 4)
io.write("output list: ")
P(L)
