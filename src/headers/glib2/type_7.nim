# Included by headers/glib2.nim; do not import directly.
proc g_pointer_type_register_static*(name: cstring): GType{.cdecl,
    dynlib: gobjectlib, importc: "g_pointer_type_register_static".}
