# Included by headers/glib2.nim; do not import directly.
proc G_SHELL_ERROR*(): TGQuark =
  result = g_shell_error_quark()

proc G_SPAWN_ERROR*(): TGQuark =
  result = g_spawn_error_quark()

