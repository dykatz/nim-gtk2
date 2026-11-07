# Included by headers/gtk2.nim. GTK2.24 public entry-icon API.
type TEntryIconPosition* {.size: sizeof(cint).} = enum
  ENTRY_ICON_PRIMARY, ENTRY_ICON_SECONDARY
proc entry_set_icon_from_pixbuf*(entry: PEntry, pos: TEntryIconPosition, pixbuf: gdk2pixbuf.PPixbuf) {.cdecl, dynlib: lib, importc: "gtk_entry_set_icon_from_pixbuf".}
proc entry_set_icon_from_icon_name*(entry: PEntry, pos: TEntryIconPosition, name: cstring) {.cdecl, dynlib: lib, importc: "gtk_entry_set_icon_from_icon_name".}
proc entry_get_icon_storage_type*(entry: PEntry, pos: TEntryIconPosition): TImageType {.cdecl, dynlib: lib, importc: "gtk_entry_get_icon_storage_type".}
proc entry_get_icon_pixbuf*(entry: PEntry, pos: TEntryIconPosition): gdk2pixbuf.PPixbuf {.cdecl, dynlib: lib, importc: "gtk_entry_get_icon_pixbuf".}
proc entry_get_icon_name*(entry: PEntry, pos: TEntryIconPosition): cstring {.cdecl, dynlib: lib, importc: "gtk_entry_get_icon_name".}
proc entry_set_icon_sensitive*(entry: PEntry, pos: TEntryIconPosition, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_entry_set_icon_sensitive".}
proc entry_get_icon_sensitive*(entry: PEntry, pos: TEntryIconPosition): gboolean {.cdecl, dynlib: lib, importc: "gtk_entry_get_icon_sensitive".}
proc entry_set_icon_activatable*(entry: PEntry, pos: TEntryIconPosition, value: gboolean) {.cdecl, dynlib: lib, importc: "gtk_entry_set_icon_activatable".}
proc entry_get_icon_activatable*(entry: PEntry, pos: TEntryIconPosition): gboolean {.cdecl, dynlib: lib, importc: "gtk_entry_get_icon_activatable".}
proc entry_set_icon_tooltip_text*(entry: PEntry, pos: TEntryIconPosition, text: cstring) {.cdecl, dynlib: lib, importc: "gtk_entry_set_icon_tooltip_text".}
proc entry_get_icon_tooltip_text*(entry: PEntry, pos: TEntryIconPosition): cstring {.cdecl, dynlib: lib, importc: "gtk_entry_get_icon_tooltip_text".}
proc entry_get_icon_window*(entry: PEntry, pos: TEntryIconPosition): gdk2.PWindow {.cdecl, dynlib: lib, importc: "gtk_entry_get_icon_window".}
proc is_sensitive*(widget: PWidget): gboolean {.cdecl, dynlib: lib, importc: "gtk_widget_is_sensitive".}
