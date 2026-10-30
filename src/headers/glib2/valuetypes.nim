# Included by headers/glib2.nim; do not import directly.
proc set_char*(value: PGValue, v_char: gchar){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_char".}
proc get_char*(value: PGValue): gchar{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_char".}
proc set_uchar*(value: PGValue, v_uchar: guchar){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_uchar".}
proc get_uchar*(value: PGValue): guchar{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_uchar".}
proc set_boolean*(value: PGValue, v_boolean: gboolean){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_boolean".}
proc get_boolean*(value: PGValue): gboolean{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_boolean".}
proc set_int*(value: PGValue, v_int: gint){.cdecl, dynlib: gobjectlib,
    importc: "g_value_set_int".}
proc get_int*(value: PGValue): gint{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_int".}
proc set_uint*(value: PGValue, v_uint: guint){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_uint".}
proc get_uint*(value: PGValue): guint{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_uint".}
proc set_long*(value: PGValue, v_long: glong){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_long".}
proc get_long*(value: PGValue): glong{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_long".}
proc set_ulong*(value: PGValue, v_ulong: gulong){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_ulong".}
proc get_ulong*(value: PGValue): gulong{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_ulong".}
proc set_int64*(value: PGValue, v_int64: gint64){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_int64".}
proc get_int64*(value: PGValue): gint64{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_int64".}
proc set_uint64*(value: PGValue, v_uint64: guint64){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_uint64".}
proc get_uint64*(value: PGValue): guint64{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_uint64".}
proc set_float*(value: PGValue, v_float: gfloat){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_float".}
proc get_float*(value: PGValue): gfloat{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_float".}
proc set_double*(value: PGValue, v_double: gdouble){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_double".}
proc get_double*(value: PGValue): gdouble{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_double".}
proc set_string*(value: PGValue, v_string: cstring){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_string".}
proc set_static_string*(value: PGValue, v_string: cstring){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_static_string".}
proc get_string*(value: PGValue): cstring{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_string".}
proc dup_string*(value: PGValue): cstring{.cdecl, dynlib: gobjectlib,
    importc: "g_value_dup_string".}
proc set_pointer*(value: PGValue, v_pointer: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_pointer".}
proc get_pointer*(value: PGValue): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_pointer".}
