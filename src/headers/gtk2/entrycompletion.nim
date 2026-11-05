# Included by headers/gtk2.nim. Public GTK2.24 completion API, opaque GObject.
type
  TEntryCompletion* {.pure, final, incompleteStruct.} = object
  PEntryCompletion* = ptr TEntryCompletion
proc entry_completion_get_type*(): GType {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_type".}
proc entry_completion_new*(): PEntryCompletion {.cdecl, dynlib: lib, importc: "gtk_entry_completion_new".}
proc entry_set_completion*(entry: PEntry, completion: PEntryCompletion) {.cdecl, dynlib: lib, importc: "gtk_entry_set_completion".}
proc entry_get_completion*(entry: PEntry): PEntryCompletion {.cdecl, dynlib: lib, importc: "gtk_entry_get_completion".}
proc entry_completion_get_entry*(completion: PEntryCompletion): PWidget {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_entry".}
proc entry_completion_set_model*(completion: PEntryCompletion, model: PTreeModel) {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_model".}
proc entry_completion_get_model*(completion: PEntryCompletion): PTreeModel {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_model".}
proc entry_completion_set_text_column*(completion: PEntryCompletion, column: gint) {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_text_column".}
proc entry_completion_get_text_column*(completion: PEntryCompletion): gint {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_text_column".}
proc entry_completion_complete*(completion: PEntryCompletion) {.cdecl, dynlib: lib, importc: "gtk_entry_completion_complete".}
proc entry_completion_set_minimum_key_length*(completion: PEntryCompletion, length: gint) {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_minimum_key_length".}
proc entry_completion_get_minimum_key_length*(completion: PEntryCompletion): gint {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_minimum_key_length".}
proc entry_completion_set_popup_completion*(completion: PEntryCompletion, enabled: gboolean) {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_popup_completion".}
proc entry_completion_get_popup_completion*(completion: PEntryCompletion): gboolean {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_popup_completion".}
proc entry_completion_set_popup_set_width*(completion: PEntryCompletion, enabled: gboolean) {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_popup_set_width".}
proc entry_completion_get_popup_set_width*(completion: PEntryCompletion): gboolean {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_popup_set_width".}
proc entry_completion_set_popup_single_match*(completion: PEntryCompletion, enabled: gboolean) {.cdecl, dynlib: lib, importc: "gtk_entry_completion_set_popup_single_match".}
proc entry_completion_get_popup_single_match*(completion: PEntryCompletion): gboolean {.cdecl, dynlib: lib, importc: "gtk_entry_completion_get_popup_single_match".}
