# Included by headers/gtk2.nim; do not import directly.
type
  TTextTag* = object of TGObject
    table*: PTextTagTable
    name*: cstring
    priority*: int32
    values*: PTextAttributes
    TextTag_flag0*: uint32

  PTextTag* = ptr TTextTag
  PPGtkTextTag* = ptr PTextTag
  TTextTagClass* = object of TGObjectClass
    event*: proc (tag: PTextTag, event_object: PGObject, event: gdk2.PEvent,
                  iter: PTextIter): gboolean{.cdecl.}
    reserved661: proc (){.cdecl.}
    reserved662: proc (){.cdecl.}
    reserved663: proc (){.cdecl.}
    reserved664: proc (){.cdecl.}

  PTextTagClass* = ptr TTextTagClass
