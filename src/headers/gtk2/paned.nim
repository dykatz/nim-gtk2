# Included by headers/gtk2.nim; do not import directly.
proc TYPE_PANED*(): GType
proc PANED*(obj: pointer): PPaned
proc PANED_CLASS*(klass: pointer): PPanedClass
proc IS_PANED*(obj: pointer): bool
proc IS_PANED_CLASS*(klass: pointer): bool
proc PANED_GET_CLASS*(obj: pointer): PPanedClass
proc position_set*(a: PPaned): guint
proc set_position_set*(a: PPaned, `position_set`: guint)
proc in_drag*(a: PPaned): guint
proc set_in_drag*(a: PPaned, `in_drag`: guint)
proc child1_shrink*(a: PPaned): guint
proc set_child1_shrink*(a: PPaned, `child1_shrink`: guint)
proc child1_resize*(a: PPaned): guint
proc set_child1_resize*(a: PPaned, `child1_resize`: guint)
proc child2_shrink*(a: PPaned): guint
proc set_child2_shrink*(a: PPaned, `child2_shrink`: guint)
proc child2_resize*(a: PPaned): guint
proc set_child2_resize*(a: PPaned, `child2_resize`: guint)
proc orientation*(a: PPaned): guint
proc set_orientation*(a: PPaned, `orientation`: guint)
proc in_recursion*(a: PPaned): guint
proc set_in_recursion*(a: PPaned, `in_recursion`: guint)
proc handle_prelit*(a: PPaned): guint
proc set_handle_prelit*(a: PPaned, `handle_prelit`: guint)
proc paned_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_paned_get_type".}
proc add1*(paned: PPaned, child: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_paned_add1".}
proc add2*(paned: PPaned, child: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_paned_add2".}
proc pack1*(paned: PPaned, child: PWidget, resize: gboolean,
                  shrink: gboolean){.cdecl, dynlib: lib,
                                     importc: "gtk_paned_pack1".}
proc pack2*(paned: PPaned, child: PWidget, resize: gboolean,
                  shrink: gboolean){.cdecl, dynlib: lib,
                                     importc: "gtk_paned_pack2".}
proc get_child1*(paned: PPaned): PWidget {.cdecl, dynlib: lib,
    importc: "gtk_paned_get_child1".}
proc get_child2*(paned: PPaned): PWidget {.cdecl, dynlib: lib,
    importc: "gtk_paned_get_child2".}
proc get_position*(paned: PPaned): gint{.cdecl, dynlib: lib,
    importc: "gtk_paned_get_position".}
proc set_position*(paned: PPaned, position: gint){.cdecl, dynlib: lib,
    importc: "gtk_paned_set_position".}
proc compute_position*(paned: PPaned, allocation: gint, child1_req: gint,
                             child2_req: gint){.cdecl, dynlib: lib,
    importc: "gtk_paned_compute_position".}
proc TYPE_HBUTTON_BOX*(): GType
