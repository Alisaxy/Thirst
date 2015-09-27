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

type  # should be a type variant Operator|Float|String|Sentinel
  Operand_Variant = enum
    Op
    Number
    Symbol
    Sentinel
  Operand* = object
    case variant: Operand_Variant
    of Op:
      operator: Option[Operator]
    of Number:
      number: Option[float]
    of Symbol:
      symbol: Option[string]
    of Sentinel: discard
  Operator* = object
    operators: DLList[Operator]
    operands: DLList[float]
proc get*[T](self: Operand): Option[T] =
  case self.variant
  of Op: result = self.operator
  of Number: result = self.number
  of Symbol: result = self.symbol
  of Sentinel: result = New_Option[T]()

proc New_Operand*[T: Operator|float|string](data: T): Operand =
  if T is Operator: result = Operand(variant: Op, operator: New_Option(data)) #"Operator".echo()
  elif T is float: result = Operand(variant: Number, number: New_Option(data)) #"float".echo()
  elif T is string: result = Operand(variant: Symbol, symbol: New_Option(data)) #"string".echo()

#discard New_Operand[float](777.0)
#discard New_Operand[float]()
#discard New_Operand[string]()

proc New_Operator*(): Operator = Operator(operators: New_DLList[Operator](), operands: New_DLList[float]())
proc run*(self: var Operator): float =
  while(self.operands.within()):
    self.operands.pop() /> option: result += option.value
proc feed*(self: var Operator, operand: Operator): void =
  self.operators.push(operand)
proc feed*(self: var Operator, operand: float): void =
  self.operands.push(operand)
  if(operand == 0): self.run().echo()

var operator = New_Operator()
operator.feed(777)
operator.feed(888)
operator.feed(999)
operator.feed(0)  # sentinel

var test = 1000.0
let test_echo = "test: "
list.pop() /> option: test += option.value
test_echo.echo(test)
list.pop() /> option: test += option.value
test_echo.echo(test)
list.pop() /> option: test += option.value
test_echo.echo(test)
list.pop() /> option: test += option.value
test_echo.echo(test)


echo()
echo("--- program end ---")
echo()