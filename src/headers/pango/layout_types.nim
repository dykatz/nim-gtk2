# Included by headers/pango.nim; do not import directly.
type
  TLayout* {.pure, final.} = object
  PLayout* = ptr TLayout
  TLayoutClass* {.pure, final.} = object
  PLayoutClass* = ptr TLayoutClass
  TLayoutIter* {.pure, final.} = object
  PLayoutIter* = ptr TLayoutIter
  TAlignment* = enum
    ALIGN_LEFT, ALIGN_CENTER, ALIGN_RIGHT
  PAlignment* = ptr TAlignment
  TWrapMode* = enum
    WRAP_WORD, WRAP_CHAR
  PWrapMode* = ptr TWrapMode
  TLayoutLine*{.final, pure.} = object
    layout*: PLayout
    start_index*: gint
    length*: gint
    runs*: PGSList

  PLayoutLine* = ptr TLayoutLine
