# Included by headers/glib2.nim; do not import directly.
proc g_boxed_copy*(boxed_type: GType, src_boxed: gconstpointer): gpointer{.
    cdecl, dynlib: gobjectlib, importc: "g_boxed_copy".}
proc g_boxed_free*(boxed_type: GType, boxed: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_boxed_free".}
proc set_boxed*(value: PGValue, v_boxed: gconstpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_boxed".}
proc set_static_boxed*(value: PGValue, v_boxed: gconstpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_static_boxed".}
proc get_boxed*(value: PGValue): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_boxed".}
proc dup_boxed*(value: PGValue): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_value_dup_boxed".}
proc g_boxed_type_register_static*(name: cstring, boxed_copy: TGBoxedCopyFunc,
                                   boxed_free: TGBoxedFreeFunc): GType{.cdecl,
    dynlib: gobjectlib, importc: "g_boxed_type_register_static".}
proc set_boxed_take_ownership*(value: PGValue, v_boxed: gconstpointer){.
    cdecl, dynlib: gobjectlib, importc: "g_value_set_boxed_take_ownership".}
proc g_closure_get_type*(): GType{.cdecl, dynlib: gobjectlib,
                                   importc: "g_closure_get_type".}
proc g_value_get_type*(): GType{.cdecl, dynlib: gobjectlib,
                                 importc: "g_value_get_type".}
