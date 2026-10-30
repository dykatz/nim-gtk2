# Included by headers/glib2.nim; do not import directly.
proc next*(slist: PGSList): PGSList =
  if slist != nil:
    result = slist.next
  else:
    result = nil

proc g_new*(bytes_per_struct, n_structs: gulong): gpointer =
  result = g_malloc(n_structs * bytes_per_struct)

proc g_new0*(bytes_per_struct, n_structs: gulong): gpointer =
  result = g_malloc0(n_structs * bytes_per_struct)

proc g_renew*(struct_size: gulong, OldMem: gpointer, n_structs: gulong): gpointer =
  result = g_realloc(OldMem, struct_size * n_structs)

proc g_chunk_new*(chunk: pointer): pointer =
  result = chunk_alloc(chunk)

proc g_chunk_new0*(chunk: pointer): pointer =
  result = chunk_alloc0(chunk)

