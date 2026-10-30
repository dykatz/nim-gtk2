# Included by headers/gtk2.nim; do not import directly.
type
  TItemClass* = object of TBinClass
    select*: proc (item: PItem){.cdecl.}
    deselect*: proc (item: PItem){.cdecl.}
    toggle*: proc (item: PItem){.cdecl.}
    reserved161: proc (){.cdecl.}
    reserved162: proc (){.cdecl.}
    reserved163: proc (){.cdecl.}
    reserved164: proc (){.cdecl.}

  PItemClass* = ptr TItemClass
