local sentinel = {}
local end_program = {}
local end_quote = {}

local function exit (operands) print ('result', unpack (operands)) print ('exit') end
local function quote (operands) return operands end

local function operator_prototype (operators, execute)
    local delimit_counter = 1
    local delimiter = sentinel
    if execute == exit then delimiter = end_program end  -- a special end_program delimiter is required to exit the program
    local operands = {}
    local handle_operands = function (_) table.insert (operands, _) end
    local handle_quoted_operands = function (_)
        if _ == quote then delimit_counter = delimit_counter + 1 end
        handle_operands (_)
    end
    local handle_operators = function (_) table.insert (operators, operator_prototype (operators, _)) end
    if execute == quote then
        delimiter = end_quote
        handle_operators = handle_quoted_operands
    end  -- suspend execution of quoted
    return function (...)
        -- if (execute == eval_quotes) then print ('!') end
        local args = {...}
        local _
        while (function () _ =
            table.remove (args, 1)
            return not (_ == nil or _ == delimiter) end) ()
        do
            if type (_) == 'function' then handle_operators (_) else handle_operands (_) end
        end
        if _ == delimiter then delimit_counter = delimit_counter - 1 end
        if delimit_counter <= 0 then
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

function eval_quotes (operands, operators)
    print ('eval', unpack (operands))
    for i, v in ipairs (operands) do eval (v, operators) end
end

local function combinator_prototype (op)
    return function (operands)
        -- print ('operands', unpack (operands))
        local _ = table.remove (operands, 1)
        for i, v in ipairs (operands) do if type(v) == 'table' then print ('table', unpack (v)) end _ = op (_, v) end
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
app (add, 1, 2, 3, 4, 5, 6, eval_quotes, 
    quote, add, 1, 2, 3, add, 1, 2, 3, sentinel, end_quote, quote, add, 1, 2, 3, sentinel, sentinel, end_quote,
sentinel, sub, 2, 3, sentinel, loop, 0, 10, 2, sentinel, sentinel, 7, 8, sentinel, sentinel, end_program)
-- app (1, 2)
-- app (3, 4)
-- app (5, 6)
-- app (sub)
-- app (2, 3, sentinel)
-- app (loop)
-- app (0, 10, 2, sentinel)
-- app (sentinel, 7, 8, sentinel, sentinel)