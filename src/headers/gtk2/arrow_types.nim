# Included by headers/gtk2.nim; do not import directly.
type
  TArrow* = object of TMisc
    arrow_type*: gint16
    shadow_type*: gint16

  PArrow* = ptr TArrow
