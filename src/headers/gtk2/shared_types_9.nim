# Included by headers/gtk2.nim; do not import directly.
# Private GTK logical line, retained only as an opaque pointer for remaining
# separately scoped TextLayout signatures. Never allocate/dereference its body.
type
  TTextLine = object
  PTextLine* = ptr TTextLine
