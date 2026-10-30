# Included by headers/gtk2.nim; do not import directly.
proc widget_new*(thetype: TType, first_property_name: cstring): PWidget{.
    importc: "gtk_widget_new", varargs, cdecl, dynlib: lib.}
proc set*(widget: PWidget, first_property_name: cstring){.varargs,
    importc: "gtk_widget_set", cdecl, dynlib: lib.}
proc queue_clear*(widget: PWidget){.importc: "gtk_widget_queue_clear",
    cdecl, dynlib: lib.}
proc queue_clear_area*(widget: PWidget, x: gint, y: gint, width: gint,
                              height: gint){.cdecl,
    importc: "gtk_widget_queue_clear_area", dynlib: lib.}
proc draw*(widget: PWidget, area: gdk2.PRectangle){.cdecl,
    importc: "gtk_widget_draw", dynlib: lib.}
proc style_get_valist*(widget: PWidget, first_property_name: cstring){.
    varargs, cdecl, importc: "gtk_widget_style_get_valist", dynlib: lib.}
proc style_get*(widget: PWidget, first_property_name: cstring){.varargs,
    cdecl, importc: "gtk_widget_style_get", dynlib: lib.}
