# Included by headers/gdk2.nim; do not import directly.
proc KEYMAP*(anObject: pointer): PKeymap
proc KEYMAP_CLASS*(klass: pointer): PKeymapClass
proc IS_KEYMAP*(anObject: pointer): bool
proc IS_KEYMAP_CLASS*(klass: pointer): bool
proc KEYMAP_GET_CLASS*(obj: pointer): PKeymapClass
proc keymap_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "gdk_keymap_get_type".}
proc keymap_get_for_display*(display: PDisplay): PKeymap{.cdecl, dynlib: lib,
    importc: "gdk_keymap_get_for_display".}
proc lookup_key*(keymap: PKeymap, key: PKeymapKey): guint{.cdecl,
    dynlib: lib, importc: "gdk_keymap_lookup_key".}
proc translate_keyboard_state*(keymap: PKeymap, hardware_keycode: guint,
                                      state: TModifierType, group: gint,
                                      keyval: Pguint, effective_group: Pgint,
                                      level: Pgint,
                                      consumed_modifiers: PModifierType): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_keymap_translate_keyboard_state".}
proc get_entries_for_keyval*(keymap: PKeymap, keyval: guint,
                                    s: var PKeymapKey, n_keys: Pgint): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_keymap_get_entries_for_keyval".}
proc get_entries_for_keycode*(keymap: PKeymap, hardware_keycode: guint,
                                     s: var PKeymapKey, sasdf: var Pguint,
                                     n_entries: Pgint): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_keymap_get_entries_for_keycode".}
proc get_direction*(keymap: PKeymap): TDirection{.cdecl,
    dynlib: lib, importc: "gdk_keymap_get_direction".}
proc keymap_get_default* ():PKeyMap{.cdecl, dynlib: lib,
    importc: "gdk_keymap_get_default".}
proc keymap_have_bidi_layouts* (keymap: PKeyMap):gboolean{.cdecl, dynlib: lib,
    importc: "gdk_keymap_have_bidi_layouts".}
proc keymap_translate_keyboard_state* (keymap: gdk2.PKeyMap, hardware_keycode: cuint,
      state: gdk2.TModifierType, group: gint, keyval: Pguint, effective_group: Pgint,
      level: Pgint,consumed_modifiers: gdk2.PModifierType): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_keymap_translate_keyboard_state".}
proc keymap_add_virtual_modifiers* (keymap: gdk2.PKeyMap, state: gdk2.PModifierType){.cdecl, dynlib: lib,
    importc: "gdk_keymap_add_virtual_modifiers".}
proc keymap_map_virtual_modifiers* (keymap: gdk2.PKeyMap, state: gdk2.PModifierType){.cdecl, dynlib: lib,
    importc: "gdk_keymap_map_virtual_modifiers".}
proc keymap_get_entries_for_keyval* (keymap: PKeymap, keyval: guint,
    s: ptr array[20,PKeymapKey], n_keys: Pgint): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_keymap_get_entries_for_keyval".}
proc keyval_name*(keyval: guint): cstring{.cdecl, dynlib: lib,
    importc: "gdk_keyval_name".}
proc keyval_from_name*(keyval_name: cstring): guint{.cdecl, dynlib: lib,
    importc: "gdk_keyval_from_name".}
proc keyval_convert_case*(symbol: guint, lower: Pguint, upper: Pguint){.cdecl,
    dynlib: lib, importc: "gdk_keyval_convert_case".}
proc keyval_to_upper*(keyval: guint): guint{.cdecl, dynlib: lib,
    importc: "gdk_keyval_to_upper".}
proc keyval_to_lower*(keyval: guint): guint{.cdecl, dynlib: lib,
    importc: "gdk_keyval_to_lower".}
proc keyval_is_upper*(keyval: guint): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_keyval_is_upper".}
proc keyval_is_lower*(keyval: guint): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_keyval_is_lower".}
proc keyval_to_unicode*(keyval: guint): guint32{.cdecl, dynlib: lib,
    importc: "gdk_keyval_to_unicode".}
proc unicode_to_keyval*(wc: guint32): guint{.cdecl, dynlib: lib,
    importc: "gdk_unicode_to_keyval".}
