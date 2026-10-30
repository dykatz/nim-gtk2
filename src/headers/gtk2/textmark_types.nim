# Included by headers/gtk2.nim; do not import directly.
type
  TTextMark* = object of TGObject
    segment*: gpointer

  PTextMark* = ptr TTextMark
  TTextMarkClass* = object of TGObjectClass
    reserved1: proc (){.cdecl.}
    reserved2: proc (){.cdecl.}
    reserved3: proc (){.cdecl.}
    reserved4: proc (){.cdecl.}

  PTextMarkClass* = ptr TTextMarkClass
