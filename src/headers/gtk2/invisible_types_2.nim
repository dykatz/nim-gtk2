# Included by headers/gtk2.nim; do not import directly.
type
  TInvisibleClass* = object of TWidgetClass
    reserved701: proc (){.cdecl.}
    reserved702: proc (){.cdecl.}
    reserved703: proc (){.cdecl.}
    reserved704: proc (){.cdecl.}

  PInvisibleClass* = ptr TInvisibleClass
