# Included by headers/glib2.nim; do not import directly.
proc g_try_malloc*(n_bytes: gulong): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_try_malloc".}
proc g_try_realloc*(mem: gpointer, n_bytes: gulong): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_try_realloc".}
#proc g_new*(bytes_per_struct, n_structs: gsize): gpointer
#proc g_new0*(bytes_per_struct, n_structs: gsize): gpointer
#proc g_renew*(struct_size: gsize, OldMem: gpointer, n_structs: gsize): gpointer

proc set_vtable*(vtable: PGMemVTable){.cdecl, dynlib: gliblib,
    importc: "g_mem_set_vtable".}
proc g_mem_is_system_malloc*(): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_mem_is_system_malloc".}
proc g_mem_profile*(){.cdecl, dynlib: gliblib, importc: "g_mem_profile".}
proc g_chunk_new*(chunk: pointer): pointer
proc g_chunk_new0*(chunk: pointer): pointer

const
  G_ALLOC_ONLY* = 1
const
  G_ALLOC_AND_FREE* = 2

proc g_mem_chunk_new*(name: cstring, atom_size: gint, area_size: gulong,
                      theType: gint): PGMemChunk{.cdecl, dynlib: gliblib,
    importc: "g_mem_chunk_new".}
proc chunk_destroy*(mem_chunk: PGMemChunk){.cdecl, dynlib: gliblib,
    importc: "g_mem_chunk_destroy".}
proc chunk_alloc*(mem_chunk: PGMemChunk): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_mem_chunk_alloc".}
proc chunk_alloc0*(mem_chunk: PGMemChunk): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_mem_chunk_alloc0".}
proc chunk_free*(mem_chunk: PGMemChunk, mem: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_mem_chunk_free".}
proc chunk_clean*(mem_chunk: PGMemChunk){.cdecl, dynlib: gliblib,
    importc: "g_mem_chunk_clean".}
proc chunk_reset*(mem_chunk: PGMemChunk){.cdecl, dynlib: gliblib,
    importc: "g_mem_chunk_reset".}
proc chunk_print*(mem_chunk: PGMemChunk){.cdecl, dynlib: gliblib,
    importc: "g_mem_chunk_print".}
proc g_mem_chunk_info*(){.cdecl, dynlib: gliblib, importc: "g_mem_chunk_info".}
proc g_blow_chunks*(){.cdecl, dynlib: gliblib, importc: "g_blow_chunks".}
proc g_allocator_new*(name: cstring, n_preallocs: guint): PGAllocator{.cdecl,
    dynlib: gliblib, importc: "g_allocator_new".}
proc free*(allocator: PGAllocator){.cdecl, dynlib: gliblib,
    importc: "g_allocator_free".}
const
  G_ALLOCATOR_LIST* = 1
const
  G_ALLOCATOR_SLIST* = 2
const
  G_ALLOCATOR_NODE* = 3

proc slist_push_allocator*(allocator: PGAllocator){.cdecl, dynlib: gliblib,
    importc: "g_slist_push_allocator".}
proc g_slist_pop_allocator*(){.cdecl, dynlib: gliblib,
                               importc: "g_slist_pop_allocator".}
