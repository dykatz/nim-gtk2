# Included by headers/glib2.nim; do not import directly.
type
  TGShellError* = enum
    G_SHELL_ERROR_BAD_QUOTING, G_SHELL_ERROR_EMPTY_STRING, G_SHELL_ERROR_FAILED

  PGShellError* = ptr TGShellError
