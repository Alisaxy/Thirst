# an effort to implement doubly-linked lists with dynamic dispatching
# instead of object variants, Nim evidently sucks ass at this at the present moment
# weird compilation problems that break dynamic dispatching entirely
# the same thing happens when using as an import
# probably best to just go with object variants
# they're probably faster anyway

#import parseutils, strutils
import typetraits, option

echo()
echo("--- program start ---")
echo()

type
  DLList = ref object of RootObj
    discard
  Link[T] = ref object of DLList not nil
    left, right: DLList
    data: Option[T]
  Nil = ref object of DLList not nil
    discard

proc New_DLList*(): DLList = Nil()

method data*[T](self: DLList): Option[T] =
  self.type.name.echo(" by data method")
  New_Option[T]()
method data*[T](self: Link[T]): Option[T] = 
  self.type.name.echo(" by data method")
  self.data

method sentinel*(self: DLList): bool =
  self.type.name.echo(" by sentinel method")
  false
method sentinel*(self: Nil): bool =
  self.type.name.echo(" by sentinel method")
  true

proc make_next[T](self: DLList, data: T): Link[T] =
  self.type.name.echo(" by make_next proc")
  Link[float](left: self, data: data.New_Option(), right: Nil())
method push*[T](self: var DLList, data: T): void =
  self.type.name.echo(" by push method")
  self = make_next[T](self, data)
method push*[T](self: var Link[T], data: T): void =
  self.type.name.echo(" by push method")
  let next = make_next[T](self, data)
  self.right = next
  self = next

method clear_right[T](self: var DLList): void = discard
method clear_right[T](self: var Link[T]): void = self.left = Nil()

method pop*[T](identity: DLList, self: var DLList): Option[T] =
  identity.type.name.echo(" by pop method")
  New_Option[T]()
method pop*[T](identity: Link[T], self: var DLList): Option[T] = 
  identity.type.name.echo(" by pop method")
  result = identity.data
  clear_right[T](identity.left)
  self = identity.left

var list: DLList = New_DLList()
push[float](list, 777)
push[float](list, 888)
data[float](list) /> option: pop[float](list, list).value.echo()
data[float](list) /> option: pop[float](list, list).value.echo()
data[float](list) /> option: pop[float](list, list).value.echo()

push[float](list, 56465)
push[float](list, 1000)

data[float](list) /> option: pop[float](list, list).value.echo()

echo()
echo("--- program end ---")
echo()