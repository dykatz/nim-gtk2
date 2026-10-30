# Included by headers/glib2.nim; do not import directly.
const
  G_TYPE_DEBUG_NONE* = 0
const
  G_TYPE_DEBUG_OBJECTS* = 1 shl 0
const
  G_TYPE_DEBUG_SIGNALS* = 1 shl 1
const
  G_TYPE_DEBUG_MASK* = 0x00000003

proc g_type_init*(){.cdecl, dynlib: gobjectlib, importc: "g_type_init".}
proc g_type_init*(debug_flags: TGTypeDebugFlags){.cdecl,
    dynlib: gobjectlib, importc: "g_type_init_with_debug_flags".}
