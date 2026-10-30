# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_EDITABLE*(): GType =
  result = cell_editable_get_type()

proc CELL_EDITABLE*(obj: pointer): PCellEditable =
  result = cast[PCellEditable](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_CELL_EDITABLE()))

proc CELL_EDITABLE_CLASS*(obj: pointer): PCellEditableIface =
  result = cast[PCellEditableIface](G_TYPE_CHECK_CLASS_CAST(obj,
      TYPE_CELL_EDITABLE()))

proc IS_CELL_EDITABLE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_CELL_EDITABLE())

proc CELL_EDITABLE_GET_IFACE*(obj: pointer): PCellEditableIface =
  result = cast[PCellEditableIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_CELL_EDITABLE()))

