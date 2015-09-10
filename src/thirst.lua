if not table.unpack and unpack then table.unpack = unpack end  -- polyfill

local sentinel = {}
local quote_sentinel = {}
local void = {}

local function exit (operands) print ('result', table.unpack (operands)) print ('exit') end
local function quote (operands) return operands end

local operator_prototype_base
local operator_prototype

operator_prototype_base = function (operators, execute, definitions)
    local base
    base = {
    delimiter = sentinel,
    delimit_counter = 1,
    operands = {},
    handle_operators = function (_) table.insert (operators, operator_prototype (operators, _, definitions)) end,
    handle_operands = function (_) table.insert (base.operands, _) end,
    run = function (...)
        local args = {...}
        local _
        while (function () _ =
            table.remove (args, 1)
            if _ == base.delimiter then base.delimit_counter = base.delimit_counter - 1 end
            return not (_ == nil or _ == void) and base.delimit_counter > 0 end) ()
        do
            if type (_) == 'function' then base.handle_operators (_) else base.handle_operands (_) end
        end
        -- debug
        -- print (base.delimit_counter)
        -- debug
        if base.delimit_counter <= 0 then
            for i = #operators, 1, -1 do  -- remove self
                if operators[i] == base.run then table.remove (operators, i) break end
            end
            local output = { execute (base.operands, operators, definitions) }
            for i, v in ipairs (args) do table.insert (output, v) end
            return output
        end
    end }
    return base
end

operator_prototype = function (operators, execute, definitions)
    local base = operator_prototype_base (operators, execute, definitions)
    -- polymorphic dispatch
    if execute == quote then -- suspend execution of quoted
        base.delimiter = quote_sentinel
        base.handle_operators = function (_)
            if _ == quote_sentinel then base.delimit_counter = base.delimit_counter + 1 else base.handle_operands (_) end
        end
    elseif execute == exit then base.delimiter = exit end
    return base.run
end

function eval (operands, operators, definitions)
    for i, v in ipairs (operands) do
            local _ = operators[#operators] (v)
            while not (_ == nil or #operators == 0) do  -- check!
              local args = {}
              for i, v in ipairs (_) do  -- TODO: handle more than one returned function!
                if type (v) == 'function' then table.insert (operators, operator_prototype (operators, v, definitions))
                else table.insert (args, v) end
              end
              _ = operators[#operators] (table.unpack (args))
            end
    end
end

function processor_prototype ()
    local definitions = {}
    local operators = {}
    table.insert (operators, operator_prototype (operators, exit, definitions))
    return function (...) if #operators > 0 then eval ({...}, operators, definitions)
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
        for i, v in ipairs (operands) do
            -- debug
            -- if type(v) == 'table' then print ('table', table.unpack (v)) end
            -- debug
            _ = op (_, v) end
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
    if idx < limit then return loop, idx + step, limit, step, sentinel else return void end
end

-- [ fork [  ] void true . ]

local fork = function (operands, operators)
    -- table.insert (operators, operator_prototype (operators, eval_quotes))
    local left = operands[1]
    local right = operands[2]
    local predicate = operands[3]
    local evaluated
    if predicate then evaluated = left else evaluated = right end
    return eval_quotes, evaluated, sentinel  -- evaluate right away
end

local define = function (operands, operators, definitions)
    local symbol = operands[1]
    local quotation = operands[2]
    definitions[symbol] = quotation
    return void
end

local refer = function (operands, operators, definitions)
    local symbol = operands[1]
    return definitions[symbol]
end

local app = processor_prototype ()
app (add, eval_quotes, quote, div, 1, 2, 3, add, 4, 5, 6, sentinel, sentinel, quote_sentinel, quote, div, 1, 2, 3, add, 4, 5, 6, sentinel, sentinel, quote_sentinel, sentinel, sentinel, exit)
app ()
app2 = processor_prototype ()
app2 (fork, quote, add, 1, 2, 3, sentinel, quote_sentinel, quote, sub, 1, 2, 3, sentinel, quote_sentinel, false, sentinel, exit)
app3 = processor_prototype ()
app3 (loop, 0, 10, 2, sentinel, exit)
app4 = processor_prototype ()
app4 (define, 'test', quote, 1, 2, 3, quote_sentinel, sentinel, eval_quotes, refer, 'test', sentinel, sentinel, exit)