# Included by headers/gtk2.nim; do not import directly.
proc accel_map_add_entry*(accel_path: cstring, accel_key: guint,
                          accel_mods: gdk2.TModifierType){.cdecl, dynlib: lib,
    importc: "gtk_accel_map_add_entry".}
proc accel_map_lookup_entry*(accel_path: cstring, key: PAccelKey): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_accel_map_lookup_entry".}
proc accel_map_change_entry*(accel_path: cstring, accel_key: guint,
                             accel_mods: gdk2.TModifierType, replace: gboolean): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_accel_map_change_entry".}
proc accel_map_load*(file_name: cstring){.cdecl, dynlib: lib,
    importc: "gtk_accel_map_load".}
proc accel_map_save*(file_name: cstring){.cdecl, dynlib: lib,
    importc: "gtk_accel_map_save".}
proc accel_map_foreach*(data: gpointer, foreach_func: TAccelMapForeach){.cdecl,
    dynlib: lib, importc: "gtk_accel_map_foreach".}
proc accel_map_load_fd*(fd: gint){.cdecl, dynlib: lib,
                                   importc: "gtk_accel_map_load_fd".}
proc accel_map_load_scanner*(scanner: PGScanner){.cdecl, dynlib: lib,
    importc: "gtk_accel_map_load_scanner".}
proc accel_map_save_fd*(fd: gint){.cdecl, dynlib: lib,
                                   importc: "gtk_accel_map_save_fd".}
proc accel_map_add_filter*(filter_pattern: cstring){.cdecl, dynlib: lib,
    importc: "gtk_accel_map_add_filter".}
proc accel_map_foreach_unfiltered*(data: gpointer,
                                   foreach_func: TAccelMapForeach){.cdecl,
    dynlib: lib, importc: "gtk_accel_map_foreach_unfiltered".}
proc accel_map_init*(){.cdecl, dynlib: lib, importc: "_gtk_accel_map_init".}
