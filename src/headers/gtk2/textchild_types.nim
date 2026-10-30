# Included by headers/gtk2.nim; do not import directly.
type
  TTextChildAnchor* = object of TGObject
    segment*: gpointer

  PTextChildAnchor* = ptr TTextChildAnchor
  TTextChildAnchorClass* = object of TGObjectClass
    reserved1: proc (){.cdecl.}
    reserved2: proc (){.cdecl.}
    reserved3: proc (){.cdecl.}
    reserved4: proc (){.cdecl.}

  PTextChildAnchorClass* = ptr TTextChildAnchorClass
