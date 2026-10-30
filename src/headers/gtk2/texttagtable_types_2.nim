# Included by headers/gtk2.nim; do not import directly.
type
  TTextTagTableClass* = object of TGObjectClass
    tag_changed*: proc (table: PTextTagTable, tag: PTextTag,
                        size_changed: gboolean){.cdecl.}
    tag_added*: proc (table: PTextTagTable, tag: PTextTag){.cdecl.}
    tag_removed*: proc (table: PTextTagTable, tag: PTextTag){.cdecl.}
    reserved1: proc (){.cdecl.}
    reserved2: proc (){.cdecl.}
    reserved3: proc (){.cdecl.}
    reserved4: proc (){.cdecl.}

  PTextTagTableClass* = ptr TTextTagTableClass
