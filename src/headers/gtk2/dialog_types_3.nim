# Included by headers/gtk2.nim; do not import directly.
type
  TDialogClass* = object of TWindowClass
    response*: proc (dialog: PDialog, response_id: gint){.cdecl.}
    closeFile*: proc (dialog: PDialog){.cdecl.}
    reserved201: proc (){.cdecl.}
    reserved202: proc (){.cdecl.}
    reserved203: proc (){.cdecl.}
    reserved204: proc (){.cdecl.}

  PDialogClass* = ptr TDialogClass
