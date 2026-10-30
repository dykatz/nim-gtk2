# Included by headers/gtk2.nim; do not import directly.
type
  THandleBoxClass* = object of TBinClass
    child_attached*: proc (handle_box: PHandleBox, child: PWidget){.cdecl.}
    child_detached*: proc (handle_box: PHandleBox, child: PWidget){.cdecl.}
    reserved341: proc (){.cdecl.}
    reserved342: proc (){.cdecl.}
    reserved343: proc (){.cdecl.}
    reserved344: proc (){.cdecl.}

  PHandleBoxClass* = ptr THandleBoxClass
