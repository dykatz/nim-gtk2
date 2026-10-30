# Included by headers/gdk2.nim; do not import directly.
proc atom_intern*(atom_name: cstring, only_if_exists: gboolean): TAtom{.cdecl,
    dynlib: lib, importc: "gdk_atom_intern".}
proc atom_name*(atom: TAtom): cstring{.cdecl, dynlib: lib,
                                       importc: "gdk_atom_name".}
proc property_get*(window: PWindow, `property`: TAtom, `type`: TAtom,
                   offset: gulong, length: gulong, pdelete: gint,
                   actual_property_type: PAtom, actual_format: Pgint,
                   actual_length: Pgint, data: PPguchar): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_property_get".}
proc property_change*(window: PWindow, `property`: TAtom, `type`: TAtom,
                      format: gint, mode: TPropMode, data: Pguchar,
                      nelements: gint){.cdecl, dynlib: lib,
                                        importc: "gdk_property_change".}
proc property_delete*(window: PWindow, `property`: TAtom){.cdecl, dynlib: lib,
    importc: "gdk_property_delete".}
proc text_property_to_text_list_for_display*(display: PDisplay, encoding: TAtom,
    format: gint, text: Pguchar, length: gint, t: var PPgchar): gint{.cdecl,
    dynlib: lib, importc: "gdk_text_property_to_text_list_for_display".}
proc text_property_to_utf8_list_for_display*(display: PDisplay, encoding: TAtom,
    format: gint, text: Pguchar, length: gint, t: var PPgchar): gint{.cdecl,
    dynlib: lib, importc: "gdk_text_property_to_utf8_list_for_display".}
proc utf8_to_string_target*(str: cstring): cstring{.cdecl, dynlib: lib,
    importc: "gdk_utf8_to_string_target".}
proc string_to_compound_text_for_display*(display: PDisplay, str: cstring,
    encoding: PAtom, format: Pgint, ctext: PPguchar, length: Pgint): gint{.
    cdecl, dynlib: lib, importc: "gdk_string_to_compound_text_for_display".}
proc utf8_to_compound_text_for_display*(display: PDisplay, str: cstring,
                                        encoding: PAtom, format: Pgint,
                                        ctext: PPguchar, length: Pgint): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_utf8_to_compound_text_for_display".}
proc free_text_list*(list: PPgchar){.cdecl, dynlib: lib,
                                     importc: "gdk_free_text_list".}
proc free_compound_text*(ctext: Pguchar){.cdecl, dynlib: lib,
    importc: "gdk_free_compound_text".}
