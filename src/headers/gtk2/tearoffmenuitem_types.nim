# Included by headers/gtk2.nim; do not import directly.
type
  TTearoffMenuItem* = object of TMenuItem
    TearoffMenuItem_flag0*: guint16

  PTearoffMenuItem* = ptr TTearoffMenuItem
  TTearoffMenuItemClass* = object of TMenuItemClass
    reserved651: proc (){.cdecl.}
    reserved652: proc (){.cdecl.}
    reserved653: proc (){.cdecl.}
    reserved654: proc (){.cdecl.}

  PTearoffMenuItemClass* = ptr TTearoffMenuItemClass
