# Included by headers/gtk2.nim; do not import directly.
type
  TIMMulticontext* = object of TIMContext
    slave*: PIMContext
    client_window*: gdk2.PWindow
    context_id*: cstring

  PIMMulticontext* = ptr TIMMulticontext
  TIMMulticontextClass* = object of TIMContextClass
    reserved451: proc (){.cdecl.}
    reserved452: proc (){.cdecl.}
    reserved453: proc (){.cdecl.}
    reserved454: proc (){.cdecl.}

  PIMMulticontextClass* = ptr TIMMulticontextClass
