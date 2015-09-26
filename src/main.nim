import parseutils, strutils

echo()
echo("--- program start ---")
echo()

import option, dllist


var list = New_DLList[float]()
list.push(777)
list.push(888)
list.push(999)
#echo list.pop()
#echo list.pop()

type  # should be a type variant Operator|Data -> Float|String|Sentinel
  Operator* = object
    operators: DLList[Operator]
    operands: DLList[float]
proc New_Operator*(): Operator =
  result = Operator(operators: New_DLList[Operator](), operands: New_DLList[float]())
proc execute*(self: var Operator): float =
  while(self.operands.within()):
    self.operands.pop() /> option: result += option.value
proc feed*(self: var Operator, operand: Operator): void =
  self.operators.push(operand)
proc feed*(self: var Operator, operand: float): void =
  self.operands.push(operand)
  if(operand == 0):
    echo(self.execute())

var operator = New_Operator()
operator.feed(777)
operator.feed(888)
operator.feed(999)
operator.feed(0)  # sentinel
# echo(operator.execute())

# operator.operands.pop() /> option: echo(option.value)

var test = 1000.0
list.pop() /> option: test += option.value
echo("test: ", test)
list.pop() /> option: test += option.value
echo("test: ", test)
list.pop() /> option: test += option.value
echo("test: ", test)
list.pop() /> option: test += option.value
echo("test: ", test)


echo()
echo("--- program end ---")
echo()