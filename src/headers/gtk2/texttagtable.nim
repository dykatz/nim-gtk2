# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_TAG_TABLE*(): GType
proc TEXT_TAG_TABLE*(obj: pointer): PTextTagTable
proc TEXT_TAG_TABLE_CLASS*(klass: pointer): PTextTagTableClass
proc IS_TEXT_TAG_TABLE*(obj: pointer): bool
proc IS_TEXT_TAG_TABLE_CLASS*(klass: pointer): bool
proc TEXT_TAG_TABLE_GET_CLASS*(obj: pointer): PTextTagTableClass
proc text_tag_table_get_type*(): GType{.cdecl, dynlib: lib,
                                        importc: "gtk_text_tag_table_get_type".}
proc text_tag_table_new*(): PTextTagTable{.cdecl, dynlib: lib,
    importc: "gtk_text_tag_table_new".}
proc table_add*(table: PTextTagTable, tag: PTextTag){.cdecl,
    dynlib: lib, importc: "gtk_text_tag_table_add".}
proc table_remove*(table: PTextTagTable, tag: PTextTag){.cdecl,
    dynlib: lib, importc: "gtk_text_tag_table_remove".}
proc table_lookup*(table: PTextTagTable, name: cstring): PTextTag{.
    cdecl, dynlib: lib, importc: "gtk_text_tag_table_lookup".}
proc table_foreach*(table: PTextTagTable, fun: TTextTagTableForeach,
                             data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_text_tag_table_foreach".}
proc table_get_size*(table: PTextTagTable): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_tag_table_get_size".}
proc table_add_buffer*(table: PTextTagTable, buffer: gpointer){.cdecl,
    dynlib: lib, importc: "_gtk_text_tag_table_add_buffer".}
proc table_remove_buffer*(table: PTextTagTable, buffer: gpointer){.
    cdecl, dynlib: lib, importc: "_gtk_text_tag_table_remove_buffer".}
