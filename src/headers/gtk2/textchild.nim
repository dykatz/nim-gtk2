# Included by headers/gtk2.nim; do not import directly.
proc TEXT_CHILD_ANCHOR*(anObject: pointer): PTextChildAnchor
proc TEXT_CHILD_ANCHOR_CLASS*(klass: pointer): PTextChildAnchorClass
proc IS_TEXT_CHILD_ANCHOR*(anObject: pointer): bool
proc IS_TEXT_CHILD_ANCHOR_CLASS*(klass: pointer): bool
proc TEXT_CHILD_ANCHOR_GET_CLASS*(obj: pointer): PTextChildAnchorClass
proc text_child_anchor_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "gtk_text_child_anchor_get_type".}
proc text_child_anchor_new*(): PTextChildAnchor{.cdecl, dynlib: lib,
    importc: "gtk_text_child_anchor_new".}
proc anchor_get_widgets*(anchor: PTextChildAnchor): PGList{.cdecl,
    dynlib: lib, importc: "gtk_text_child_anchor_get_widgets".}
proc anchor_get_deleted*(anchor: PTextChildAnchor): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_text_child_anchor_get_deleted".}
proc pixbuf_segment_new*(pixbuf: gdk2pixbuf.PPixbuf): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "_gtk_pixbuf_segment_new".}
proc widget_segment_new*(anchor: PTextChildAnchor): PTextLineSegment{.cdecl,
    dynlib: lib, importc: "_gtk_widget_segment_new".}
