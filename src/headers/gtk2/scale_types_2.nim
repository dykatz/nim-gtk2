# Included by headers/gtk2.nim; do not import directly.
type
  TScaleClass* = object of TRangeClass
    format_value*: proc (scale: PScale, value: gdouble): cstring{.cdecl.}
    draw_value*: proc (scale: PScale){.cdecl.}
    reserved411: proc (){.cdecl.}
    reserved412: proc (){.cdecl.}
    reserved413: proc (){.cdecl.}
    reserved414: proc (){.cdecl.}

  PScaleClass* = ptr TScaleClass
