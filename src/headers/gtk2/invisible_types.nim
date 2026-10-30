# Included by headers/gtk2.nim; do not import directly.
type
  TInvisible* = object of TWidget
    has_user_ref_count*: gboolean
    screen*: gdk2.PScreen

  PInvisible* = ptr TInvisible
