# Included by headers/gtk2.nim; do not import directly.
proc accel_map_add_group*(accel_path: cstring, accel_group: PAccelGroup){.cdecl,
    dynlib: lib, importc: "_gtk_accel_map_add_group".}
proc accel_map_remove_group*(accel_path: cstring, accel_group: PAccelGroup){.
    cdecl, dynlib: lib, importc: "_gtk_accel_map_remove_group".}
proc accel_path_is_valid*(accel_path: cstring): gboolean{.cdecl, dynlib: lib,
    importc: "_gtk_accel_path_is_valid".}
