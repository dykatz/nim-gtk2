# Included by headers/gtk2.nim; do not import directly.
type
  TColorSelectionClass* = object of TVBoxClass
    color_changed*: proc (color_selection: PColorSelection){.cdecl.}
    reserved211: proc (){.cdecl.}
    reserved212: proc (){.cdecl.}
    reserved213: proc (){.cdecl.}
    reserved214: proc (){.cdecl.}

  PColorSelectionClass* = ptr TColorSelectionClass
