local sentinel = {}

local function exit (...) print('result', ...) print('exit') end

local function operator_prototype (operators, execute)
    local operands = {}
    return function (...)
        local args = {...}
        local _
        while (function () _ =
            table.remove (args, 1)
            return not (_ == nil or _ == sentinel) end) ()
        do
            table.insert (operands, _)
        end
        if _ == sentinel then
            table.remove (operators)
            local output = { execute (operands, operators) }
            for i, v in ipairs (args) do table.insert (output, v) end
            return output
        end
    end
end

function processor_prototype ()
    local operators = { exit }
    return { operator = function (op) table.insert (operators, operator_prototype (operators, op)) end,
             operand = function (...)
                local _ = operators[#operators] (...)
                while _ ~= nil do _ = operators[#operators] (unpack (_)) end
             end }
end

local function combinator_prototype (op, result)
    return function (operands)
        for i, v in ipairs (operands) do result = op (result, v) end
        return result
    end
end

local add = combinator_prototype (function (x, y) return x + y end, 0)
local sub = combinator_prototype (function (x, y) return x - y end, 0)

local loop
loop = function (operands, operators)
    local idx = operands[1]
    local limit = operands[2]
    local step = operands[3]
    print('loop', unpack(operands))
    if idx < limit then table.insert(operators, operator_prototype (operators, loop)) return idx + step, limit, step, sentinel
    else return 777 end
end

local app = processor_prototype ()
app.operator (add)
app.operand (1, 2)
app.operand (3, 4)
app.operand (5, 6)
app.operator (sub)
app.operand (2, 3, sentinel)
app.operator (loop)
app.operand (0, 10, 2, sentinel)
app.operand (sentinel, 7, 8)