type
  Option_Variant = enum
    Some
    None
  Option*[T] = object
    case variant: Option_Variant
    of None: discard
    of Some:
      value: T
proc New_Option*[T](): Option[T] = Option[T](variant: None)
proc New_Option*[T](value: T): Option[T] = Option[T](variant: Some, value: value)
template `/>`* (option, placeholder: expr, body: stmt): stmt {.immediate.} =
  block:
    var placeholder = option
    case placeholder.variant
    of Some:
      body
    of None: discard