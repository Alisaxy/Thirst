local sentinel = {}

local function exit (args) print('result', unpack (args)) print('exit') end

local function operator_prototype (operators, execute)
    local operands = {}
    return function (args)
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
    local handle_operator = function (op) table.insert (operators, operator_prototype (operators, op)) end
    local handle_operand = function (...)
                local _ = operators[#operators] ({...})
                while _ ~= nil do _ = operators[#operators] (unpack (_)) end
             end
    local process = function (...)
        for i, v in ipairs ({...}) do
            if type(v) == 'function' then handle_operator (v) else handle_operand (v) end
            if operators[#operators] == exit then return handle_operator (select (i, ...)) end
        end
    end
    return process
end

local function combinator_prototype (op, result)
    return function (operands)
        for i, v in ipairs (operands) do result = op (result, v) end
        return { result }
    end
end

local add = combinator_prototype (function (x, y) return x + y end, 0)
local sub = combinator_prototype (function (x, y) return x - y end, 0)

local loop
loop = function (operands, operators)
    local idx = operands[1]
    local limit = operands[2]
    local step = operands[3]
    print ('loop', unpack (operands))
    if idx < limit then table.insert (operators, operator_prototype (operators, loop)) return {idx + step, limit, step, sentinel}
    else return { 777 } end
end

local function quote_prototype ()
    local quote = function (operands) return { operands } end
    quote.suspend = true
    return quote
end

local app = processor_prototype ()
app (add, 1, 2, 3, 4, 5, 6, sub, 2, 3, sentinel, loop, 0, 10, 2, sentinel, sentinel, 7, 8)