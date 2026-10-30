# Included by headers/glib2.nim; do not import directly.
const
  G_NORMALIZE_DEFAULT* = 0
const
  G_NORMALIZE_NFD* = G_NORMALIZE_DEFAULT
const
  G_NORMALIZE_DEFAULT_COMPOSE* = 1
const
  G_NORMALIZE_NFC* = G_NORMALIZE_DEFAULT_COMPOSE
const
  G_NORMALIZE_ALL* = 2
const
  G_NORMALIZE_NFKD* = G_NORMALIZE_ALL
const
  G_NORMALIZE_ALL_COMPOSE* = 3
const
  G_NORMALIZE_NFKC* = G_NORMALIZE_ALL_COMPOSE

proc g_utf8_normalize*(str: cstring, len: gssize, mode: TGNormalizeMode): cstring{.
    cdecl, dynlib: gliblib, importc: "g_utf8_normalize".}
proc g_utf8_collate*(str1: cstring, str2: cstring): gint{.cdecl,
    dynlib: gliblib, importc: "g_utf8_collate".}
proc g_utf8_collate_key*(str: cstring, len: gssize): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_collate_key".}
