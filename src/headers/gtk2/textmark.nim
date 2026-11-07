# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_MARK*(): GType
proc TEXT_MARK*(anObject: pointer): PTextMark
proc TEXT_MARK_CLASS*(klass: pointer): PTextMarkClass
proc IS_TEXT_MARK*(anObject: pointer): bool
proc IS_TEXT_MARK_CLASS*(klass: pointer): bool
proc TEXT_MARK_GET_CLASS*(obj: pointer): PTextMarkClass
proc text_mark_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "gtk_text_mark_get_type".}
proc set_visible*(mark: PTextMark, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_text_mark_set_visible".}
proc get_visible*(mark: PTextMark): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_mark_get_visible".}
proc get_name*(mark: PTextMark): cstring{.cdecl, dynlib: lib,
    importc: "gtk_text_mark_get_name".}
proc get_deleted*(mark: PTextMark): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_mark_get_deleted".}
proc get_buffer*(mark: PTextMark): PTextBuffer{.cdecl, dynlib: lib,
    importc: "gtk_text_mark_get_buffer".}
proc get_left_gravity*(mark: PTextMark): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_mark_get_left_gravity".}
proc text_mark_new*(name: cstring, left_gravity: gboolean): PTextMark {.cdecl,
    dynlib: lib, importc: "gtk_text_mark_new".}
proc add_mark*(buffer: PTextBuffer, mark: PTextMark, where: PTextIter) {.cdecl,
    dynlib: lib, importc: "gtk_text_buffer_add_mark".}
