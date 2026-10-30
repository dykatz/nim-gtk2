# Included by headers/gdk2.nim; do not import directly.
type
  TKeymapKey*{.final, pure.} = object
    keycode*: guint
    group*: gint
    level*: gint

  PKeymapKey* = ptr TKeymapKey
