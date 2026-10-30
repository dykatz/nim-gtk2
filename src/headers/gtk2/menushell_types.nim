# Included by headers/gtk2.nim; do not import directly.
type
  TMenuShell* = object of TContainer
    children*: PGList
    active_menu_item*: PWidget
    parent_menu_shell*: PWidget
    button*: guint
    activate_time*: guint32
    MenuShell_flag0*: guint16

  PMenuShell* = ptr TMenuShell
