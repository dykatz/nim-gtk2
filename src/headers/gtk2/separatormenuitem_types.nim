# Included by headers/gtk2.nim; do not import directly.
type
  TSeparatorMenuItem* = object of TMenuItem
  PSeparatorMenuItem* = ptr TSeparatorMenuItem
  TSeparatorMenuItemClass* = object of TMenuItemClass
  PSeparatorMenuItemClass* = ptr TSeparatorMenuItemClass
