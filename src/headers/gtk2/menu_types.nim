# Included by headers/gtk2.nim; do not import directly.
type
  TMenuClass* = object of TMenuShellClass
    reserved281: proc (){.cdecl.}
    reserved282: proc (){.cdecl.}
    reserved283: proc (){.cdecl.}
    reserved284: proc (){.cdecl.}

  PMenuClass* = ptr TMenuClass
