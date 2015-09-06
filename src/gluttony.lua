local sentinel = {}
local end_program = {}

local function exit (operands) print ('result', unpack (operands)) print ('exit') end
local function quote (operands) return { operands } end

local function operator_prototype (operators, execute)
    local delimiter = sentinel
    if execute == exit then delimiter = end_program end
    local operands = {}
    local handle_operands = function (_) table.insert (operands, _) end
    local handle_operators = function (_) table.insert (operators, operator_prototype (operators, _)) end
    if execute == quote then handle_operators = handle_operands end  -- suspend execution of quoted
    return function (...)
        local args = {...}
        local _
        while (function () _ =
            table.remove (args, 1)
            return not (_ == nil or _ == delimiter) end) ()
        do
            if type (_) == 'function' then handle_operators (_) return else handle_operands (_) end
        end
        if _ == delimiter then
            table.remove (operators)
            local output = { execute (operands, operators) }
            for i, v in ipairs (args) do table.insert (output, v) end
            return output
        end
    end
end

function eval (operands, operators)
    for i, v in ipairs (operands) do
            local _ = operators[#operators] (v)
            while not (_ == nil or #operators == 0) do _ = operators[#operators] (unpack (_)) end
    end
end

function processor_prototype ()
    local operators = {}
    table.insert (operators, operator_prototype (operators, exit))
    return function (...) eval ({...}, operators) end
end

local function combinator_prototype (op)
    return function (operands)
        local _ = table.remove (operands, 1)
        for i, v in ipairs (operands) do _ = op (_, v) end
        return _
    end
end

local add = combinator_prototype (function (x, y) return x + y end)
local sub = combinator_prototype (function (x, y) return x - y end)

local loop
loop = function (operands, operators)
    local idx = operands[1]
    local limit = operands[2]
    local step = operands[3]
    print('loop', unpack (operands))
    if idx < limit then table.insert (operators, operator_prototype (operators, loop)) return idx + step, limit, step, sentinel end
end

local app = processor_prototype ()
app (add, 1, 2, 3, 4, 5, 6, sub, 2, 3, sentinel, loop, 0, 10, 2, sentinel, sentinel, 7, 8, sentinel, sentinel, quote, add, 1, 2, 3, sentinel, end_program)
-- app (1, 2)
-- app (3, 4)
-- app (5, 6)
-- app (sub)
-- app (2, 3, sentinel)
-- app (loop)
-- app (0, 10, 2, sentinel)
-- app (sentinel, 7, 8, sentinel, sentinel)