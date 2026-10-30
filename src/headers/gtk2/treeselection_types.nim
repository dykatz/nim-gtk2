# Included by headers/gtk2.nim; do not import directly.
type
  TTreeSelectionClass* = object of TGObjectClass
    changed*: proc (selection: PTreeSelection){.cdecl.}
    reserved741: proc (){.cdecl.}
    reserved742: proc (){.cdecl.}
    reserved743: proc (){.cdecl.}
    reserved744: proc (){.cdecl.}

  PTreeSelectionClass* = ptr TTreeSelectionClass
