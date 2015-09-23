import option

type
  Link_Variant = enum
    Nil
    Link
  Linked_List*[T] = ref Linked[T]
  Linked[T] = object
    case variant: Link_Variant
    of Nil: discard
    of Link:
      left, right: Linked_List[T]
      data: Option[T]
proc New_Linked_List*[T](): Linked_List[T] =
  result = Linked_List[T](variant: Nil)
proc is_Nil*[T](self: Linked_List[T]): bool =
  result = self.variant == Nil
proc is_Link*[T](self: Linked_List[T]): bool =
  result = self.variant == Link
proc push*[T](self: var Linked_List[T], data: T): void =
  let empty = Linked_List[T](variant: Nil)
  let next = Linked_List[T](variant: Link, left: self, right: empty, data: New_Option(value = data))
  case self.variant
    of Nil:
      self = next
    of Link:
      self.right = next
      self = next
proc pop*[T](self: var Linked_List[T]): Option[T] =
  let empty = Linked_List[T](variant: Nil)
  case self.variant
    of Nil:
      result = New_Option[T]()
    of Link:
      result = self.data
      self.right = empty
      self = self.left