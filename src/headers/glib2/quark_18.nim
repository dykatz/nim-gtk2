# Included by headers/glib2.nim; do not import directly.
proc G_IO_CHANNEL_ERROR*(): TGQuark =
  result = g_io_channel_error_quark()

