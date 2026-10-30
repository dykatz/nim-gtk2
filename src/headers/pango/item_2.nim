# Included by headers/pango.nim; do not import directly.
proc reorder_items*(logical_items: PGList): PGList{.cdecl, dynlib: lib,
    importc: "pango_reorder_items".}
proc item_new*(): PItem{.cdecl, dynlib: lib, importc: "pango_item_new".}
proc copy*(item: PItem): PItem{.cdecl, dynlib: lib,
                                     importc: "pango_item_copy".}
proc free*(item: PItem){.cdecl, dynlib: lib, importc: "pango_item_free".}
proc split*(orig: PItem, split_index: int32, split_offset: int32): PItem{.
    cdecl, dynlib: lib, importc: "pango_item_split".}
proc TYPE_LAYOUT*(): GType
