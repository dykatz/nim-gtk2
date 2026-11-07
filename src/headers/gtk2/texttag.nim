# Included by headers/gtk2.nim; do not import directly.
# Public native APIs only. No private GtkTextTag bitfield helpers/masks.
proc TYPE_TEXT_TAG*(): GType
proc TEXT_TAG*(obj: pointer): PTextTag
proc TEXT_TAG_CLASS*(klass: pointer): PTextTagClass
proc IS_TEXT_TAG*(obj: pointer): bool
proc IS_TEXT_TAG_CLASS*(klass: pointer): bool
proc TEXT_TAG_GET_CLASS*(obj: pointer): PTextTagClass
proc TYPE_TEXT_ATTRIBUTES*(): GType
proc text_tag_get_type*(): GType{.cdecl, dynlib: lib, importc: "gtk_text_tag_get_type".}
proc text_tag_new*(name: cstring): PTextTag{.cdecl, dynlib: lib, importc: "gtk_text_tag_new".}
proc get_priority*(tag: PTextTag): gint{.cdecl, dynlib: lib, importc: "gtk_text_tag_get_priority".}
proc set_priority*(tag: PTextTag, priority: gint){.cdecl, dynlib: lib, importc: "gtk_text_tag_set_priority".}
proc event*(tag: PTextTag, event_object: PGObject, event: gdk2.PEvent,
    iter: PTextIter): gboolean{.cdecl, dynlib: lib, importc: "gtk_text_tag_event".}
proc text_attributes_new*(): PTextAttributes{.cdecl, dynlib: lib, importc: "gtk_text_attributes_new".}
proc copy*(src: PTextAttributes): PTextAttributes{.cdecl, dynlib: lib, importc: "gtk_text_attributes_copy".}
proc copy_values*(src: PTextAttributes, dest: PTextAttributes){.cdecl, dynlib: lib, importc: "gtk_text_attributes_copy_values".}
proc unref*(values: PTextAttributes){.cdecl, dynlib: lib, importc: "gtk_text_attributes_unref".}
proc reference*(values: PTextAttributes): PTextAttributes {.cdecl, dynlib: lib, importc: "gtk_text_attributes_ref".}
proc text_attributes_get_type*(): GType{.cdecl, dynlib: lib, importc: "gtk_text_attributes_get_type".}
