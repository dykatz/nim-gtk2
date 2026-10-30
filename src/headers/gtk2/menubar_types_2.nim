# Included by headers/gtk2.nim; do not import directly.
type
  TMenuBarClass* = object of TMenuShellClass
    reserved511: proc (){.cdecl.}
    reserved512: proc (){.cdecl.}
    reserved513: proc (){.cdecl.}
    reserved514: proc (){.cdecl.}

  PMenuBarClass* = ptr TMenuBarClass
