# Included by headers/gtk2.nim; do not import directly.
proc reorder_child*(box: PBox, child: PWidget, position: gint){.cdecl,
    dynlib: lib, importc: "gtk_box_reorder_child".}
proc query_child_packing*(box: PBox, child: PWidget, expand: Pgboolean,
                              fill: Pgboolean, padding: Pguint,
                              pack_type: PPackType){.cdecl, dynlib: lib,
    importc: "gtk_box_query_child_packing".}
proc set_child_packing*(box: PBox, child: PWidget, expand: gboolean,
                            fill: gboolean, padding: guint, pack_type: TPackType){.
    cdecl, dynlib: lib, importc: "gtk_box_set_child_packing".}
