# Included by headers/glib2.nim; do not import directly.
proc G_CONVERT_ERROR*(): TGQuark =
  result = g_convert_error_quark()

