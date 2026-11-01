# Included by headers/gtk2.nim; do not import directly.
type
  TFileFilter {.pure, final, incompleteStruct.} = object
  PFileFilter* = ptr TFileFilter
  PPGtkFileFilter* = ptr PFileFilter
  TFileFilterFlags* = distinct cint
  PFileFilterFlags* = ptr TFileFilterFlags
  TFileFilterInfo* {.final, pure.} = object
    contains*: TFileFilterFlags
    filename*: cstring
    uri*: cstring
    display_name*: cstring
    mime_type*: cstring
  PFileFilterInfo* = ptr TFileFilterInfo
const
  FILE_FILTER_FILENAME* = TFileFilterFlags(1 shl 0)
  FILE_FILTER_URI* = TFileFilterFlags(1 shl 1)
  FILE_FILTER_DISPLAY_NAME* = TFileFilterFlags(1 shl 2)
  FILE_FILTER_MIME_TYPE* = TFileFilterFlags(1 shl 3)
proc `==`*(a, b: TFileFilterFlags): bool {.borrow.}
proc `or`*(a, b: TFileFilterFlags): TFileFilterFlags = TFileFilterFlags(cint(a) or cint(b))
proc `and`*(a, b: TFileFilterFlags): TFileFilterFlags = TFileFilterFlags(cint(a) and cint(b))
proc `xor`*(a, b: TFileFilterFlags): TFileFilterFlags = TFileFilterFlags(cint(a) xor cint(b))
proc `not`*(a: TFileFilterFlags): TFileFilterFlags = TFileFilterFlags(not cint(a))
