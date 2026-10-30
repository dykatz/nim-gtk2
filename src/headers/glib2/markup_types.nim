# Included by headers/glib2.nim; do not import directly.
type
  TGMarkupError* = enum
    G_MARKUP_ERROR_BAD_UTF8, G_MARKUP_ERROR_EMPTY, G_MARKUP_ERROR_PARSE,
    G_MARKUP_ERROR_UNKNOWN_ELEMENT, G_MARKUP_ERROR_UNKNOWN_ATTRIBUTE,
    G_MARKUP_ERROR_INVALID_CONTENT

  PGMarkupError* = ptr TGMarkupError
