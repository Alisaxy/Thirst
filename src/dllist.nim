import option

type
  Link_Variant = enum
    Sentinel
    Link
  DLList*[T] = ref Linked[T]
  Linked[T] = object
    case variant: Link_Variant
    of Sentinel: discard
    of Link:
      left, right: DLList[T]
      data: Option[T]
proc New_DLList*[T](): DLList[T] = DLList[T](variant: Sentinel)
proc within*[T](self: DLList[T]): bool = self.variant == Link
proc push*[T](self: var DLList[T], data: T): void =
  let empty = DLList[T](variant: Sentinel)
  let next = DLList[T](variant: Link, left: self, right: empty, data: New_Option(value = data))
  case self.variant
    of Sentinel:
      self = next
    of Link:
      self.right = next
      self = next
proc pop*[T](self: var DLList[T]): Option[T] =
  let empty = DLList[T](variant: Sentinel)
  case self.variant
    of Sentinel:
      result = New_Option[T]()
    of Link:
      result = self.data
      self.right = empty
      self = self.left