# Included by headers/gtk2.nim; do not import directly.
type
  PCellEditable* = pointer
  TCellEditableIface* = object of TGTypeInterface
    editing_done*: proc (cell_editable: PCellEditable){.cdecl.}
    remove_widget*: proc (cell_editable: PCellEditable){.cdecl.}
    start_editing*: proc (cell_editable: PCellEditable, event: gdk2.PEvent){.cdecl.}

  PCellEditableIface* = ptr TCellEditableIface
