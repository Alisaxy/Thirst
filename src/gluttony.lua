local sentinel = {}

local function exit (...) print('result', ...) print('exit') end

local function operator_prototype (operators, execute)
    local hungry = true
    local operands = {}
    local rest = {}
    return function (...)
        print('operands', unpack (operands))  -- debug
        if hungry then
            for i, v in ipairs({...}) do
                if v == sentinel then
                    hungry = false
                else
                    if hungry then table.insert (operands, v) else table.insert (rest, v) end
                end
            end
            if not hungry then
                table.remove (operators)
                local output = {execute (operands)}
                for i, v in ipairs (rest) do table.insert (output, v) end
                operators[#operators] (unpack (output))
            end
        end
    end
end

local function combinator_prototype (op, result)
    return function (operands)
        for i, v in ipairs(operands) do result = op(result, v) end
        return result
    end
end

local add = combinator_prototype (function (x, y) return x + y end, 0)
local sub = combinator_prototype (function (x, y) return x - y end, 0)

local operators = {exit}
table.insert (operators, operator_prototype (operators, add))
operators[#operators] (1, 2)
operators[#operators] (3, 4)
operators[#operators] (5, 6)
table.insert (operators, operator_prototype (operators, sub))
operators[#operators] (2, 3, sentinel)
operators[#operators] (sentinel, 7, 8)