# Included by headers/gtk2.nim; do not import directly.
proc requisition_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "gtk_requisition_get_type".}
proc copy*(requisition: PRequisition): PRequisition{.cdecl,
    dynlib: lib, importc: "gtk_requisition_copy".}
proc free*(requisition: PRequisition){.cdecl, dynlib: lib,
    importc: "gtk_requisition_free".}
proc get_aux_info*(widget: PWidget, create: gboolean): PWidgetAuxInfo{.
    cdecl, dynlib: lib, importc: "gtk_widget_get_aux_info".}
proc propagate_hierarchy_changed*(widget: PWidget,
    previous_toplevel: PWidget){.cdecl, dynlib: lib, importc: "_gtk_widget_propagate_hierarchy_changed".}
proc widget_peek_colormap*(): gdk2.PColormap{.cdecl, dynlib: lib,
    importc: "_gtk_widget_peek_colormap".}
proc set_no_show_all*(widget: PWidget, no_show_all: gboolean) {.cdecl,
    importc: "gtk_widget_set_no_show_all", dynlib: lib.}
proc get_no_show_all*(widget: PWidget): gboolean {.cdecl,
    importc: "gtk_widget_get_no_show_all", dynlib: lib.}
