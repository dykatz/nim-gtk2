# Included by headers/gtk2.nim; do not import directly.
type
  TStockItem*{.final, pure.} = object
    stock_id*: cstring
    label*: cstring
    modifier*: gdk2.TModifierType
    keyval*: guint
    translation_domain*: cstring

  PStockItem* = ptr TStockItem
