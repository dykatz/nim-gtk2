# Included by headers/gtk2.nim; do not import directly.
proc drag_source_handle_event*(widget: PWidget, event: gdk2.PEvent){.cdecl,
    dynlib: lib, importc: "_gtk_drag_source_handle_event".}
proc drag_dest_handle_event*(toplevel: PWidget, event: gdk2.PEvent){.cdecl,
    dynlib: lib, importc: "_gtk_drag_dest_handle_event".}
