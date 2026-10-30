# Included by headers/pango.nim; do not import directly.
proc itemize*(context: PContext, text: cstring, start_index: int32,
              length: int32, attrs: PAttrList, cached_iter: PAttrIterator): PGList{.
    cdecl, dynlib: lib, importc: "pango_itemize".}
