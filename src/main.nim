import parseutils, strutils

echo()
echo("--- program start ---")
echo()

import option, linked_list

# type
#   Link_Variant = enum
#     Nil
#     Link
#   Linked_List*[T] = ref Linked[T]
#   Linked[T] = object
#     case variant: Link_Variant
#     of Nil: discard
#     of Link:
#       left, right: Linked_List[T]
#       data: Option[T]
# proc New_Linked_List*[T](): Linked_List[T] =
#   result = Linked_List[T](variant: Nil)
# proc push*[T](self: var Linked_List[T], data: T): void =
#   let empty = Linked_List[T](variant: Nil)
#   let next = Linked_List[T](variant: Link,
#                   left: self,
#                   right: empty,
#                   data: New_Option(value = data))
#   case self.variant
#     of Nil:
#       self = next
#     of Link:
#       self.right = next
#       self = next
# proc pop*[T](self: var Linked_List[T]): Option[T] =
#   let empty = Linked_List[T](variant: Nil)
#   case self.variant
#     of Nil:
#       result = New_Option[T]()
#     of Link:
#       result = self.data
#       self.right = empty
#       self = self.left





var list = New_Linked_List[float]()
list.push(777)
list.push(888)
list.push(999)
#echo list.pop()
#echo list.pop()

type  # should be a type variant Operator|Data -> Float|String|Sentinel
  Operator* = object
    operators: Linked_List[Operator]
    operands: Linked_List[float]
proc New_Operator*(): Operator =
  result = Operator(operators: New_Linked_List[Operator](), operands: New_Linked_List[float]())
proc execute*(self: var Operator): float =
  while(self.operands.is_Link()):
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