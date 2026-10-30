# Included by headers/glib2.nim; do not import directly.
proc g_quark_to_string*(quark: TGQuark): cstring{.cdecl, dynlib: gliblib,
    importc: "g_quark_to_string".}
const
  G_MEM_ALIGN* = GLIB_SIZEOF_VOID_P

