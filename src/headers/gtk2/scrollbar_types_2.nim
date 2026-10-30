# Included by headers/gtk2.nim; do not import directly.
type
  TScrollbarClass* = object of TRangeClass
    reserved421: proc (){.cdecl.}
    reserved422: proc (){.cdecl.}
    reserved423: proc (){.cdecl.}
    reserved424: proc (){.cdecl.}

  PScrollbarClass* = ptr TScrollbarClass
