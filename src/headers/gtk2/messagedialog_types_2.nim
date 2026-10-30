# Included by headers/gtk2.nim; do not import directly.
type
  TMessageDialogClass* = object of TDialogClass
    reserved521: proc (){.cdecl.}
    reserved522: proc (){.cdecl.}
    reserved523: proc (){.cdecl.}
    reserved524: proc (){.cdecl.}

  PMessageDialogClass* = ptr TMessageDialogClass
