# Included by headers/gtk2.nim. Public GTK2 completion inline policy.
proc entry_completion_set_inline_completion*(completion: PEntryCompletion, enabled: gboolean)
  {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_inline_completion".}
proc entry_completion_get_inline_completion*(completion: PEntryCompletion): gboolean
  {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_inline_completion".}
proc entry_completion_set_inline_selection*(completion: PEntryCompletion, enabled: gboolean)
  {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_inline_selection".}
proc entry_completion_get_inline_selection*(completion: PEntryCompletion): gboolean
  {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_inline_selection".}
proc entry_completion_get_completion_prefix*(completion: PEntryCompletion): cstring
  {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_completion_prefix".}
proc entry_completion_insert_prefix*(completion: PEntryCompletion)
  {.cdecl, dynlib: lib, importc: "gtk_entry_completion_insert_prefix".}
