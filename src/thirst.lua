table.unpack = unpack  -- polyfill

local sentinel = {}
local quote_sentinel = {}

local function exit (operands) print ('result', table.unpack (operands)) print ('exit') end
local function quote (operands) return operands end

local operator_prototype_base
local operator_prototype

operator_prototype_base = function (operators, execute)
    local base
    base = {
    delimiter = sentinel,
    delimit_counter = 1,
    operands = {},
    handle_operators = function (_) table.insert (operators, operator_prototype (operators, _)) end,
    handle_operands = function (_) table.insert (base.operands, _) end,
    run = function (...)
        local args = {...}
        local _
        while (function () _ =
            table.remove (args, 1)
            if _ == base.delimiter then base.delimit_counter = base.delimit_counter - 1 end
            return _ ~= nil and base.delimit_counter > 0 end) ()
        do
            if type (_) == 'function' then base.handle_operators (_) else base.handle_operands (_) end
        end
        -- debug
        print (base.delimit_counter)
        -- debug
        if base.delimit_counter <= 0 then
            for i = #operators, 1, -1 do  -- remove self
                if operators[i] == base.run then table.remove (operators, i) break end
            end
            local output = { execute (base.operands, operators) }
            for i, v in ipairs (args) do table.insert (output, v) end
            return output
        end
    end }
    return base
end

operator_prototype = function (operators, execute)
    local base = operator_prototype_base (operators, execute)
    -- polymorphic dispatch
    if execute == quote then -- suspend execution of quoted
        base.delimiter = quote_sentinel
        base.handle_operators = function (_)
            if _ == quote_sentinel then base.delimit_counter = base.delimit_counter + 1 else base.handle_operands (_) end
        end
    elseif execute == exit then base.delimiter = exit end
    return base.run
end

function eval (operands, operators)
    for i, v in ipairs (operands) do
            local _ = operators[#operators] (v)
            while not (_ == nil or #operators == 0) do _ = operators[#operators] (table.unpack (_)) end
    end
end

function processor_prototype ()
    local operators = {}
    table.insert (operators, operator_prototype (operators, exit))
    return function (...) if #operators > 0 then eval ({...}, operators)
        else
            print ('the program had ended its execution, any further invocations are futile') end
    end
end

function eval_quotes (operands, operators)
    for i, v in ipairs (operands) do eval (v, operators) end
end

local function combinator_prototype (op)
    return function (operands)
        local _ = table.remove (operands, 1)
        for i, v in ipairs (operands) do if type(v) == 'table' then print ('table', table.unpack (v)) end _ = op (_, v) end
        return _
    end
end

local add = combinator_prototype (function (x, y) return x + y end)
local sub = combinator_prototype (function (x, y) return x - y end)
local mul = combinator_prototype (function (x, y) return x * y end)
local div = combinator_prototype (function (x, y) return x / y end)

local loop
loop = function (operands, operators)
    local idx = operands[1]
    local limit = operands[2]
    local step = operands[3]
    print('loop', table.unpack (operands))
    if idx < limit then table.insert (operators, operator_prototype (operators, loop)) return idx + step, limit, step, sentinel end
end

local fork = function (operands, operators)
    table.insert (operators, operator_prototype (operators, eval_quotes))
    local left = operands[1]
    local right = operands[2]
    local predicate = operands[3]
    local evaluated
    if predicate then evaluated = left else evaluated = right end
    return evaluated, sentinel  -- evaluate right away
end

local app = processor_prototype ()
app (add, eval_quotes, quote, div, 1, 2, 3, add, 4, 5, 6, sentinel, sentinel, quote_sentinel, quote, div, 1, 2, 3, add, 4, 5, 6, sentinel, sentinel, quote_sentinel, sentinel, sentinel, exit)
app ()
app2 = processor_prototype ()
app2 (fork, quote, add, 1, 2, 3, sentinel, quote_sentinel, quote, sub, 1, 2, 3, sentinel, quote_sentinel, false, sentinel, exit)