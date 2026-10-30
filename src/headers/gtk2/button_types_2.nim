# Included by headers/gtk2.nim; do not import directly.
type
  TButtonClass* = object of TBinClass
    pressed*: proc (button: PButton){.cdecl.}
    released*: proc (button: PButton){.cdecl.}
    clicked*: proc (button: PButton){.cdecl.}
    enter*: proc (button: PButton){.cdecl.}
    leave*: proc (button: PButton){.cdecl.}
    activate*: proc (button: PButton){.cdecl.}
    reserved101: proc (){.cdecl.}
    reserved102: proc (){.cdecl.}
    reserved103: proc (){.cdecl.}
    reserved104: proc (){.cdecl.}

  PButtonClass* = ptr TButtonClass
