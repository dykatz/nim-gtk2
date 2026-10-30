# Included by headers/gtk2.nim; do not import directly.
type
  TMenuItemClass* = object of TItemClass
    MenuItemClass_flag0*: guint16
    activate*: proc (menu_item: PMenuItem){.cdecl.}
    activate_item*: proc (menu_item: PMenuItem){.cdecl.}
    toggle_size_request*: proc (menu_item: PMenuItem, requisition: Pgint){.cdecl.}
    toggle_size_allocate*: proc (menu_item: PMenuItem, allocation: gint){.cdecl.}
    reserved171: proc (){.cdecl.}
    reserved172: proc (){.cdecl.}
    reserved173: proc (){.cdecl.}
    reserved174: proc (){.cdecl.}

  PMenuItemClass* = ptr TMenuItemClass
