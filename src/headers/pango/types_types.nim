# Included by headers/pango.nim; do not import directly.
type
  TContext* {.pure, final.} = object
  PContext* = ptr TContext
  TLanguage* {.pure, final.} = object
  PLanguage* = ptr TLanguage
  TRectangle*{.final, pure.} = object
    x*: int32
    y*: int32
    width*: int32
    height*: int32

  PRectangle* = ptr TRectangle
