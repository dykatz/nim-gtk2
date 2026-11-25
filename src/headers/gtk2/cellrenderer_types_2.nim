# Included by headers/gtk2.nim; do not import directly.
type
  TCellRendererClass* = object of TObjectClass
    get_size*: proc (cell: PCellRenderer, widget: PWidget,
                     cell_area: gdk2.PRectangle, x_offset: Pgint, y_offset: Pgint,
                     width: Pgint, height: Pgint){.cdecl.}
    render*: proc (cell: PCellRenderer, window: gdk2.PDrawable, widget: PWidget,
                   background_area: gdk2.PRectangle, cell_area: gdk2.PRectangle,
                   expose_area: gdk2.PRectangle, flags: TCellRendererState){.cdecl.}
    activate*: proc (cell: PCellRenderer, event: gdk2.PEvent, widget: PWidget,
                     path: cstring, background_area: gdk2.PRectangle,
                     cell_area: gdk2.PRectangle, flags: TCellRendererState): gboolean{.
        cdecl.}
    start_editing*: proc (cell: PCellRenderer, event: gdk2.PEvent,
                          widget: PWidget, path: cstring,
                          background_area: gdk2.PRectangle,
                          cell_area: gdk2.PRectangle, flags: TCellRendererState): PCellEditable{.
        cdecl.}
    editing_canceled*: proc (cell: PCellRenderer) {.cdecl.}
    editing_started*: proc (cell: PCellRenderer, editable: PCellEditable, path: cstring) {.cdecl.}
    reserved1, reserved2: proc () {.cdecl.}

  PCellRendererClass* = ptr TCellRendererClass
