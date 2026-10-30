# Included by headers/glib2.nim; do not import directly.
proc G_MARKUP_ERROR*(): TGQuark =
  result = g_markup_error_quark()

