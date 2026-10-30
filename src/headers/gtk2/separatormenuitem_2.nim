# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SEPARATOR_MENU_ITEM*(): GType =
  result = separator_menu_item_get_type()

proc SEPARATOR_MENU_ITEM*(obj: pointer): PSeparatorMenuItem =
  result = cast[PSeparatorMenuItem](CHECK_CAST(obj, TYPE_SEPARATOR_MENU_ITEM()))

proc SEPARATOR_MENU_ITEM_CLASS*(klass: pointer): PSeparatorMenuItemClass =
  result = cast[PSeparatorMenuItemClass](CHECK_CLASS_CAST(klass,
      TYPE_SEPARATOR_MENU_ITEM()))

proc IS_SEPARATOR_MENU_ITEM*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SEPARATOR_MENU_ITEM())

proc IS_SEPARATOR_MENU_ITEM_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SEPARATOR_MENU_ITEM())

proc SEPARATOR_MENU_ITEM_GET_CLASS*(obj: pointer): PSeparatorMenuItemClass =
  result = cast[PSeparatorMenuItemClass](CHECK_GET_CLASS(obj,
      TYPE_SEPARATOR_MENU_ITEM()))

proc signal_lookup*(name: cstring, object_type: GType): guint =
  result = g_signal_lookup(name, object_type)

proc signal_name*(signal_id: guint): cstring =
  result = g_signal_name(signal_id)

proc signal_emit_stop*(instance: gpointer, signal_id: guint, detail: TGQuark) =
  if detail != 0'u32: g_signal_stop_emission(instance, signal_id, 0)

