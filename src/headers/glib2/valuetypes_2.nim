# Included by headers/glib2.nim; do not import directly.
proc strdup_value_contents*(value: PGValue): cstring{.cdecl,
    dynlib: gobjectlib, importc: "g_strdup_value_contents".}
proc set_string_take_ownership*(value: PGValue, v_string: cstring){.
    cdecl, dynlib: gobjectlib, importc: "g_value_set_string_take_ownership".}
