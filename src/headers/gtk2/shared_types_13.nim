# Included by headers/gtk2.nim; do not import directly.
type
  TImageData* {.union.} = object
     pixbuf*: PPixbuf
     stock_id*: cstring
     icon_name*: cstring
     gicon*: pointer
