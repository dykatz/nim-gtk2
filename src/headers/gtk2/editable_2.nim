# Included by headers/gtk2.nim; do not import directly.
proc TYPE_EDITABLE*(): GType =
  result = editable_get_type()

proc EDITABLE*(obj: pointer): PEditable =
  result = cast[PEditable](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_EDITABLE()))

proc EDITABLE_CLASS*(vtable: pointer): PEditableClass =
  result = cast[PEditableClass](G_TYPE_CHECK_CLASS_CAST(vtable, TYPE_EDITABLE()))

proc IS_EDITABLE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_EDITABLE())

proc IS_EDITABLE_CLASS*(vtable: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(vtable, TYPE_EDITABLE())

proc EDITABLE_GET_CLASS*(inst: pointer): PEditableClass =
  result = cast[PEditableClass](G_TYPE_INSTANCE_GET_INTERFACE(inst,
      TYPE_EDITABLE()))

