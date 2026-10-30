# Included by headers/gtk2.nim; do not import directly.
proc gc_get*(depth: gint, colormap: gdk2.PColormap, values: gdk2.PGCValues,
             values_mask: gdk2.TGCValuesMask): gdk2.PGC{.cdecl, dynlib: lib,
    importc: "gtk_gc_get".}
proc gc_release*(gc: gdk2.PGC){.cdecl, dynlib: lib, importc: "gtk_gc_release".}
const
  bm_TGtkHandleBox_handle_position* = 0x0003'u16
const
  bp_TGtkHandleBox_handle_position* = 0'u16
const
  bm_TGtkHandleBox_float_window_mapped* = 0x0004'u16
const
  bp_TGtkHandleBox_float_window_mapped* = 2'u16
const
  bm_TGtkHandleBox_child_detached* = 0x0008'u16
const
  bp_TGtkHandleBox_child_detached* = 3'u16
const
  bm_TGtkHandleBox_in_drag* = 0x0010'u16
const
  bp_TGtkHandleBox_in_drag* = 4'u16
const
  bm_TGtkHandleBox_shrink_on_detach* = 0x0020'u16
const
  bp_TGtkHandleBox_shrink_on_detach* = 5'u16
const
  bm_TGtkHandleBox_snap_edge* = 0x01C0'u16
const
  bp_TGtkHandleBox_snap_edge* = 6'u16

