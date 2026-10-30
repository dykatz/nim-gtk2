# Included by headers/glib2.nim; do not import directly.
proc g_string_chunk_new*(size: gsize): PGStringChunk{.cdecl, dynlib: gliblib,
    importc: "g_string_chunk_new".}
proc chunk_free*(chunk: PGStringChunk){.cdecl, dynlib: gliblib,
    importc: "g_string_chunk_free".}
proc chunk_insert*(chunk: PGStringChunk, str: cstring): cstring{.cdecl,
    dynlib: gliblib, importc: "g_string_chunk_insert".}
proc chunk_insert_const*(chunk: PGStringChunk, str: cstring): cstring{.
    cdecl, dynlib: gliblib, importc: "g_string_chunk_insert_const".}
